ask_is <- function(times = 1e6) {
	c = 5; t = FALSE
	ischr <- \(x) is.character(x)
	stopifnot(is.character(c) == t && ischr(c) == t && (c ? chr) == t)
	bm(
		base = is.character(c),
		base2 = ischr(c),
		tidy = is_character(c),
		ask = c ? chr,
		times = times,
		envir = rlang::current_env()
	)[,"mean"]
}
