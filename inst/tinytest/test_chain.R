`:=` <- expect_identical

x = 5
c <- (x ? num ? 1 ~ 2)
c := 1
c <- (x ?~ chr ?! chr ? 1 ~ 2)
c := 2
x?chr || x?dbl := TRUE

x = c(T, F, NA)
y = 1:3
z = 7:9

(x ? (!x ? y ~ z) ~ y) := c(7L, 2L, NA_integer_)
