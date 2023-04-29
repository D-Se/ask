# `ask`
introduces [R][] syntax that maximizes communicative efficiency for control flow 
and type checks/coercion with sane default settings.

[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![codecov](https://codecov.io/gh/D-Se/ask/branch/main/graph/badge.svg?token=R667MDR4M4)](https://codecov.io/gh/D-Se/ask)
[![](https://img.shields.io/github/languages/code-size/D-Se/ask.svg)](https://github.com/D-Se/ask)

## Installation 

```r
remotes::install_github("D-Se/ask")
```

## Usage

1. Run scalar or (fast) vectorized control flow
```r
5 > 3 ? "a" ~ "b"
1:5 > 3 ? "a" ~ "b"
1:5 > 3 ? letters[1:5] ~ letters[26:21]
```

2. Check types using short notation
```r
# is.character(5)
5 ? chr
```

3. Coerce types using short notation
```r
# as.character(5)
5 ?~ chr
```

[R]: https://www.r-project.org/
