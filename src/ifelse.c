// `vector_if` is governed by MPL 2 (http://mozilla.org/MPL/2.0/). Modified from
// data.table, ©Matt Dowle 2023.

#include "ask.h"

static inline bool IsFormula(SEXP x) {
  return TYPEOF(x) == LANGSXP && Rf_inherits(x, "formula");
}

static inline S ENV(S fml) {
  return Rf_getAttrib(fml, Rf_install(".Environment"));
}

static inline S lhs(S fml) {
  if (IsFormula(fml)) {
    switch(Rf_length(fml)) {
    case 2: return R_NilValue; // F ?~ 1
    case 3: return Rf_eval(CADR(fml), ENV(fml)); // T ? x ~ y
    default: err("Malformed `~` in `?`.");
    };
  } else {
    return fml; // T ? 1, default NULL rhs value from R `?`
  }
}

static inline S rhs(S fml) {
  if (IsFormula(fml)) {
    switch(Rf_length(fml)) {
    //case 1: return R_NilValue; // void else
    case 2: return Rf_eval(CADR(fml), ENV(fml)); // ~x
    case 3: return Rf_eval(CADDR(fml), ENV(fml)); // x ~ y
    default: err("Malformed `~` in `?`.");
    };
  } else {
    return R_NilValue;
  }
}

static inline S scalar_if(S x, S fml) {
  int cond = NA_LOGICAL;
  cond = LOGICAL(x)[0];
  if (cond == NA_LOGICAL) err("Missing value where T/F needed");
  return cond ? lhs(fml) : rhs(fml);
}

// pseudo-generic loop body macro to make loop_TYPE
#define loop_core(name, T, FUN, NA_TYPE)      \
static inline void loop_##name(               \
  S ans, S a, S b, int64_t lx, bool naa,      \
  bool nab, int64_t ma, int64_t mb,           \
  const int*restrict px, bool openmp) {       \
  T *restrict pans = FUN(ans);                \
  const T *restrict pa = naa ? NULL : FUN(a), \
          *restrict pb = nab ? NULL : FUN(b), \
          na = NA_TYPE;                       \
  /*OpenMP if-clause, SO41450756, regresses*/ \
  if(openmp) {                                \
    OMP_FOR(lx)                               \
    for (int64_t i = 0; i < lx; ++i) {        \
      pans[i] = px[i] == 0 ?                  \
        (nab ? na : pb[i & mb]) :             \
        px[i] == 1 ?                          \
        (naa ? na : pa[i & ma]) :             \
        na;                                   \
    }                                         \
  } else {                                    \
    for (int64_t i = 0; i < lx; ++i) {        \
      pans[i] = px[i] == 0 ?                  \
        (nab ? na : pb[i & mb]) :             \
        px[i] == 1 ?                          \
        (naa ? na : pa[i & ma]) :             \
        na;                                   \
    }                                         \
  }                                           \
}

loop_core(LGL, int,    INTEGER, NA_LOGICAL)
loop_core(INT, int,    INTEGER, NA_INTEGER)
loop_core(NUM, double, REAL,    NA_REAL)
Rcomplex temp() {Rcomplex x = {.r = NA_REAL, .i = NA_REAL}; return x;}
loop_core(CPL, Rcomplex, COMPLEX, temp())

static inline S vector_if(S x, S fml) {
  // l - length, p - pointer, t - type, m - mask
  const S a = PROTECT(lhs(fml)),
          b = PROTECT(rhs(fml));

  const int64_t lx = Rf_xlength(x),
                la = Rf_xlength(a),
                lb = Rf_xlength(b);

  const SEXPTYPE ta = TYPEOF(a),
                 tb = TYPEOF(b);

  // omit length check to support nested (case_when) behavior.
  if (la != lb) err("Mismatch lhs and rhs: Length.");
  if (ta != tb) err("Mismatch lhs and rhs: Type.");

  const bool naa = la == 1 && ta == LGLSXP && LOGICAL(a)[0] == NA_LOGICAL,
             nab = lb == 1 && tb == LGLSXP && LOGICAL(b)[0] == NA_LOGICAL,
             omp = lx > 10000;

  const int64_t ma = la > 1 ? INT64_MAX : 0,
                mb = lb > 1 ? INT64_MAX : 0;

  const int *restrict px = LOGICAL(x);
  S ans = PROTECT(allocVector(ta, lx));
  copyMostAttrib(a, ans);

  switch(ta) {
  case LGLSXP : loop_LGL(ans, a, b, lx, naa, nab, ma, mb, px, omp); break;
  case INTSXP : loop_INT(ans, a, b, lx, naa, nab, ma, mb, px, omp); break;
  case REALSXP: loop_NUM(ans, a, b, lx, naa, nab, ma, mb, px, omp); break;
  case CPLXSXP: loop_CPL(ans, a, b, lx, naa, nab, ma, mb, px, omp); break;
  case STRSXP : {
    const S *restrict pa = naa ? NULL : STRING_PTR(a),
            *restrict pb = nab ? NULL : STRING_PTR(b),
            na = NA_STRING;
    for (int64_t i = 0; i < lx; ++i) {
      SET_STRING_ELT(ans, i,
                  px[i] == 0 ?
                  (nab ? na : pb[i & mb]) :
                  px[i] == 1 ?
                  (naa ? na : pa[i & ma]) :
                  na
      );
    }
  } break;
  case VECSXP: {
    const S *restrict pa = naa ? NULL : SEXPPTR_RO(a),
            *restrict pb = nab ? NULL : SEXPPTR_RO(b);
    for (int64_t i = 0; i < lx; ++i) {
      if (px[i] == NA_LOGICAL) {
        SET_VECTOR_ELT(ans, i, R_NilValue);
      } else if (px[i] == 0) {
        if (!nab) SET_VECTOR_ELT(ans, i, pb[i & mb]);
      } else if (px[i] == 1) {
        if (!naa) SET_VECTOR_ELT(ans, i, pa[i & ma]);
      }
    }
  } break;
  default:
    err("Unsupported lhs or rhs type.");
  }
  S names = PROTECT(getAttrib(x, R_NamesSymbol));
  if (!isNull(names)) setAttrib(ans, R_NamesSymbol, names);
  UNPROTECT(4);
  return ans;
}

S ifelse(S x, S fml) {
  switch(LENGTH(x)) {
  case 0: err("Length zero argument.");
  case 1: return scalar_if(x, fml);
  default: return vector_if(x, fml);
  }
}
