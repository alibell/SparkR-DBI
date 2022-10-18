#' Send a query to SparkR.
#'
#' @export
#' @examples
setMethod("dbSendQuery", "SparkRConnection", function(conn, statement, ...) {
  # Executing query
  res <- SparkR::sql(statement)
  state <- env(start=1, end=-1, completed=FALSE, cleared=FALSE, df=NULL)

  new("SparkRResult", res=res, state=state, ...)
})