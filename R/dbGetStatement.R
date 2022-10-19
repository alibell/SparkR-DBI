#' @export
setMethod("dbGetStatement", "SparkRResult", function(res, ...) {
    res@statement
})