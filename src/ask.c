#include "ask.h"

static inline S lhs(S fml, S rho) {
	switch(Rf_length(fml)) {
	case 1: return fml; // if without else
	case 2: return R_NilValue;
	case 3: return Rf_eval(CADR(fml), rho);
	default: Rf_error("Malformed `~` in `?`");
	};
}

static inline S rhs(S fml, S rho) {
	switch(Rf_length(fml)) {
	case 1: return R_NilValue; // void else, invisible is not in the R API.
	case 2: return Rf_eval(CADR(fml), rho);
	case 3: return Rf_eval(CADDR(fml), rho);
	default: Rf_error("Malformed `~` in `?`");
	}
}

S ask(S x, S fml, S rho) {
	S res = R_NilValue;
	if (TYPEOF(x) == LGLSXP) {
		res = LENGTH(x) == 1 ?
			scalar_if(x, fml, rho) :
			vector_if(x, fml, rho);
	}
	return res;
}

static const R_CallMethodDef entries[] = {
	{"c_ask", (DL_FUNC) &ask, 3},
	{NULL, NULL, 0}
};

void R_init_ask(DllInfo* dll) {
	R_registerRoutines(dll, NULL, entries, NULL, NULL);
	R_useDynamicSymbols(dll, FALSE);
	R_forceSymbols(dll, TRUE);
}
