# `ask` ? yes ~ no <img src="man/figures/logo.png" align="right" height="139" alt="" />
Ternary R operator that unifies `if`, `ifelse`, `is`,
`as`, `stopifnot` and documentation search. Elegant, terse, yet fast, optimize for thought-to-code and code-to-thought.

<!-- badges: start -->
[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![](https://codecov.io/gh/D-Se/ask/branch/main/graph/badge.svg)](https://app.codecov.io/gh/D-Se/ask?branch=main)
[![](https://img.shields.io/github/languages/code-size/D-Se/ask.svg)](https://github.com/D-Se/ask)
<!-- badges: end -->

## Usage
```r
remotes::install_github("D-Se/ask")

# ternary vectorized question with elevated precedence
x <- c(TRUE, FALSE, NA)
z <- x ? 1:3 ~ 7:9                 # c(1, 8, NA)
x ? 1:3 ~ (!x ? 4:7 ~ 8:10)        # c(1, 5, NA)

# check types by abbreviation or template
5 ? num                            # TRUE
5 ? 1                              # TRUE

# coerce types
5 ?~ chr                           # "5"
5 ?~ ""                            # "5"

# negate by passing !
5 ?! num                           # FALSE

# scalar-if semantics
TRUE ? 1 ~ 2                       # 1
TRUE ? 1                           # 1
FALSE ? 2                          # NULL (base R silent default)
FALSE ?~ 2                         # 2

# happy path guard clauses
TRUE ?~! "message"                 # NULL
FALSE ?~! "message"                # error: message

# chain questions from left to right
y <- (5 ?! NULL ? "yay")           # y <- if(!is.null(5)) "yay"

# search documentation like usual*
?integer
??regression
```

## But wha-
View help via ``` ?`?` ```.
```
Atomic	Bunch	Lang	Other
--------------------------------
atm	    rec	    lng	    na
lgl	    lst	    sym	    nan
int	    dfr	    exp	    nil
num	    vec	    call    fin
chr	    mtx	    name    inf
raw	    arr	    fun	    ord
cmp	    fct	    env	    prim
dbl	    fml	    tab	    
```

`ask`:
* is built on, and approximately as fast as, [`data.table`] ([benchmark]).
* has no dependencies.
* *sells* `methods?topic`, and *buys* at a performance cost
    * S4 method documentation is dropped.
    * `?` incurs overhead from rectifying [operator precedence] and R function calls.
* balances readability, correctness and conventions

```r
# all consequents must be of the same type
x ? 1:3 ~ c(5, 6, 7)   # integer ≠ numeric
# for nested ifelse, ( or { is required
x ? a ~ !x ? b ~ c     # precedence issue
```

## Other packages

* **Control flow**: `data.table`, `kit`, `dplyr`, `rtern`, `collapse`
* **Coercion**: `vctrs`, `rlang`
* **Errors**: `rlang`, `tryCatchLog`

[operator precedence]: https://stat.ethz.ch/R-manual/R-devel/library/base/html/Syntax.html
[benchmark]: https://github.com/D-Se/ask/tree/f73fdbe8f209a538866cedc99eb36c081d2fdc42/inst/benchmarks
[`data.table`]:https://github.com/Rdatatable/data.table/tree/master