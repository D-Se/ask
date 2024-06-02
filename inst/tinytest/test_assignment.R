`:=` <- expect_identical
error <- expect_error

# global scope assignment
.x <- TRUE ? 1 ~ 2
.x := 1

# local scope
f <- function(a) {
  y <- a < 5 ? 1 ~ 2
  y
}
f(3) := 1
f(6) := 2
exists(x = "y", where = globalenv()) := FALSE # don't modify global scope

# modify parent frame
parent <- function() {
  par_var <- 0
  child <- function() {
    TRUE ? (par_var <<- par_var+1) ~ (par_var <<- par_var+2)
  }
  child()
  par_var
}
parent() := 1 
exists(x = "par_var", where = globalenv()) := FALSE # don't modify global scope

# scope precedence
global_var = 1
scope <- function() {
  global_var <- 2
  global_var <- TRUE ? 3 ~ 5
  global_var := 3
}
global_var := 1

# environment interaction
env <- new.env()
env$env_var <- 1
env_var <- 2
with(env, TRUE ? (env_var <- 5) ~ (env_var <- 10))
env$env_var := 5
env_var := 2

glo_var <- 1
nested_ternary <- function() {
  loc_var <- 1
  `?`(TRUE,
      `?`(loc_var == 1, (loc_var <- 2) ~ (glo_var <- 2)) ~ 
        `?`(loc_var == 1, (glo_var <- 3) ~ (loc_var <- 3))
      )
  loc_var := 2
  glo_var := 1
}
nested_ternary()
exists(x = "loc_var", where = globalenv()) := FALSE 

# test overwriting types
num <- "hi"
num <- num ? num
num := FALSE
num <- +num ?~ lgl
num := FALSE
num <- (!num ?~! "nope")
num := NULL

