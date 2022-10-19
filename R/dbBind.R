#' @export
setMethod("dbBind", "SparkRResult", function(res, ...) {
  res@state$statement <- sqlInterpolate(conn, res@statement, ...)
})