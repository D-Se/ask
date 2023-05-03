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

inline S scalar_if(S x, S fml, S rho) {
	int cond = NA_LOGICAL;
	cond = *LOGICAL(x);
	if (cond == NA_LOGICAL) {Rf_error("missing value where T/F needed");}
	return cond ? lhs(fml, rho) : rhs(fml, rho);
}

inline S vector_if(S x, S fml, S rho) {
	return R_NilValue;
}

S ask(S x, S fml, S rho) {
	if (TYPEOF(x) == LGLSXP) {
		return LENGTH(x) == 1 ?
			scalar_if(x, fml, rho):
			vector_if(x, fml, rho);
	} else {
		switch(TYPEOF(fml)) {
		case SYMSXP: return Rf_ScalarLogical(TRUE);
		case LANGSXP: return Rf_ScalarLogical(FALSE);
		default: return R_NilValue;
		}
		/*
		* 1. prevent evaluation of fml (substitute fml)
		* 2. isNull() ? is : as
		*/
		// S query;
		// query = Rf_substitute(fml, rho);
		// return isNull(query) ?
		// 	is(x, query):
		// 	as(x, query);
	}
}

S control_flow(S x, S fml, S rho) {
	return LENGTH(x) == 1 ?
		scalar_if(x, fml, rho):
		vector_if(x, fml, rho);
}

static const R_CallMethodDef entries[] = {
	{"c_ask", (DL_FUNC) &ask, 3},
	{"c_cf", (DL_FUNC) &ask, 3},
	{NULL, NULL, 0}
};

void R_init_ask(DllInfo* dll) {
	R_registerRoutines(dll, NULL, entries, NULL, NULL);
	R_useDynamicSymbols(dll, FALSE);
	R_forceSymbols(dll, TRUE);
}
