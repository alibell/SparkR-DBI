#' @export
setMethod("dbWriteTable", "SparkRConnection", function(conn, name, value, append=FALSE, overwrite=FALSE, temporary=FALSE, row.names=FALSE, fields.type=FALSE, ...) {
  # TODO
})