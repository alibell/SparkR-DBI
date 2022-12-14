% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dbListTables.R
\name{dbListTables,SparkRConnection-method}
\alias{dbListTables,SparkRConnection-method}
\title{dbListTables DBI method
Return the tables name according to a database name.
If the database name is NULL, the current database table are listed.
DBI documentation: https://dbi.r-dbi.org/reference/dbListTables.html}
\usage{
\S4method{dbListTables}{SparkRConnection}(conn, database = NULL, ...)
}
\arguments{
\item{conn}{SparkRConnection object}

\item{database}{Database name}

\item{...}{Extra parameters}
}
\description{
dbListTables DBI method
Return the tables name according to a database name.
If the database name is NULL, the current database table are listed.
DBI documentation: https://dbi.r-dbi.org/reference/dbListTables.html
}
\examples{
\dontrun{
db <- createSparkRConnection(sc=sc)
dbWriteTable(db, "mtcars", mtcars)
dbListTables(db)
}
}
