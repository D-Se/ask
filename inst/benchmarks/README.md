# Benchmarking `ask`

Compare `ask` performance using C++ [chrono][] duration in a [targets][] pipeline.
The default suite checks for correctness, and is evaluated in a separate session.

## User guide
To run all benchmarks, `run targets::tar_make()`. This may take a long time.

To run a benchmark of interest:
1. `qs::qread("inst/benchmarks/config")` OR `targets::tar_meta(fields = "name", targets_only = TRUE)`
2. Make a selection of `name`, collected in a character vector `vec`
3. Run `targets::tar_make(names = !!vec)`
4. `targets::tar_read(tgt)` to see benchmarks.

## Gotchas

For fair comparison  
1. Minimize background tasks, 
2. Ensure identical results,
3. Set an appropriate number of repeats, especially for very fast functions.

## Limitations
The overhead of calling a function in R is a bottleneck for alternatives to primitive (base) functions. Wrapping them can quantify this. 

## Utils
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
[recycling]: https://vctrs.r-lib.org/articles/type-size.html#appendix-recycling-in-base-r
[Rlang]: http://janvitek.org/pubs/ecoop12.pdf
