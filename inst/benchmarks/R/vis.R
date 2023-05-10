plot_vector <- \(data) {
  box::use(ggplot2)
  data |>
    ggplot(aes(x = n, y = time, color = pkg)) +
    geom_line() +
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
      legend.position = c(.2, .8),
      legend.text = element_text(size = 13),
      plot.title = element_text(
        hjust = .5, margin = margin(10, b = -20), face = "bold"
      ),
      axis.text = element_text(size = 11),
      axis.title.x = element_text(face = "bold", size = 11)
    ) +
    ggtitle("Vectorized if-else") +
    scale_colour_discrete(
    labels = c("ask:         x ? y ~ z", "base: ifelse(x, y, z)",
        "dt:     fifelse(x, y, z)", "kit:          iif(x, y, z)")
  )
}
