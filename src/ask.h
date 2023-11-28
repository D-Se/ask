#ifndef ASK_H
#define ASK_H

#include <stdbool.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

#ifdef _OPENMP
  #include <omp.h> // -fopenmp by Makevars files
  #define OMP_FOR(lx) _Pragma("omp parallel for num_threads(get_threads(lx, true))")
#else
  #define omp_get_max_threads()  1
  #define omp_get_thread_limit() 1
  #define omp_get_num_procs()    1
  #define OMP_FOR(lx)
#endif

#include <Rinternals.h>

#define S SEXP
#define SEXPPTR_RO(x) ((const S *)DATAPTR_RO(x))
#define err(x) Rf_errorcall(R_NilValue, x)
#define warn(x) Rf_warningcall(R_NilValue, x)

// internals
int get_threads(const int n, const bool throttle);
void init_ask_threads(void);
bool isFormula(S);

// API
S isas(S, S);
S ifelse(S, S);
S get_threads_R(void);
S set_threads(S, S, S);

#endif
