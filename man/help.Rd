\name{?}
\alias{?}
\title{?: conditions, types and documentation shortcuts}
\description{
Ask objects about types, control flow and documentation.
}
\usage{
x ? y
}
\arguments{
\item{x}{[lgl, any], an \R object to ask questions about.}
\item{y}{[fml, nil], an action specification, possibly using abbreviations.}
}
\details{
\itemize{
\item \strong{Help}, \code{?topic} \cr
A modified \link[utils]{Question} that drops S4 documentation in favor of
efficient syntax for common tasks. Use \code{utils::.(type, topic)} to find
S4 method docs. Otherwise, regular help semantics apply.
\item \strong{Control flow}, \code{x ? yes ~ no, x ? yes, x ?~ no} \cr
Run scalar-if or \link[base]{ifelse} where appropriate.
Base R recycling is kept, however, attributes are preserved. Numeric inputs
are not interchangable with logicals, and strict type checking is applied.
\item \strong{Guard clauses}, \code{x ?~! no} \cr
A simplified \link[base]{stopifnot} where an error occurs if the happy path fails.
\item \strong{Type check}, \code{x ? type} \cr
For non-logical \code{x}, short \link[methods]{is} asks if LHS is of type RHS.
\item \strong{Type coercion}, \code{x ?~ type, x ?~ abb} \cr
For non-logical \code{x}, short \link[methods]{as} coerces LHS to type RHS.
}
}
\section{Abbreviations}{

Class checks and coercions support abbreviated type names.\tabular{llll}{
   \strong{Atomic} \tab \strong{Bunch} \tab \strong{Language} \tab \strong{Other} \cr
   atm \tab rec \tab lang \tab na \cr
   lgl \tab lst \tab sym \tab nan \cr
   int \tab dfr \tab expr \tab nil \cr
   num \tab vec \tab call \tab fin \cr
   chr \tab mtx \tab name \tab inf \cr
   raw \tab arr \tab fun \tab ord \cr
   cmp \tab fct \tab env \tab prim \cr
   dbl \tab     \tab fml \tab tab \cr
}
}
\examples{
# type checks
5 ? num
5 ?! num

# type coercion
5 ?~ chr
5 ?~ ""

# scalar-if
TRUE ? 1 ~ 2
TRUE ? 1
FALSE ? 2
FALSE ?~ 2

# ternary / vector-if, recycled and by position, and elevated precedence
res <- c(TRUE, FALSE) ? 1 ~ 2; res
c(TRUE, FALSE) ? c(3, 4) ~ c(5, 6)

# nested, top-down evaluation
x <- c(TRUE, FALSE, NA)
a <- 1:3; b <- 4:6; c <- 7:9
x ? a ~ {!x ? b ~ c}
x ? a ~ (!x ? b ~ c)

# all queries must be of the same type
try(x ? 1:3 ~ c(5, 6, 7))     # integer is not the same as numeric
try(x ? 1:3 ~ !x ? 4:6 ~ 7:9) # missing braces

# search documentation gotchas
?integer

# guard clauses
try(1 == 0 ?~! "message")
}
\value{
\code{x [lgl] ?   y [fml, any]}, a vector of length x, of type LHS of y. \cr
\code{x [lgl] ?~! y [chr]}, an error with message y. \cr
\code{x [any] ?   y}, a scalar [lgl]. \cr
\code{x [any] ?~  y}, vector of length x, of type y.
\code{?x [any]}, an object of class \emph{help_files_with_topic}.
}
