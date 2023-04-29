# `ask`
introduces [R][] syntax that maximizes communicative efficiency for control flow and type checks/coercion with sane default settings.

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
