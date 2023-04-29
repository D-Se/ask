`:=` <- expect_identical
error <- expect_error
true <- expect_true

#### scalar if ####
(5 > 3 ? TRUE ~ FALSE) := if (5 > 3) TRUE else FALSE
(TRUE ? 1 ~ 0) := if (TRUE) 1 else 0
error(NA ? 1 ~ 0)

#### Vector if ####
(TRUE ? 1 ~ 2) := ifelse(TRUE, 1, 2)

#local({
x <<- c(TRUE, TRUE, FALSE)
y <<- 7:9
z <<- 1:3
f <<- \(x) (x > 5 ? TRUE ~ FALSE)
g <<- \(x) ifelse(x > 5, TRUE, FALSE)

(x ? y ~ z) := ifelse(x, y, z)
(x ? sum(y) ~ sum(z)) := ifelse(x, sum(y), sum(z))
f(0) := g(3)
f(6) := g(6)
dfr <- data.frame(x = letters[1:5], y = 1:5)
transform(dfr, z = y < 3 ? 5 ~ 1) := transform(dfr, z = ifelse(y < 3, 5, 1))

#### Types ####
(5 ?~ chr) := as.character(5)
("1" ?~ int) := as.integer("1")

test <- NULL
true(inherits(?integer, "help_files_with_topic")) # exists
true(inherits(?test, "help_files_with_topic")) # does not exist
