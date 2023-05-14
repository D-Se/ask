get_ifelse_plotdata <- function() {
  size <- c(
    seq(2, 1e2, by = 5),
    seq(1e2, 1e3, by = 50),
    seq(1e3, 1e4, by = 5e2),
    seq(1e4, 1e5, 5e3),
    seq(1e5, 1e6, 5e4),
    seq(1e6, 1e7, 1e6)
  ) |> as.integer()

  names = list.files("inst/benchmarks/_targets/objects/", pattern = "v_..._")
  bms <- paste0("inst/benchmarks/_targets/objects/", names) |>
    lapply(qs::qread) |>
    unlist(use.names = FALSE) |>
    matrix(ncol = 4, byrow = TRUE) |>
    as.data.table() |>
    setNames(c("base", "ask", "dt", "kit"))

  bms[,
      name := names
  ][, `:=`(
    c("fun", "type", "n", "threads", "recycle"),
    tstrsplit(name, "_", fixed = TRUE)
  )][, `:=`(
    n = size[n ?~ int],
    threads = threads ?~ int,
    recycle = recycle ?~ lgl
  )]

  bms <- melt(
    bms, id.vars = c("name", "fun", "type", "n", "threads", "recycle"),
    value.name = "time",
    variable.name = "pkg"
  )

  bms
}

plot_ifelse <- function(data) {
  data |>
    ggplot(aes(x = n, y = time, color = pkg)) +
    geom_line() +
    facet_wrap(
      c("type", "threads", "recycle"),
      labeller = label_wrap_gen(multi_line = FALSE)
    ) +
    theme_bw() +
    scale_x_log10(
      breaks = c(2, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7),
      labels = c("2", "10", "100", "1k", "10k", "100k", "1M", "10M"),
      limits = c(2, NA)
    ) +
    scale_y_log10(
      breaks = c(1e-06, 1e-05, 1e-04, 1e-03, 1e-02, 1e-01),
      labels = c("1µs", "10µs", "100µs", "1ms", "10ms", "100ms")
    ) +
    theme(
      legend.title = element_blank(),
      legend.text.align = 1,
      legend.position = c(.9, .075),
      legend.text = element_text(size = 13),
      plot.title = element_text(
        hjust = .5, margin = margin(10, b = -20), face = "bold"
      ),
      axis.text = element_text(size = 11),
      axis.title.x = element_text(face = "bold", size = 11),
      strip.background = element_blank(),
      strip.placement = "inside"
      #strip.text.x = element_blank()
    ) +
    scale_colour_discrete(
      labels = c("base: ifelse(x, y, z)", "ask:         x ? y ~ z",
                 "dt:     fifelse(x, y, z)", "kit:          iif(x, y, z)")
    )

}

