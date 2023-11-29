`:=` <- expect_identical
error <- expect_error

err <- "err"

(TRUE ?~! er) := NULL
error(FALSE ?~! err, err)

t <- "a message"
error(FALSE ?~! t, "a message")