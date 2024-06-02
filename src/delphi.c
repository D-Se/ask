#include "ask.h"

S delphi(S x, S fml) {
  const SEXPTYPE t = TYPEOF(x);
  switch(t) {
  case LGLSXP: return ifelse(x, fml);
  default: return isas(x, fml);
  }
}