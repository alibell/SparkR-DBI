#' dbSendQuery DBI method
#' Generate a SparkRResult object from a parametrised or not parametrised SQL query.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbSendQuery.html
#' @importFrom methods new
#' @param conn SparkRConnection object
#' @param statement SQL statement to send
#' @param params List of parameters for parametrised query
#' @param immediate This parameter is ignored in SparkR implementation
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' res <- dbSendQuery(db, "SELECT * FROM mtcars")
#' }
setMethod("dbSendQuery", "SparkRConnection", function(conn, statement, params=NULL, immediate=NULL, ...) {
  # Creating SparkRResult environment
  state <- rlang::env(start=1, end=-1, completed=FALSE, cleared=FALSE, df=NULL, statement=statement)

  # Executing the query if: it is not parametrised OR params arguments permit to parametrise it totally
  if (!is.null(params) && is.list(params)) {
    params[["sql"]] <- statement
    params[["conn"]] <- conn
    
    statement <- do.call(sqlInterpolate, params)
  }

  if (!grepl("\\?[^ ]", statement)) {
    SparkR::sql(statement)
  } else {
    message("Parametrised query with missing parameters.")
  }

  new("SparkRResult", conn=conn, statement=state$statement, state=state, ...)
})