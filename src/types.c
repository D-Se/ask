#include "ask.h"
#include <string.h>

const static struct {
	const char * const str;
	const int type;
}
AbbTable[] = {
	{"num",	REALSXP}, {"chr",	STRSXP}, {"int",	INTSXP}, {"lgl",	LGLSXP},
	{"nil",	NILSXP}, {"smb",	SYMSXP}, {"env",	ENVSXP}, {"dbl",	REALSXP},
	{"cmp",	CPLXSXP}, {"any",	ANYSXP}, {"exp",	EXPRSXP},{"lst",	VECSXP},
	{"lang", LANGSXP}, {"raw",	RAWSXP}, {"s4",	S4SXP}, {"name", SYMSXP},
	{(char *)NULL, -1}
};

SEXPTYPE abb2type(S query) {
	const char *s;
	s = CHAR(PRINTNAME(query));
	int i;
	for (i = 0; AbbTable[i].str; i++) {
		if (!strcmp(s, AbbTable[i].str))
			return (SEXPTYPE) AbbTable[i].type;
	}
	return (SEXPTYPE) -1;
}

S is(S x, S query) {return Rf_ScalarLogical(TYPEOF(x) == abb2type(query));}
S as(S x, S query) {return Rf_coerceVector(x, abb2type(query));}
