`:=` <- expect_identical
error <- expect_error

err <- "err"

(TRUE ?~! er) := NULL
error(FALSE ?~! err, err)
