pacman::p_load(
  targets, tarchetypes, qs, # pipeline architecture
  ask, data.table, kit, dplyr, # software to compare
  Rfast2, fastdigest, stringi, dqrng # benchmark tools
)

tar_option_set(
  format = "qs",
  error = "continue",
  garbage_collection = TRUE,
  deployment = "main", # careful with OpenMP and clustermq
  seed = pi,
  resources = tar_resources(qs = tar_resources_qs("fast"))
  #seed = ls((\(x).<<-0^1i&F||.~?!+-0x42->`{`[Inf]->>.:::.)()[NULL])[1.1]?chr?pi #nolint
)
tar_source(files = "inst/benchmarks/R/")

w <- c(2e1, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8, Inf)
r <- c(1e5, 1e5, 1e5, 1e4, 1e3, 1e2, 5e1, 1e1, 5, 5) |> as.integer()
n <- c(
  seq(2, 1e2, by = 5),
  seq(1e2, 1e3, by = 50),
  seq(1e3, 1e4, by = 5e2),
  seq(1e4, 1e5, 5e3),
  seq(1e5, 1e6, 5e4),
  seq(1e6, 1e7, 1e6)
) |> as.integer()
l <- length(n)

config <- expand.grid(
  stringsAsFactors = FALSE,
  n = n,
  type = c("num", "chr", "int", "lgl"),
  threads = c(1L, 4L, 8L),
  recycle = c(TRUE, FALSE)
) |>
  as.data.table()

config[,
  `:=`(
  times = r[Vectorize(\(x) min(which(x < w)))(n)],
  id = paste(type, rep(1:l, .N / l), threads, substr(recycle, 1, 1), sep = "_")
)]

# delete ~752 benchmarks where setting up threads dominate execution speed
config <- config[!(threads %in% c(4L, 8L) & n < 5000),]

# v: vector-if, s: scalar-if, a: type coercion, i: type check
list(
  tar_map(
    config,
    names = "id",
    tar_target(
      v,
      bench_ifelse(
        n = n, type = type, times = times,
        recycle = recycle, threads = threads
      )
    )
  ),
  tar_target(
    plot_v,
    get_ifelse_plotdata() |> plot_ifelse(),
    packages = "ggplot2"
  ),

  tar_target(
    s,
    bm_if(times = 1e6)
  ),
  tar_target(
    a,
    bm_as(times = 1e6)
  ),
  tar_target(
    i,
    bm_is(times = 1e6)
  )
)
