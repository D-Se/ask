#include "ask.h"

static const R_CallMethodDef entries[] = {
	{"isas", (DL_FUNC) &isas, 2},
	{"ifelse", (DL_FUNC) &ifelse, 3},
	{"c_set_threads", (DL_FUNC) &set_threads, -1},
	{"c_get_threads", (DL_FUNC) &get_threads_R, -1},
	{NULL, NULL, 0}
};

void R_init_ask(DllInfo* dll) {
	R_registerRoutines(dll, NULL, entries, NULL, NULL);
	R_useDynamicSymbols(dll, FALSE);
	R_forceSymbols(dll, TRUE);
	init_ask_threads(); // default 50% of available cores
}
