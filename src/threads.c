// this file is modified from data.table, ©Matt Dowle 2023, governed by MPL 2.

#include "ask.h"

static int ask_threads = -1;
static int ask_throttle = -1;

int min(int a, int b) { return a < b ? a : b; }
int max(int a, int b) { return a > b ? a : b; }

void init_ask_threads(void) {
  int ans = max(omp_get_num_procs() * 50 / 100, 1);
  ans = min(ans, omp_get_thread_limit()); // CRAN sets to 2
  ans = min(ans, omp_get_max_threads());
  ans = min(ans, INT_MAX);
  ask_threads = ans;
  ask_throttle = 1024;
}

int get_threads(const int n, const bool throttle) {
  if (n < 1) return 1;
  int ans = throttle ? 1 + (n - 1) / ask_throttle : n;
  return ans >= ask_threads ? ask_threads : ans;
}

S get_threads_R() { return ScalarInteger(get_threads(INT_MAX, false)); }

S set_threads(S threads, S percent) {
  if (!length(threads)){
    init_ask_threads();
  } else if (length(threads)) {
    int n = 0;
    if (length(threads) != 1 || !isInteger(threads) || (n = INTEGER(threads)[0]) < 0) {
      err("Valid thread values: NULL, n >= 0.");
    }
    int num_procs = max(omp_get_num_procs(), 1);
    if (LOGICAL(percent)[0]) {
      if (n < 2 || n > 100) err("Supply threads in [2, 100]"); // #nocov
      n = num_procs * n / 100;
    } else {
      if (n == 0 || n > num_procs) n = num_procs;
    }
    n = min(n, INT_MAX);
    ask_threads = max(n, 1);
  }
  return ScalarInteger(ask_threads);
}
