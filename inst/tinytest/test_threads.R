`:=` <- expect_identical
error <- expect_error

# ask(1) # coerce default
# ask() := 1L
# ask(2)
# ask() := 2L

error(ask(threads = 1, pct = 1), "not both")
error(ask(pct = c(1, 2)), "Scalar")
error(ask(pct = 101), "[0, 100]")
