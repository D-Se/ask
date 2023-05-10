ask_as <- \(times = 1e6) {
  c <- 5
  t <- "5"
  aschr <- \(x) as.character(x)
  stopifnot(as.character(c) == t && aschr(c) == t && (c ?~ chr) == t)
  Rfast2::benchmark(
    base = as.character(c),
    base2 = aschr(c),
    ask = c ?~ chr,
    times = times,
    envir = rlang::current_env()
  )[, "mean"]
}
