pacman::p_load(data.table, ask)

size <- c(
  seq(2, 1e2, by = 5),
  seq(1e2, 1e3, by = 50),
  seq(1e3, 1e4, by = 5e2),
  seq(1e4, 1e5, 5e3),
  seq(1e5, 1e6, 5e4),
  seq(1e6, 1e7, 1e6)
) |> as.integer()

tgts_dt <- as.data.table(targets::tar_manifest(fields = "name"))
tgts_dt[, `:=`(
  c("fun", "type", "n", "threads", "recycle"),
  tstrsplit(name, "_", fixed = TRUE)
)][, `:=`(
  n = size[n ?~ int],
  threads = threads ?~ int,
  recycle = recycle ?~ lgl
)]

qs::qsave(tgts_dt, "inst/benchmarks/config", "high")
