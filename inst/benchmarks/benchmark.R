pacman::p_load(
	targets, ask, data.table, kit, dplyr,

	Rfast2, digest
)

tar_config_set(
	store = "inst/benchmarks/_targets/",
	script = "inst/benchmarks/benchmark.R"
)
tar_option_set(
	packages = c("ask"),
	error = "continue",
	garbage_collection = TRUE,
	deployment = "main", # careful with OpenMP and clustermq
	seed = pi
	#seed = ls((\(x).<<-0^1i&F||.~?!+-0x42->`{`[Inf]->>.:::.)()[NULL])[1.1]?chr?pi #nolint
)
tar_source(files = "inst/benchmarks/R/")

# Names:
# v: ifelse
# s: small, l: large
list(
	tar_target(ns,
		c(
			seq(2, 1e2, by = 5),
			seq(1e2, 1e3, by = 50),
			seq(1e3, 1e4, by = 5e2),
			seq(1e4, 1e5, 5e3),
			seq(1e5, 1e6, 5e4),
			seq(1e6, 1e7, 1e6)
		)
	),
  tar_target(v_chr_s_t4_l5, batch_ifelse(500, "chr", threads = 4, length = 5)),
	tar_target(v_chr_s_t4_l1, batch_ifelse(500, "chr", threads = 4, length = 1)),
	tar_target(v_chr1_s_t0_l1, batch_ifelse(500, "chr", length = 1)),
	tar_target(v_chr1_s_t0_l5, batch_ifelse(500, "chr", length = 5)),

	tar_target(scalar_if, ask_if()),

	tar_target(v_num_s_tF, batch_ifelse(500, "num")),
	tar_target(v_num_s_t4, batch_ifelse(500, "num", threads = 4)),
	tar_target(v_num_l_tF, batch_ifelse(1e6, "num")),
	tar_target(v_num_l_t1, batch_ifelse(1e6, "num", threads = 1)),
	tar_target(v_num_l_t4, batch_ifelse(1e6, "num", threads = 4)),
	tar_target(v_num_l_t8, batch_ifelse(1e6, "num", threads = 8))
)
