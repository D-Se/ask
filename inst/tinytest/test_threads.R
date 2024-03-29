`:=` <- expect_identical
error <- expect_error

ask(1)
ask() := 1L
ask(pct = 100) := ask(0)

error(ask(threads = 1, pct = 1), "not both")
error(ask(pct = c(1, 2)), "scalar")
error(ask(pct = 101), "[0, 100]")
error(ask(threads = raw(101)), "thread values")
