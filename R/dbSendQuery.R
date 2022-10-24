#' dbSendQuery DBI method
#' Generate a SparkRResult object from a parametrised or not parametrised SQL query.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbSendQuery.html
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' res <- dbSendQuery(db, "SELECT * FROM mtcars")
#' }
setMethod("dbSendQuery", "SparkRConnection", function(conn, statement, ...) {
  # Executing query
  state <- rlang::env(start=1, end=-1, completed=FALSE, cleared=FALSE, df=NULL, statement=statement)

  new("SparkRResult", statement=statement, state=state, ...)
})