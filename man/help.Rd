\name{?}
\alias{?}
\title{Ask}
\description{
Ask objects about types, control flow and documentation.
}
\usage{
x ? y
}
\arguments{
\item{x}{[ lgl, any ] An \R object to ask questions about.}

\item{y}{[ fml, nil ] An action specification, possibly using abbreviations.}
}
\details{
\itemize{
\item \strong{Help}, \code{?topic} \cr
A modified \link[utils]{Question} that drops S4 documentation in favor of
efficient syntax for common tasks. Use \code{utils::.(type, topic)} to find
S4 method docs. Otherwise, regular help semantics apply.
\item \strong{Control flow}, \code{x ? yes ~ no} \cr
Concise control flow. Run scalar-if or \link[base]{ifelse} where appropriate.
Base R recycling is kept, however, attributes are preserved. Numeric inputs
are not interpretable as logics, and strict type checking is applied.
\item \strong{Type check}, \code{x ? type} \cr
Short \link[methods]{is} asks if LHS is of type RHS.
\item \strong{Type coercion}, \code{x ?~ type} \cr
Short \link[methods]{as} coerces LHS to type RHS.
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
# type checks and coercion
5 ? chr
5 ?~ chr

# scalar-if
TRUE ? 1 ~ 2
TRUE ? 1
FALSE ? 2

# vector-if recycled and by position
c(TRUE, FALSE) ? 1 ~ 2
c(TRUE, FALSE) ? c(3, 4) ~ c(5, 6)
}
