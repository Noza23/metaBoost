% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/translate_config.R
\name{translate_config}
\alias{translate_config}
\title{Translate HyperParameter Configuration}
\usage{
translate_config(config)
}
\arguments{
\item{config}{\code{data.table()} configurations to be translated}
}
\value{
\code{data.table()} of configuration formated as expected in \strong{lrn("classif.xgboost)$param_set}
}
\description{
Transform Configuration into the format expected in mlr3.
}
