ask_if <- function(times = 1e6) {
	x = TRUE; y = 1; z = 2; t = 1
	fif = \(x, yes, no) `if`(x, yes, no)
	stopifnot(`if`(x, y, z) == t && fif(x, y, z) == t && (x ? y ~ z) == t)
	benchmark(
		base = if(x) y else z,
		base2 = fif(x, y, z),
		#tidy = if_else(x, 10, 3),
		ask = x ? y ~ z,
		times = times,
		envir = rlang::current_env()
	)[,"mean"]
}
