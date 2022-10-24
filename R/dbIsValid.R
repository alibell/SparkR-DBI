#' dbIsValid DBI method
#' Return the valid status of the SparkR connection.
#' This method call the `isStopped` method of the sparkContext
#' Scala API to get the connection status.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbIsValid.html
#' @param dbObj SparkRConnection object
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbIsValid(db)
#' }
setMethod("dbIsValid",
    signature(dbObj = "SparkRConnection"),
    function(dbObj, ...) {
    is_stopped <- (SparkR::sparkR.callJMethod(
        SparkR::sparkR.callJMethod(dbObj@sc, "sparkContext"),
        "isStopped"
    ))

    !is_stopped
})