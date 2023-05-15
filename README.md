# `ask`
Syntax for convenient control flow and type checks/coercion for fast thought-to-code. Fewer syntax errors, less debugging, faster data science.

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

### Scalar-if
```
e = logical(0)
```
| ask                	| base                    	| tidy                         	| fast                        	|
|--------------------	|-------------------------	|------------------------------	|------------------------------	|
| `T ? 1`            	| `if(T) 1`               	| -                            	| -                            	|
| `T ? 1 ~ 2`        	| `if(T) 1 else 2`        	| `if_else(T, 1, 2)`           	| `fifelse(T, 1, 2)`           	|
| `NA ? 1 ~ 2` [err] 	| `if(NA) 1 else 2`[err]  	| `if_else(NA, 1, 2)` [num NA] 	| `fifelse(NA, 1, 2)` [num NA] 	|
| `e ? 1 ~ 2` [err]  	| `if(e) 1 else 2` [err]  	| `if_else(e, 1, 2)` [num e]   	| `fifelse(e, 1, 2)` [num e]   	|

### Vector-if
```
t <- c(T, F, NA)
x <- 1:3
y <- c(7, 8, 9)
```
| ask               	| base              	| tidy              	| fast              	|
|-------------------	|-------------------	|--------------------	|--------------------	|
| `t ? 1 ~ 2`       	| `ifelse(t, 1, 2)` 	| `if_else(t, 1, 2)` 	| `fifelse(t, 1, 2)` 	|
| `t ? x ~ y` [err] 	| `ifelse(t, x, y)` 	| `if_else(t, x, y)` 	| `fifelse(t, x, y)` 	|

`ask` does not do silent promotion.

### Type queries

| ask       	| base              	| tidy              	|
|-----------	|-------------------	|-------------------	|
| `x ? chr` 	| `is.character(x)` 	| `is_character(x)` 	|
| `x ? ""`  	| -                 	| -                 	|

### Type coercion

| ask        	| base              	| tidy              	|
|------------	|-------------------	|-------------------	|
| `x ?~ chr` 	| `as.character(x)` 	| `as_character(x)` 	|
| `x ?~ ""`  	| -                 	| -                 	|

`ask` supports abbreviated types and comparison
