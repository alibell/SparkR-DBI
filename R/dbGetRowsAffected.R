#' dbGetRowsAffected DBI method
#' This functionnality is not supported by Spark.
#' We return 0 to keep compatibility with libraries using DBI object.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbGetRowsAffected.html
#' @export
setMethod("dbGetRowsAffected", "SparkRResult", function(res, ...) {
    warning("dbGetRowsAffected not supported by SparkR")
    0
})