`:=` <- expect_identical
error <- expect_error

#### scalar_if ####
a <- TRUE
a ? 1 ~ 0
(TRUE ? 1) := if (TRUE) 1
(FALSE ? 1) := if (FALSE) 1
(TRUE ? 1 ~ 0) := if (TRUE) 1 else 0
(!0 ? 1 ~ 0) := if (!0) 1 else 0
error(NA ? 1 ~ 0, "Missing")
error(logical() ? 10, "Length zero")
error(c(TRUE, FALSE) ? c(1,0) ~ c("a", "b"), "Type")
error(c(TRUE, FALSE) ? 1:2 ~ 1, "Length")

#### vector_if ####
b <- c(TRUE, TRUE, FALSE)
y <- 7:9
z <- 1:3
lb <- rep_len(b, 1001)
fct <- rep_len(factor(1:3, 1:3), 1001)

# preserve attributes
(b ? y ~ z) := ifelse(b, y, z)
(b ? sum(y) ~ sum(z)) := ifelse(b, sum(y), sum(z))
attributes(lb ? fct ~ rev(fct)) :=
	list(class = "factor", levels = c("1", "2", "3"))

(c(TRUE, NA, FALSE) ? 1:3 ~ 7:9) := c(1L, NA_integer_, 9L) # propagate missing

(function(x) (x ? 1 ~ 2))(TRUE) := 1
(function(x, y, z) (x ? y ~ z))(FALSE, 1, 2) := 2
dfr <- data.frame(y = 1:2)
transform(dfr, z = y < 3 ? 5 ~ 1) := transform(dfr, z = ifelse(y < 3, 5, 1))
