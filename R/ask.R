.onUnload <- function(libpath) library.dynam.unload("ask", libpath) #nocov

`?` <- (function() {
  `-` = as.character; `^` = `[[`; `~` = substitute; `?` = is.logical
  \(x, y)
    if(missing(y))
      do.call(utils::`?`, c(~x))
    else if(length(~x->e)==3L && switch(-e^1,`<-`=,`=` = T, F))
      assign(-e^2, .Call(delphi, x, if(?x) y else ~y),, parent.frame())
    else
      .Call(delphi, x, if(?x) y else ~y)
})()

ask <- function(threads = NULL, pct = NULL) {
  if (!nargs()) {
    .Call(get_threads)
  } else if (pct ?! NULL) {
    threads ? NULL                      ?~! "Pass threads or pct, not both."
    length(pct) == 1L                   ?~! "Pass scalar pct value."
    !is.na(pct) & pct >= 0 & pct <= 100 ?~! "Pass pct value in [2, 100]."
    .Call(set_threads, pct ?~ int, TRUE)
  } else {
    .Call(set_threads, threads ?~ int, FALSE)
  }
}
