lhs <- \(f, n = 2) .Call(c_lhs, f, parent.frame(n), PACKAGE = "ask")
rhs <- \(f, n = 2) .Call(c_rhs, f, parent.frame(n), PACKAGE = "ask")

`?` <- function(., query = NULL) {
	if (is.logical(.)) { #### Control flow ####
		if ((l <- length(.)) == 1L) {
			if (.) lhs(query) else rhs(query)
		} else if (l > 0) { # base ifelse
			if (l < 1000L) {
				ans <- .
				yes <- lhs(query)
				no <- rhs(query)
				y <- which(.)
				n <- which(!.)
				if (length(yes) == l) {
					ans[y] <- yes[y]
					ans[n] <- no[n]
				} else {
					ans[y] <- rep(yes, length.out = l)[y]
					ans[n] <- rep(no, length.out = l)[n]
				}
				attributes(ans) <- attributes(yes)
				ans
			} else {
				data.table::fifelse(., lhs(query), rhs(query))
			}
		} else {
			stop("argument is of length zero")
		}
	} else if (!is.null((y <- substitute(query)))) { #### Types ####
		length(y) |> switch(
			as.character(y) |> switch(
				int = is.integer(.), num = is.numeric(.), chr = is.character(.),
				lgl = is.logical(.), lst = is.list(.), dfr = is.data.frame(.),
				mtx = is.matrix(.), fct = is.factor(.), name = is.name(.),
				T = isTRUE(.), F = isFALSE(.),
				atm = is.atomic(.), rec = is.recursive(.), lang = is.language(.),
				na = is.na(.), sym = is.symbol(.), nan = is.nan(.), dbl = is.double(.),
				expr = is.expression(.), null = is.null(.), vec = is.vector(.),
				call = is.call(.), fin = is.finite(.), inf = is.infinite(.),
				raw = is.raw(.), arr = is.array(.), fun = is.function(.),
				ord = is.ordered(.), cmp = is.complex(.), env = is.environment(.),
				prim = is.primitive(.), plist = is.pairlist(.),
				tab = is.table(.),
				do.call(y, list(.))
			),
			as.character(y[[2L]]) |> switch( # type coercion
				chr = as.character(.), lgl = as.logical(.), lst = as.list(.),
				int = as.integer(.), num = as.numeric(.), dfr = as.data.frame(.),
				mtx = as.matrix(.), name = as.name(.), sym = as.symbol(.),
				raw = as.raw(.), expr = as.expression(.), null = as.null(.),
				dbl = as.double(.), vec = as.vector(.), call = as.call(.),
				arr = as.array(.), fun = as.function(.), ord = as.ordered(.),
				cmp = as.complex(.), fct = as.factor(.), env = as.environment(.),
				plist = as.pairlist(.), tab = as.table(.),
				date = as.Date(.), hex = as.hexmode(.),
				do.call(y, list(.))
			),
			stop("Not interpretable as logical", call. = FALSE)
		)
	} else { #### help ####
			do.call(utils::`?`, list(substitute(.)))
	}
}
