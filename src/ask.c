#include <Rinternals.h>
#define S SEXP

S lhs(S fml, S rho) {
	switch(Rf_length(fml)) {
		case 1: return fml; // if without else
		case 2: return R_NilValue;
		case 3: return Rf_eval(CADR(fml), rho);
		default: Rf_error("Malformed `~` in `?`");
	};
}

S rhs(S fml, S rho) {
	switch(Rf_length(fml)) {
		case 1: return R_NilValue; // void else, invisible is not in the R API.
		case 2: return Rf_eval(CADR(fml), rho);
		case 3: return Rf_eval(CADDR(fml), rho);
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
