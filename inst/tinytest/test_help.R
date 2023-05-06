`:=` <- expect_identical
error <- expect_error

expect_true(inherits(?integer, "help_files_with_topic")) # exists
expect_true(inherits(??integer, "hsearch"))
error(?test, "object") # does not exist
