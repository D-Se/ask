`:=` <- expect_identical
error <- expect_error

names <- c("character", "integer", "logical", "list")
abbs <- c("chr", "int", "lgl", "lst")
units <- expression(list(
  # logical(), T, F, TRUE, FALSE, NA -- # nolint
  0, 1, NA_real_, NaN, Inf, -Inf,
  0L, 1L, NA_integer_,
  "", NA_character_,
  NULL,
  1^1i, NA_complex_, 0^1i, # complex NaN
  list()
  # T, F, TRUE, FALSE, NA
))

s <- paste0(trimws(capture.output(units[[1]])), collapse = " ")
unit_names <- strsplit(substring(s, 6, last = nchar(s) - 1), ", ")[[1]]
units <- eval(units)

#### type checking ####
base_is <- vapply(paste0("is.", names), function(fun) {
  vapply(units, function(x) do.call(fun, list(x = x)), TRUE)
}, logical(length(units)))

ask_is <- vapply(abbs, function(y) {
  vapply(units, function(x) {
    eval(substitute(x ? y, list(x = x, y = as.name(y))))
  }, TRUE)
}, logical(length(units)))

rownames(ask_is) <- unit_names
rownames(base_is) <- unit_names
colnames(base_is) <- abbs

for (i in seq_len(nrow(ask_is))) {
  for (j in seq_len(ncol(ask_is))) {
    ask_is[i, j] := base_is[i, j]
  }
}

#### Type coercion ####
as_names <- paste0("as.", names)
base_as <- vapply(paste0("as.", names), function(fun) {
  vapply(units, function(x) {
    tryCatch(
      class(do.call(fun, list(x = x))),
      warning = function(w) "warning", error = function(e) "error"
    )
    }, "")
}, character(length(units)))
rownames(base_as) <- unit_names

ask_as <- vapply(abbs, function(y) {
  vapply(units, function(x) {
    tryCatch(
      class(eval(substitute(x ?~ y, list(x = x, y = as.name(y))))),
      warning = function(w) "warning", error = function(e) "error"
    )
  }, "")
}, character(length(units)))
rownames(ask_as) <- unit_names

for (i in seq_len(nrow(ask_as))) {
  for (j in seq_len(ncol(ask_as))) {
    ask_as[i, j] := base_as[i, j]
  }
}

(1 ?~ "") := "1"
(NULL ? 1) := FALSE
error(1 ?~ huh, "Abbreviation")
(1 ? num) := TRUE
(1 ?! num) := FALSE
