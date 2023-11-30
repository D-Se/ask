.onUnload <- function(libpath) library.dynam.unload("ask", libpath) #nocov
utils::globalVariables("nil")

`?` <- function(x, y) {
  missing(y) && return(do.call(utils::`?`, c(substitute(x))))
  if (length(e <- substitute(x)) == 3L)
    switch(
      as.character(e[[1]]),
      `<-` =, `=` = return( # elevate precedence
do.call(`<-`, c(e[[2]], call("?", e[[3]], if(is.logical(x)) y else substitute(y))), envir = parent.frame())
      )
    )
  if (is.logical(x)) .Call(ifelse, x, y) else .Call(isas, x, substitute(y))
}

ask <- function(threads = NULL, pct = NULL) {
  if (!nargs()) {
    .Call(get_threads)
  } else if (pct ?! nil) {
    threads ? nil                       ?~! "Pass threads or pct, not both."
    length(pct) == 1L                   ?~! "Pass scalar pct value."
    !is.na(pct) & pct >= 0 & pct <= 100 ?~! "Pass pct value in [2, 100]."
    .Call(set_threads, pct ?~ int, TRUE)
  } else {
    .Call(set_threads, threads ?~ int, FALSE)
  }
}
