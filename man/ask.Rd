\name{ask}
\alias{ask}
\title{Control \code{ask} package behavior in a session.}
\description{
OpenMP parallelisation powers vectorised-if. By default 50\% of available cores
are used, with as many threads.
}
\usage{
ask(threads = NULL, pct = NULL)
}
\arguments{
\item{threads}{[num]. Set the number of threads in OpenMP parallel loops.
A \code{0}-value signals to use everything.}

\item{pct}{[num]. Set maximum CPU usage by percentage.}
}
\examples{
# how many threads are used?
ask()
}
\value{
scalar [int], the maximum number of OpenMP thread to use. \cr
[nil] if arguments are passed, setting the internal OpenMP values.
}
