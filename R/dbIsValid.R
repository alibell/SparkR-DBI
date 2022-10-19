#' @export
setMethod("dbIsValid", signature(dbObj = "SparkRConnection"), function(dbObj, ...) {
    isStopped <- (SparkR::sparkR.callJMethod(
        SparkR::sparkR.callJMethod(dbObj@sc, "sparkContext"),
        "isStopped"
    ))

    !isStopped
})