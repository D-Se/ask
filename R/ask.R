.onLoad   <- function(libname, pkgname) options("ask.thread" = 1L) #nocov
.onUnload <- function(libpath) library.dynam.unload("ask", libpath) #nocov

`?` <- \(., query = NULL) {
	if (is.logical(.)) {
		.Call(ifelse, ., query, parent.frame(), PACKAGE = "ask")
	} else if (is.null(y <- substitute(query))) {
		do.call(utils::`?`, list(substitute(.)))
	} else {
		.Call(isas, ., y, PACKAGE = "ask")
	}
}

set_threads <- function(threads = NULL, pct = NULL, throttle = NULL) {
	if (!is.null(pct)) {
		if (!is.null(threads)) stop("Threads or percent, not both.")
		if (length(pct) != 1L) stop("Scalar value needed for percent.")
		pct <- as.integer(pct)
		if (is.na(pct) || pct < 2L || pct > 100L) stop("percent in [2, 100] please.")
		.Call(c_set_threads, pct, TRUE, as.integer(throttle)) |>
			invisible()
	} else {
		.Call(c_set_threads, as.integer(threads), FALSE, as.integer(throttle)) |>
			invisible()
	}
}

get_threads <- function() .Call(c_get_threads)
