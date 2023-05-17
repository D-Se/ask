// this file is modified from data.table, ©Matt Dowle 2023, governed by MPL 2.

// openmp
#include <ctype.h> // isspace
#include "ask.h"

int ask_threads = -1;
int ask_throttle = -1;

int getIntEnv(const char *name, int def) {
  const char *val = getenv(name);
  if (val == NULL) return def;
  size_t nchar = strlen(val);
  if (nchar == 0) return def;
  char *end;
  long ans = strtol(val, &end, 10);
  while (isspace(*end)) end++;
  if ((size_t)(end - val) != nchar || ans < 1 || ans > INT_MAX) {
    warn("Invalid CPU use percentage, using default.");
    return def;
  }
  return (int) ans;
}

int min(int a, int b) { return a < b ? a : b; }
int max(int a, int b) { return a > b ? a : b; }

void init_ask_threads(void) {
  int ans = getIntEnv("ASK_NUM_THREADS", INT_MIN);
  if (ans >= 1) {
    ans = min(ans, omp_get_num_procs());
  } else {
    int perc = getIntEnv("ASK_NUM_PROCS_PERCENT", 50);
    if (perc <= 1 || perc > 100) {
      warn("Invalid percentage.");
      perc = 50;
    }
    ans = max(omp_get_num_procs() * perc / 100, 1);
  }
  ans = min(ans, omp_get_thread_limit()); // CRAN sets to 2
  ans = min(ans, omp_get_max_threads());
  ans = min(ans, getIntEnv("OMP_THREAD_LIMIT", INT_MAX));
  ans = min(ans, getIntEnv("OMP_NUM_THREADS", INT_MAX));
  ask_threads = ans;
  ask_throttle = max(1, getIntEnv("ASK_THROTTLE", 1024));
}

int get_threads(const int64_t n,
                const bool throttle) {
  if (n < 1) return 1;
  int64_t ans = throttle ? 1 + (n - 1) / ask_throttle : n;
  return ans >= ask_threads ? ask_threads : (int) ans;
}

S get_threads_R() { return ScalarInteger(get_threads(INT_MAX, false)); }

S set_threads(S threads, S percent, S throttle) {
  if (length(throttle)) {
    if (!isInteger(throttle) || LENGTH(throttle) != 1 || INTEGER(throttle)[0] < 1)
      err("Invalid throttle value.");
    ask_throttle = INTEGER(throttle)[0];
  }
  int old = ask_threads;
  if (!length(threads) && !length(throttle)) {
    init_ask_threads();
  } else if (length(threads)) {
    int n = 0;
    if (length(threads) != 1 || !isInteger(threads) || (n = INTEGER(threads)[0]) < 0) {
      err("Valid thread values: NULL, n >= 0.");
    }
    int num_procs = max(omp_get_num_procs(), 1);
    if (LOGICAL(percent)[0]) {
      if (n < 2 || n > 100) err("Supply threads in [2, 100]"); // # nocov
      n = num_procs * n / 100;
    } else {
      if (n == 0 || n > num_procs) n = num_procs;
    }
    n = min(n, getIntEnv("OMP_THREAD_LIMIT", INT_MAX));
    ask_threads = max(n, 1);
  }
  return ScalarInteger(old);
}
