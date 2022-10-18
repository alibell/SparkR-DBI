#' @export
setMethod("dbHasCompleted", "SparkRResult", function(res, ...) {
   res@state[["completed"]]
})