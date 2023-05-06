# Benchmarking `ask`

This folder contains a reproducible [targets][] pipeline to benchmark `ask` against others based on C++ [chrono][]'s duration.

For fair comparison  
1. Set an unambiguous task.  
2. Compare the hash of expected, and obtained outcomes of all methods.  
3. Give equal resources to each package / method.  
4. Set an appropriate number of repeats, especially for very fast functions.  

### if
In R, the overhead of calling a function is the main bottleneck for alternatives to base `if`. Note that `if(NA) 1` and `if(logical()) 1` raise errors, different from `ifelse(NA, 1, 1)` and `ifelse(logical(), 1, 1)`.

### ifelse
Performance depends on data size, the number of threads, types of consequent, and vector recycling. 

`ifelse` accepts non-logic inputs (`ifelse("", 1, 1)`) and
ifelse(1, "", 2)

Useful links:
- [recycling][]  

### isas
See [Rclasstypes] for the difference between `class`, `typeof`, `mode`, and others.


## Help
- [targets][]

Optionally, include shortcuts in `usethis::edit_r_profile("project")` for 
convenience.
```r
.utils <- new.env()
.utils$read <- targets::tar_read
.utils$make <- targets::tar_make
attach(.utils, warn.conflicts = FALSE)
```

[targets]: https://books.ropensci.org/targets/
[chrono]: https://en.cppreference.com/w/cpp/chrono/duration
[Rclasstypes]: https://stackoverflow.com/a/40171527/14853907
[recycling]: https://vctrs.r-lib.org/articles/type-size.html#appendix-recycling-in-base-r
[Rlang]: http://janvitek.org/pubs/ecoop12.pdf
