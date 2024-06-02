#include "ask.h"

static const R_CallMethodDef entries[] = {
  {"isas", (DL_FUNC) &isas, 2},
  {"ifelse", (DL_FUNC) &ifelse, 2},
  {"delphi", (DL_FUNC) &delphi, 2},
  {"set_threads", (DL_FUNC) &set_threads, -1},
  {"get_threads", (DL_FUNC) &get_threads, -1},
  {NULL, NULL, 0}
};

void R_init_ask(DllInfo* dll) {
  R_registerRoutines(dll, NULL, entries, NULL, NULL);
  
  // avoid namespace conflicts
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
  
  // set package-specific setting on load
  init_ask_threads();
  
  // these may be called in C code in other packages
  R_RegisterCCallable("ask", "isas", (DL_FUNC) &isas);
  R_RegisterCCallable("ask", "ifelse", (DL_FUNC) &ifelse);
  R_RegisterCCallable("ask", "delphi", (DL_FUNC) &delphi);
}