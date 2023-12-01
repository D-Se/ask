#include "ask.h"
#include "abb.h"

const static struct {char const * const str; const int sexp;}
AsTable[] = {
  {"num",	REALSXP},  {"chr", STRSXP}, {"int", INTSXP},  {"lgl",	LGLSXP},
  {"nil",	NILSXP},   {"sym", SYMSXP}, {"env", ENVSXP},  {"dbl",	REALSXP},
  {"cmp",	CPLXSXP},  {"any", ANYSXP}, {"exp", EXPRSXP}, {"lst",	VECSXP},
  {"lng", LANGSXP},  {"raw", RAWSXP}, {"s4", S4SXP},    {"name", SYMSXP},
  {(char *)NULL, -1}
};

SEXPTYPE str2sexp(S abb) {
  const char *s = CHAR(PRINTNAME(abb));
  for (int i = 0; AsTable[i].str; ++i) {
    if (!strcmp(s, AsTable[i].str)) return (SEXPTYPE) AsTable[i].sexp;
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

ABB str2abb(S abb) {
  const char *s = CHAR(PRINTNAME(abb));
  for (int i = 0; IsTable[i].str; ++i) {
    if (!strcmp(s, IsTable[i].str)) return (ABB) IsTable[i].abb;
  }
  err("Abbreviation not found");                            // x ? bla
}
S is(S x, S fml, bool negate) {
  bool ans = false;
  if (TYPEOF(fml) != SYMSXP) {                              // x ?! ""
    ans = TYPEOF(x) == TYPEOF(fml);
    if(negate) ans = !ans;
    return Rf_ScalarLogical(ans);
  }
  switch(str2abb(fml)) {
  // atomic
  case NILABB: ans = isNull(x);                 break;
  case INTABB: ans = isInteger(x);              break;
  case LGLABB: ans = isLogical(x);              break;
  case DBLABB: ans = isReal(x);                 break;
  case CHRABB:
  case STRABB: ans = isString(x);               break;
  case CPLABB: ans = isComplex(x);              break;
  case RAWABB: ans = TYPEOF(x) == RAWSXP;       break;
  // bunch
  case LSTABB: {
    ans = (TYPEOF(x) == VECSXP || TYPEOF(x) == LISTSXP);
    // isList includes NULL, breaks on empty list()
    // ans = TYPEOF(x) == LISTSXP || (LENGTH(x) == 0 && TYPEOF(x) == VECSXP);
  };                                          break;
  case DFABB :
  case DFRABB: ans = isFrame(x);                break;
  case ENVABB: ans = isEnvironment(x);          break;
  case VECABB: ans = isVector(x);               break;
  case MTXABB: ans = isMatrix(x);               break;
  case ARRABB: ans = isArray(x);                break;
  case TSABB: ans = isTs(x);                    break;
  case FCTABB: ans = isFactor(x);               break;
  case ORDABB: ans = isOrdered(x);              break;
  case TABABB: ans = Rf_inherits(x, "table");   break;
  case NUMABB: ans = isNumber(x);               break; // isNumeric omits CPLSXP
  case SYMABB: ans = isSymbol(x);               break;
  case LNGABB: ans = isLanguage(x);             break; // only LANGSXP
  //case CLOABB: res = ??
  case FUNABB: ans = isFunction(x);             break;
  case EXPABB: ans = isExpression(x);           break;
  case FMLABB: ans = isFormula(x);              break;
  case S4ABB: ans = isS4(x);                    break;
  //case ATMABB: ans = isAtomic(x); break;
  // third-party
  // case TBLABB: Rf_inherits(x, "tbl"); break;
  // case ANYABB: for completeness, but only in C API
  default: ans = TYPEOF(x) == str2sexp(fml); // #nocov should never be reached
  };
  if(negate) ans = !ans;
  return Rf_ScalarLogical(ans);
}

S isas(S x, S fml) {
  switch(TYPEOF(fml)) {
  case SYMSXP: return is(x, fml, false);                    // x ? t
  case LANGSXP: {
    S fun = CAR(fml);
    return fun == Rf_install("!") ?                         // ??, ?+, ?- free
      is(x, CADR(fml), true) :                              // x ?! t
      as(x, fml);                                           // x ?~ t
  }
  default: return Rf_ScalarLogical(TYPEOF(x) == TYPEOF(fml));
  }
}
