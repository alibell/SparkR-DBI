% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dbSendQuery.R
\name{dbSendQuery,SparkRConnection-method}
\alias{dbSendQuery,SparkRConnection-method}
\title{dbSendQuery DBI method
Generate a SparkRResult object from a parametrised
or not parametrised SQL query.
DBI documentation: https://dbi.r-dbi.org/reference/dbSendQuery.html}
\usage{
\S4method{dbSendQuery}{SparkRConnection}(conn, statement, params = NULL, immediate = NULL, ...)
}
\arguments{
\item{conn}{SparkRConnection object}

\item{statement}{SQL statement to send}

\item{params}{List of parameters for parametrised query}

\item{immediate}{This parameter is ignored in SparkR implementation}

\item{...}{Extra parameters}
}
\description{
dbSendQuery DBI method
Generate a SparkRResult object from a parametrised
or not parametrised SQL query.
DBI documentation: https://dbi.r-dbi.org/reference/dbSendQuery.html
}
\examples{
\dontrun{
db <- createSparkRConnection(sc=sc)
dbWriteTable(db, "mtcars", mtcars)
res <- dbSendQuery(db, "SELECT * FROM mtcars")
}
}
