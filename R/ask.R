.onLoad   <- function(libname, pkgname) options("ask.thread" = 1L) #nocov
.onUnload <- function(libpath) library.dynam.unload("ask", libpath) #nocov

`?` <- function(x, y) {
  switch(
    nargs(),
    do.call(utils::`?`, list(substitute(x))),
    if(is.logical(x)) {
      .Call(ifelse, x, y, PACKAGE = "ask")
    } else {
      .Call(isas, x, substitute(y), PACKAGE = "ask")
    }
  )
}

ask <- function(threads = NULL, pct = NULL) {
  if (!nargs()) {
    .Call(c_get_threads)
  } else if (pct ?! nil) {
    threads ? nil                       ?~! "Pass threads or pct, not both."
    length(pct) == 1L                   ?~! "Pass scalar pct value."
    !is.na(pct) & pct >= 0 & pct <= 100 ?~! "Pass pct value in [2, 100]."
    .Call(c_set_threads, pct ?~ int, TRUE, integer())
  } else {
    .Call(c_set_threads, threads ?~ int, FALSE, integer())
  }
}
