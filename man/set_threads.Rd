\name{set_threads}
\alias{set_threads}
\title{Set OpenMP threads}
\description{
Specify the number of threads to use in vectorized if.
}
\usage{
set_threads(threads = NULL, pct = NULL, throttle = NULL)
}
\arguments{
\item{threads}{numeric, number of threads to use}

\item{pct}{CPU percentage to use}

\item{throttle}{a numeric value to control stride length}
}
