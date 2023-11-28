# `ask` ? yes ~ no <img src="man/figures/logo.png" align="right" height="139" alt="" />
Nice control flow and type checks/coercion syntax for fast thought-to-code. Fewer syntax errors, less debugging, faster data science. Favors terse syntax over common actions over S4 method documentation.
<!-- badges: start -->
[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![](https://codecov.io/gh/D-Se/ask/branch/main/graph/badge.svg)](https://app.codecov.io/gh/D-Se/ask?branch=main)
[![](https://img.shields.io/github/languages/code-size/D-Se/ask.svg)](https://github.com/D-Se/ask)
<!-- badges: end -->

## Installation 

```r
install.packages("ask")
remotes::install_github("D-Se/ask")
```

## Usage

```r
# ternary vectorized query operator with elevated precedence
z <- TRUE ? 1 ~ 2

x <- c(TRUE, FALSE, NA)
a <- 1:3; b <- 4:6; c <- 7:9
x ? a ~ {!x ? b ~ c}
x ? a ~ (!x ? b ~ c)

# check types using 3-letter abbreviations
5 ? num
5 ?! num

# coerce types
5 ?~ chr
5 ?~ ""

# scalar-if
TRUE ? 1 ~ 2
TRUE ? 1
FALSE ? 2
FALSE ?~ 2

# happy path guard clauses
TRUE ?~! "message"
FALSE ?~! "message"

# search documentation like usual, except S4 methods
?integer
??regression
```

## Gotchas

```r
# all queries must be of the same type
x ? a ~ c(5, 6, 7)     # integer is not the same as numeric
x ? a ~ !x ? b ~ c     # missing braces, precedence issue
```