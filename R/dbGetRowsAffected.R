#' @export
setMethod("dbGetRowsAffected", "SparkRResult", function(res, ...) {
    warning("dbGetRowsAffected not supported by SparkR")
    0
})