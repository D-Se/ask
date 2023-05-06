// openmp
#include <ctype.h> // isspace
#include "ask.h"

static int ask_threads = -1;
static int ask_throttle = -1;

static int getIntEnv(const char * name, int def) {
	const char * val = getenv(name);
	if (val == NULL) return def;
	size_t nchar = strlen(val);
	if (nchar == 0) return def;
	char * end;
	errno = 0;
	long int ans = strtol(val, & end, 10);
	while (isspace( * end)) end++;
	if (errno || (size_t)(end - val) != nchar || ans < 1 || ans > INT_MAX) {
		Rf_warning("Invalid digit.");
		return def;
	}
	return (int) ans;
}

static inline int imin(int a, int b) {
	return a < b ? a : b;
}
static inline int imax(int a, int b) {
	return a > b ? a : b;
}
void init_ask_threads(void) {
	int ans = getIntEnv("ASK_NUM_THREADS", INT_MIN);
	if (ans >= 1) {
		ans = imin(ans, omp_get_num_procs());
	} else {
		int perc = getIntEnv("ASK_NUM_PROCS_PERCENT", 50);
		if (perc <= 1 || perc > 100) {
			Rf_warning("Invalid percentage.");
			perc = 50;
		}
		ans = imax(omp_get_num_procs() * perc / 100, 1);
	}
	ans = imin(ans, omp_get_thread_limit()); // CRAN sets to 2
	ans = imin(ans, omp_get_max_threads());
	ans = imin(ans, getIntEnv("OMP_THREAD_LIMIT", INT_MAX));
	ans = imin(ans, getIntEnv("OMP_NUM_THREADS", INT_MAX));
	ask_threads = ans;
	ask_throttle = imax(1, getIntEnv("ASK_THROTTLE", 1024));
}

int get_threads(const int64_t n,
                const bool throttle) {
	if (n < 1) return 1;
	int64_t ans = throttle ? 1 + (n - 1) / ask_throttle : n;
	return ans >= ask_threads ? ask_threads : (int) ans;
}

S get_threads_R() {
	return ScalarInteger(get_threads(INT_MAX, false));
}

S set_threads(S threads, S percent, S throttle) {
	if (length(throttle)) {
		if (!isInteger(throttle) || LENGTH(throttle) != 1 || INTEGER(throttle)[0] < 1)
			Rf_errorcall(R_NilValue, "Invalid throttle value.");
		ask_throttle = INTEGER(throttle)[0];
	}
	int old = ask_threads;
	if (!length(threads) && !length(throttle)) {
		init_ask_threads();
	} else if (length(threads)) {
		int n = 0;
		if (length(threads) != 1 || !isInteger(threads) || (n = INTEGER(threads)[0]) < 0) {
			Rf_error("Valid thread values: NULL, n >= 0.");
		}
		int num_procs = imax(omp_get_num_procs(), 1);
		if (LOGICAL(percent)[0]) {
			if (n < 2 || n > 100) Rf_error("Supply threads in [2, 100]"); // # nocov
			n = num_procs * n / 100;
		} else {
			if (n == 0 || n > num_procs) n = num_procs;
		}
		n = imin(n, getIntEnv("OMP_THREAD_LIMIT", INT_MAX));
		ask_threads = imax(n, 1);
	}
	return ScalarInteger(old);
}

