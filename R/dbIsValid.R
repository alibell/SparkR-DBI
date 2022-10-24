#' dbIsValid DBI method
#' Return the valid status of the SparkR connection.
#' This method call the `isStopped` method of the sparkContext Scala API to get the connection status.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbIsValid.html
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbIsValid(db)
#' }
setMethod("dbIsValid", signature(dbObj = "SparkRConnection"), function(dbObj, ...) {
    isStopped <- (SparkR::sparkR.callJMethod(
        SparkR::sparkR.callJMethod(dbObj@sc, "sparkContext"),
        "isStopped"
    ))

    !isStopped
})