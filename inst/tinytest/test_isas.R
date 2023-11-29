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

error(1 ? huh, "Abbreviation")
vals = list(
  1, 1+0i, raw(1), ts(1), factor(1), ordered(1), table(1),
  mtcars, mtcars, new.env(), c(1, 2), matrix(1), array(1:3, 4:6),
  lapply, expression(1+1), getClass("MethodDefinition")
)
abbs2 = c(
  "dbl", "cpl", "raw", "ts", "fct", "ord", "tab",
  "df", "dfr", "env", "vec", "mtx", "arr",
  "fun", "exp", "s4"
)
for (i in seq_along(vals)) {
  eval(substitute(x ? y, list(x = vals[[i]], y = as.name(abbs2[i])))) := TRUE
}

# misc type check
(as.name("x") ? sym) := TRUE
(call("f") ? lng) := TRUE
(x ~ y ? fml) := TRUE

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
