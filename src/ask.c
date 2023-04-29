#include <Rinternals.h>
#define S SEXP

SEXP rhs(SEXP f, SEXP rho) {
	switch(Rf_length(f)) {
		case 2: return R_NilValue;
		case 3: return Rf_eval(CADDR(f), rho);
		default: Rf_error("Malformed `~` in `?`");
	};
}

SEXP lhs(SEXP f, SEXP rho) {
	switch(Rf_length(f)) {
		case 2: return R_NilValue;
		case 3: return Rf_eval(CADR(f), rho);
		default: Rf_error("Malformed `~` in `?`");
	};
}

static const R_CallMethodDef entries[] = {
	{"c_lhs", (DL_FUNC) &lhs, 2},
	{"c_rhs", (DL_FUNC) &rhs, 2},
	{NULL, NULL, 0}
};

void R_init_ask(DllInfo* dll) {
	R_registerRoutines(dll, NULL, entries, NULL, NULL);
	R_useDynamicSymbols(dll, FALSE);
	R_forceSymbols(dll, TRUE);
}
