% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/setup_project.R
\name{setup_project}
\alias{setup_project}
\title{Set up Project directory and Download data}
\usage{
setup_project(dir, timeout = 300)
}
\arguments{
\item{dir}{\code{character(1)} path where, project directory should be set up}

\item{timeout}{\code{numeric(1)} function timeout in seconds}
}
\description{
Set up Project directory and Download data
}
\details{
file to be downloaded is 148 MB large, so in case your internet connection is very slow, set timeout to a large value since
after "timeout" seconds function exits with a timeout error.
}
