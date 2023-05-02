//#include "myomp.h"
#include <Rinternals.h>
#include <stdbool.h>
#define S SEXP
#define SEXPPTR_RO(x) ((const SEXP *)DATAPTR_RO(x))

S ask(S, S, S);
S scalar_if(S, S, S);
S vector_if(S, S, S);

S is(S, S);
S as(S, S);
