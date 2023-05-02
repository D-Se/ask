`:=` <- expect_identical
error <- expect_error

#### control flow ####
# Scalar if
a <- TRUE
a ? 1 ~ 0
(TRUE ? 1) := if (TRUE) 1
(FALSE ? 1) := if (FALSE) 1
(TRUE ? 1 ~ 0) := if (TRUE) 1 else 0
(!0 ? 1 ~ 0) := if (!0) 1 else 0
error(NA ? 1 ~ 0, "missing")
error(NaN ? 1 ~ 0, "Not")
error(1 ? 1 ~ 0, "Not")
error(logical() ? 10, "argument")

# Vector if
b <- c(TRUE, TRUE, FALSE)
y <- 7:9
z <- 1:3
lb <- rep_len(b, 1001)
fct <- rep_len(factor(1:3, 1:3), 1001)

# preserve attributes
(b ? y ~ z) := ifelse(b, y, z)
(b ? sum(y) ~ sum(z)) := ifelse(b, sum(y), sum(z))
(lb ? fct ~ rev(fct)) := data.table::fifelse(lb, fct, rev(fct))
(c(TRUE, NA, FALSE) ? 1:3 ~ 7:9) := c(1L, NA_integer_, 9L) # propagate missing
error(c(NaN, 1) ? 1 ~ 0, "Not")
#error(c(TRUE, FALSE) ? 1:2 ~ 1:3, "unequal")

(function(x) (x ? 1 ~ 2))(TRUE) := 1
(function(x, y, z) (x ? y ~ z))(FALSE, 1, 2) := 2
dfr <- data.frame(y = 1:2)
transform(dfr, z = y < 3 ? 5 ~ 1) := transform(dfr, z = ifelse(y < 3, 5, 1))

#### Types  ####
(5 ?~ chr) := as.character(5)
("1" ?~ int) := as.integer("1")

#### help ####
expect_true(inherits(?integer, "help_files_with_topic")) # exists
expect_true(inherits(??integer, "hsearch"))
error(?test, "object") # does not exist

#### internals ####
ask:::lhs(~2) := NULL
error(ask:::lhs(`~`(1, 1, 1)), "Malformed")
ask:::rhs(~2) := ask:::rhs(1 ~ 2)
error(ask:::rhs(`~`(1, 1, 1)), "Malformed")
