`:=` <- expect_identical
error <- expect_error

x <- 1
y <- 0
fml <- x ~ y
fct <- factor(1, 1)
att <- attributes(fct)
dfr <- data.frame(y = 1:2)
lst <- list(1, 2, 3)

(TRUE ? 1) := if (TRUE) 1
(FALSE ? 1) := if (FALSE) 1
(TRUE ? 1 ~ 0) := if (TRUE) 1 else 0
(!0 ? 1 ~ 0) := if (!0) 1 else 0
(FALSE ?~ 2) := if (FALSE) NULL else 2
(TRUE ?~ 2) := if (TRUE) NULL else 2
(TRUE ? c(1, 2, 3)) := if (TRUE) c(1, 2, 3) # doesn't reach switch

(TRUE ? fml) := 1
(!TRUE ?~ 2) := 2

error(NA ? 1, "Missing")
error(NA ? ~0, "Missing")
error(NA ? 1 ~ 0, "Missing")
error(logical() ? 10, "Length zero")
error(TRUE?`~`(), "Malformed")
error(FALSE?`~`(), "Malformed")

# preserve attributes
attributes(TRUE ? fct) := att
attributes(c(TRUE, TRUE) ? fct ~ fct) := att

x <- c(TRUE, NA, FALSE)
(x ? 1:3 ~ 7:9) := c(1L, NA_integer_, 9L) # propagate missing
(x ? c(1, 2, 3) ~ c(7, 8, 9)) := c(1, NA_real_, 9)
(x ? c("1", "2", "2") ~ c("7", "8", "9")) := c("1", NA_character_, "9")
(x ? x ~ !x) := c(TRUE, NA, TRUE)
(x ? list(1, 2, 3) ~ list(7, 8, 9)) := list(1, NULL, 9)
(x ? as.complex(1:3) ~ as.complex(7:9)) := c(1 + 0i, NA_complex_, 9 + 0i)

(\(x) (x ? 1 ~ 2))(TRUE) := 1
(\(x, y, z) (x ? y ~ z))(FALSE, 1, 2) := 2

# scoping
transform(dfr, z = y < 3 ? 5 ~ 1) := transform(dfr, z = ifelse(y < 3, 5, 1))

error(c(NA, NA) ? `~`() ~ `~`(), "Unsupported")
error(c(NA, NA) ? 1 ~ "a", "Type")
error(c(NA, NA) ? c(1, 2) ~ 1, "Length")

# misc
(TRUE ? lst[[2]] ~ lst[[3]]) := 2

