# ask 0.0.2
## New Features
1. Support type checking

    ```R
    5 ? chr
    ```
2. Support type conversion

    ```R
    5 ?~ chr
    5 ? ""
    ```
3. Scalar and vectorized if-else. The OpenMP back-end ensures scalable ops.

    ```R
    TRUE ? 1
    FALSE ? 1 ~ 2
    FALSE ?~ 2
    
    c(TRUE, FALSE, NA) ? 1 ~ 2
    c(TRUE, FALSE, NA) ? 1:3 ~ 7:9
    ```
