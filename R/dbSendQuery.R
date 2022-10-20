#' Send a query to SparkR.
#'
#' @export
setMethod("dbSendQuery", "SparkRConnection", function(conn, statement, ...) {
  # Executing query
  state <- rlang::env(start=1, end=-1, completed=FALSE, cleared=FALSE, df=NULL, statement=statement)

  new("SparkRResult", statement=statement, state=state, ...)
})