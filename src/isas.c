#include "ask.h"
#include "abb.h"

const static struct {const char * const str; const int sexp;}
AbbCoerceTable[] = {
  {"num",	REALSXP},  {"chr", STRSXP}, {"int", INTSXP},  {"lgl",	LGLSXP},
  {"nil",	NILSXP},   {"sym", SYMSXP}, {"env", ENVSXP},  {"dbl",	REALSXP},
  {"cmp",	CPLXSXP},  {"any", ANYSXP}, {"exp", EXPRSXP}, {"lst",	VECSXP},
  {"lng", LANGSXP},  {"raw", RAWSXP}, {"s4", S4SXP},    {"name", SYMSXP},
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
  bool ans = false;
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
  case ANYABB:
  default: ans = TYPEOF(x) == str2sexp(fml);
  };
  if(negate) ans = !ans;
  return Rf_ScalarLogical(ans);
}


S isas(S x, S fml) {
  switch(TYPEOF(fml)) {
  case SYMSXP: return is(x, fml, false);                      // x ? t
  case LANGSXP: {
    S fun = CAR(fml);                                         // ?+, ?- {free}
    return fun == Rf_install("!") ?
      is(x, CADR(fml), true) :                                // x ?! t
      as(x, fml);                                             // x ?~ t
  }
  default: return Rf_ScalarLogical(0); // NULL ? NULL opens help, always false
  }
}