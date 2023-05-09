.onLoad   <- function(libname, pkgname) options("ask.thread" = 1L) #nocov
.onUnload <- function(libpath) library.dynam.unload("ask", libpath) #nocov

`?` <- \(x, y = NULL) {
	if (is.logical(x)) {
		.Call(ifelse, x, y, parent.frame(), PACKAGE = "ask")
	} else if (is.null(y <- substitute(y))) {
		do.call(utils::`?`, list(substitute(x)))
	} else {
		.Call(isas, x, y, PACKAGE = "ask")
	}
}

ask <- function(threads = NULL, pct = NULL) {
	if(!nargs()) {
		.Call(c_get_threads)
	} else if (!is.null(pct)) {
		if (!is.null(threads)) stop("Threads or percent, not both.")
		if (length(pct) != 1L) stop("Scalar value needed for percent.")
		pct <- as.integer(pct)
		if (is.na(pct) || pct < 2L || pct > 100L) stop("percent in [2, 100] please.")
		.Call(c_set_threads, pct, TRUE, integer(0)) |> invisible()
	} else {
		.Call(c_set_threads, as.integer(threads), FALSE, integer(0))
	}
}

