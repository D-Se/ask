`:=` <- expect_identical
error <- expect_error

ask:::set_threads(1) # coerce default
ask:::get_threads() := 1L
ask::set_threads(2)
ask:::get_threads() := 2L

error(ask::set_threads(threads = 1, pct = 1), "not both")
error(ask::set_threads(pct = c(1,2)), "Scalar")
error(ask::set_threads(pct = 101), "[0, 100]")
