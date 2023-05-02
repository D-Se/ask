#include "ask.h"

inline S scalar_if(S x, S fml, S rho) {
	int cond = NA_LOGICAL;
	cond = *LOGICAL(x);
	if (cond == NA_LOGICAL) {Rf_error("missing value where T/F needed");}
	if (cond) {
		res = lhs(fml, rho);
	} else {
		res = rhs(fml, rho);
	}
}
