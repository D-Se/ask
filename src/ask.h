#ifndef ASK_H
#define ASK_H

#include <stdbool.h>
#include <stdint.h>
#include <string.h>

#ifdef _OPENMP
  #include <omp.h> // -fopenmp by Makevars files
  #define OMP_FOR(lx) _Pragma("omp parallel for num_threads(nthreads(lx, true))")
#else
  #define omp_get_max_threads()  1
  #define omp_get_thread_limit() 1
  #define omp_get_num_procs()    1
  #define OMP_FOR(lx)
#endif

#include <Rinternals.h>

#define S SEXP
#define err(x) Rf_errorcall(R_NilValue, x)

// internals
int nthreads(int n, bool throttle);
void init_ask_threads(void);
bool isFormula(S x);

// API
S isas(S x, S formula);
S ifelse(S x, S formula);
S get_threads(void);
S set_threads(S threads, S percent);
#endif
