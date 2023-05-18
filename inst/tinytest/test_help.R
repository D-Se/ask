`:=` <- expect_identical
error <- expect_error

expect_true(inherits(?integer, "help_files_with_topic")) # exists
expect_true(inherits(??integer, "hsearch"))
length(?Syntax) := 1L
length(?test) := 0L # does not exist, prints
