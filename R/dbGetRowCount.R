#' Send a query to SparkR.
#'
#' @export
setMethod("dbGetRowCount", "SparkRResult", function(res, ...) {
    sdf <- SparkR::sql(res@state$statement)
    SparkR::count(sdf)
})