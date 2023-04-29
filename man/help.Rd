\name{?}
\alias{?}
\title{Ask}
\description{
Ask objects about types, control flow and documentation.
}
\usage{
. ? query
}
\arguments{
\item{.}{an object}

\item{query}{a command}
}
\details{
\itemize{
\item \strong{Help}, \code{?topic} \cr
A modified \link[utils]{Question} that has its second argument dropped in
favor of other features. Use \code{utils::.(type, topic)} to find S4
method docs. In other cases regular semantics apply.
\item \strong{Control flow}, \code{x ? yes ~ no} \cr
A concise \link[base]{ifelse}, a vectorized-if that runs scalar-if when
appropriate. Base R recycling is kept.
\item \strong{Class check}, \code{x ? class} \cr
Short \link[methods]{is} that asks \emph{is LHS of class RHS?}
\item \strong{Class coercion}, \code{x ?~ class} \cr
Short form \link[methods]{as} to \emph{coerce LHS to class RHS}.
}
}
\section{Abbreviations}{

Class checks and coercions support abbreviated class names.\tabular{cccc}{
   \strong{Atomic} \tab \strong{Bunch} \tab \strong{Language} \tab \strong{Other} \cr
   atm \tab rec \tab lang \tab na \cr
   lgl \tab lst \tab sym \tab nan \cr
   int \tab dfr \tab expr \tab null \cr
   num \tab vec \tab call \tab fin \cr
   chr \tab mtx \tab name \tab inf \cr
   raw \tab arr \tab fun \tab ord \cr
   cmp \tab fct \tab env \tab prim \cr
   dbl \tab plist \tab fml \tab tab \cr
   Where possible, both \code{is} and \code{as} short forms exist. \tab  \tab  \tab  \cr
}
}

\examples{
# is 5 a character?
5 ? chr
# coerce 5 to character
5 ?~ chr
# scalar-if
TRUE ? 1 ~ 2
# vector-if
c(TRUE, FALSE) ? 1 ~ 2
# vector-if by position
c(TRUE, FALSE) ? c(3, 4) ~ c(5, 6)
}
