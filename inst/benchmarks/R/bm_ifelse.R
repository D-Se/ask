vec_data <- \(n, type, recycle = FALSE, ...) {
  stopifnot(n > 1)
  box::use(stringi[stri_rand_strings])
  x <- sample(c(TRUE, FALSE, NA), n, replace = TRUE, prob = c(.4, .4, .2))
  nyz <- if (recycle) 1 else n

  # base::ifelse destroys attributes, impacts fct etc
  type |> switch(
    chr = {
      y <- stri_rand_strings(nyz, ...) #length
      z <- stri_rand_strings(nyz, ...) #length
    },
    num = {
      y <- rnorm(nyz, ...)
      z <- rnorm(nyz, ...)
    },
    int = {
      y <- sample.int(nyz, ...)
      z <- sample.int(nyz, ...)
    },
    lgl = {
      y <- sample(x, nyz, ...)
      z <- sample(x, nyz, ...)
    },
    stop("Not yet implemented")
  )
  list(x = x, y = y, z = z, truth = digest(ifelse(x, y, z))) |> list2env()
}

# guard against long-running benchmarks.
define_times <- \(size, robust = 1) {
  window <- c(2e1, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8, Inf)
  ind <- min(which(size <= window))
  repeats <- c(1e4, 1e4, 1e4, 1e4, 1e3, 1e2, 1e2, 1e1, 1e1, 1e1)
  repeats[ind] * robust
}

guard_vec <- \(x, truth) {
  stopifnot("Results hash != truth hash!" = identical(digest(x), truth))
}

vec_ask <- \(data, times = FALSE, threads = FALSE, batch = FALSE, ...) {
  # API not clearly defined yet
  if (threads) ask(threads) else ask(1)
  if (!times) define_times(length(data[["x"]]), ...)
  local(guard_vec(x ? y ~ z, truth), data)
  if (batch) return()
  benchmark(
    ask = x ? y ~ z,
    times = times, envir = data
  )
}

vec_dt <- \(data, times = FALSE, threads = FALSE, batch = FALSE, ...) {
  if (threads) setDTthreads(threads) else setDTthreads(1)
  if (!times) define_times(length(data[["x"]]), ...)
  local(guard_vec(fifelse(x, y, z), truth), data)
  if (batch) return(invisible())
  benchmark(
    dt = fifelse(x, y, z),
    times = times, envir = data
  )
}

vec_kit <- \(data, times = FALSE, threads = FALSE, batch = FALSE, ...) {
  if (!threads) threads <- 1 # avoid NULL in getOption
  if (!times) define_times(length(data[["x"]]), ...)
  local(guard_vec(iif(x, y, z), truth), data)
  data$threads <- threads
  if (batch) return(invisible())
  res <- benchmark(
    kit = iif(x, y, z, nThread = threads),
    times = times, envir = data
  )
  rm(threads, envir = data)
}

vec_base <- \(data, times = FALSE, threads = FALSE, batch = FALSE, ...) {
  if (!times) define_times(length(data[["x"]]), ...)
  local(guard_vec(ifelse(x, y, z), truth), data) # guard against RNG mismatch
  if (batch) return(invisible())
  benchmark(
    base = ifelse(x, y, z),
    times = times, envir = data
  )
}

vec_dplyr <- \(data, times = FALSE, threads = FALSE, batch = FALSE, ...) {
  if (!times) define_times(length(data[["x"]]), ...)
  data$na <- as(NA, typeof(data[["y"]]))
  local(guard_vec(case_when(x ~ y, is.na(x) ~ na, TRUE ~ z), truth), data)
  if (batch) return(invisible())
  res <- benchmark(
    dplyr = case_when(x ~ y, is.na(x) ~ na, TRUE ~ z),
    times = times, envir = data
  )
  rm(na, envir = data)
  res
}

batch_ifelse <- \(
  n, type,
  times = FALSE, threads = FALSE, recycle = FALSE, robust = 1, ...) {
  data <- vec_data(n, type, ...)
  if (!times) times <- define_times(n, robust = robust)

  # # guard clauses and environment forming
  vec_ask(data, times, threads, batch = TRUE)
  vec_dt(data, times, threads, batch = TRUE)
  vec_kit(data, times, threads, batch = TRUE)
  vec_base(data, times, threads, batch = TRUE)
  # recommend throttling "times"
  vec_dplyr(data, times, threads, batch = TRUE)

  .b <- substitute(ifelse(x, y, z))
  .a <- substitute(x ? y ~ z)
  .d <- substitute(fifelse(x, y, z))
  .k <- substitute(iif(x, y, z, nThread = threads))
  .t <- substitute(case_when(x ~ y, is.na(x) ~ na, TRUE ~ z))

  bm <- substitute(
    benchmark(
      base = .b,
      ask = .a,
      dt = .d,
      kit = .k,
      # recommend commenting dplyr out when n is large
      dplyr = .t,
      times = times, envir = data
    ), list(.b = .b, .a = .a, .d = .d, .k = .k, .t = .t)
  ) |> eval()

  list(
    bm = bm,
    data.frame(
      n = n, type = type, recycle = recycle, truth = data$truth,
      threads = if (!threads) 1 else threads,
      x = digest(data$x), y = digest(data$y), z = digest(data$z)
    )
  )
}

combine <- \(...) {
  reduce(..., bind_rows) |>
    mutate(n = ns) |>
    pivot_longer(!n, names_to = "pkg", values_to = "time")
}
