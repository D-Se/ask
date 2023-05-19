#include "ask.h"
#include "abb.h"
// as

const static struct {const char * const str; const int sexp;}
AbbCoerceTable[] = {
  {"num",	REALSXP},  {"chr", STRSXP}, {"int", INTSXP},  {"lgl",	LGLSXP},
  {"nil",	NILSXP},   {"sym", SYMSXP}, {"env", ENVSXP},  {"dbl",	REALSXP},
  {"cmp",	CPLXSXP},  {"any", ANYSXP}, {"exp", EXPRSXP}, {"lst",	VECSXP},
  {"lng", LANGSXP}, {"raw", RAWSXP}, {"s4", S4SXP},    {"name", SYMSXP},
  {(char *)NULL, -1}
};

SEXPTYPE str2sexp(S abb) {
  const char *s = CHAR(PRINTNAME(abb));
  for (int i = 0; AbbCoerceTable[i].str; i++) {
    if (!strcmp(s, AbbCoerceTable[i].str))
      return (SEXPTYPE) AbbCoerceTable[i].sexp;
  }
  err("Abbreviation not found");                           // x ?~ bla
}

S as(S x, S fml) {
  S abb = CADR(fml);
  SEXPTYPE t = TYPEOF(abb);
  switch(t) {
  case SYMSXP: return Rf_coerceVector(x, str2sexp(abb));    // x ?~ abb
  default: return Rf_coerceVector(x, t);                    // x ?~ ""
  }
}

// is

ABB str2abb(S abb) {
  const char *s = CHAR(PRINTNAME(abb));
  for (int i = 0; AbbCheckTable[i].str; i++) {
    if (!strcmp(s, AbbCheckTable[i].str))
      return (ABB) AbbCheckTable[i].abb;
  }
  err("Abbreviation not found");                           // x ?~ bla
}

S is(S x, S fml, bool negate) {
  bool res = false;
  switch(str2abb(fml)) {
  // atomic
  case NILABB: res = isNull(x); break;
  case INTABB: res = isInteger(x); break;
  case LGLABB: res = isLogical(x); break;
  case DBLABB: res = isReal(x); break;
  case CHRABB:
  case STRABB: res = isString(x); break;
  case CPLABB: res = isComplex(x); break;
  case RAWABB: res = TYPEOF(x) == RAWSXP; break;
  // bunch
  case LSTABB: {
    res = TYPEOF(x) == LISTSXP || (LENGTH(x) == 0 && TYPEOF(x) == VECSXP);
  }; break; // isList includes NULL, breaks on empty list()
  case DFABB :
  case DFRABB: res = isFrame(x); break;
  case ENVABB: res = isEnvironment(x); break;
  case VECABB: res = isVector(x); break;
  case MTXABB: res = isMatrix(x); break;
  case ARRABB: res = isArray(x); break;
  case TSABB: res = isTs(x); break;
  case FCTABB: res = isFactor(x); break;
  case ORDABB: res = isOrdered(x); break;
  case TABABB: res = Rf_inherits(x, "table"); break;
  case NUMABB: res = isNumber(x); break; // isNumeric excludes CPLSXP
  // language & programming
  case SYMABB: res = isSymbol(x); break;
  case LNGABB: res = isLanguage(x); break; // only LANGSXP
  //case CLOABB: res = ??
  case FUNABB: res = isFunction(x); break;
  case EXPABB: res = isExpression(x); break;
  case FMLABB: res = isFormula(x); break;
  // value & states
  //case NAABB: res = R_IsNA(x); break;
  //case NANABB: res = ISNAN(REAL(x)[0]); break;
  //case FINABB: res = isfinite(REAL(x)[0]); break;
  //case S3ABB: res = IS_S4_OBJECT(x) != 0; break;
  case S4ABB: res = isS4(x); break;
  //case ATMABB: res = isAtomic(x); break;
  // third-party
  // case TBLABB: Rf_inherits(x, "tbl"); break;
  case ANYABB:
  default: res = TYPEOF(x) == str2sexp(fml);
  };
  if(negate) res = !res;

  return Rf_ScalarLogical(res);
}

S isas(S x, S fml) {
  switch(TYPEOF(fml)) {
  case SYMSXP: return is(x, fml, false);                      // x ? t
  case LANGSXP: {
    S fun = CAR(fml); // ?+, ?-
    return fun == Rf_install("!") ?
      is(x, CADR(fml), true) :                                // x ?! t
      as(x, fml);                                             // x ?~ t
  }
  default: return Rf_ScalarLogical(0); // NULL ? NULL opens help, always false
  }
}
