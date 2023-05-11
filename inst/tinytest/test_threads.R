`:=` <- expect_identical
error <- expect_error

ask(1)
new <- ask()
new := 1L

ask(pct = 100)
pct <- ask()
ask(1)
ask(0)
threads <- ask()
pct := threads

error(ask(threads = 1, pct = 1), "not both")
error(ask(pct = c(1, 2)), "Scalar")
error(ask(pct = 101), "[0, 100]")
