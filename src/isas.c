#include "ask.h"

const static struct {
  const char * const abb;
  const int type;
}
AbbCoerceTable[] = {
  {"num",	REALSXP},  {"chr", STRSXP}, {"int", INTSXP},  {"lgl",	LGLSXP},
  {"nil",	NILSXP},   {"smb", SYMSXP}, {"env", ENVSXP},  {"dbl",	REALSXP},
  {"cmp",	CPLXSXP},  {"any", ANYSXP}, {"exp", EXPRSXP}, {"lst",	VECSXP},
  {"lang", LANGSXP}, {"raw", RAWSXP}, {"s4", S4SXP},    {"name", SYMSXP},
  {(char *)NULL, -1}
};

SEXPTYPE abb2type(S abb) {
  const char *s;
  s = CHAR(PRINTNAME(abb));
  int i;
  for (i = 0; AbbCoerceTable[i].abb; i++) {
    if (!strcmp(s, AbbCoerceTable[i].abb))
      return (SEXPTYPE) AbbCoerceTable[i].type;
  }
  err("Abbreviation not found");                           // x ?~ bla
}

S is(S x, S fml, bool negate) {
  bool res = TYPEOF(x) == abb2type(fml);
  if(negate) res = !res;
  return Rf_ScalarLogical(res);
}

S as(S x, S fml) {
  S abb = CADR(fml);
  SEXPTYPE t = TYPEOF(abb);
  switch(t) {
  case SYMSXP: return Rf_coerceVector(x, abb2type(abb));    // x ?~ t
  default: return Rf_coerceVector(x, t);                    // x ?~ ""
  }
}

S isas(S x, S fml) {
  switch(TYPEOF(fml)) {
  case SYMSXP: return is(x, fml, false);                    // x ? t
  case LANGSXP: {
    S fun = CAR(fml); // ?+, ?-
    return fun == Rf_install("!") ?
    is(x, CADR(fml), true) :                                // x ?! t
    as(x, fml);                                             // x ?~ t
  }
  default: return Rf_ScalarLogical(0); // NULL ? NULL opens help, always false
  }
}
