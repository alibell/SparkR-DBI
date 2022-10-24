#' dbGetRowCount DBI method
#' Return the returned number of rows from a SparkRResult object.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbGetRowCount.html
#' @param res SparkRResult object
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' res <- dbGetQuery(db, "SELECT * FROM mtcars")
#' dbGetRowCount(res)
#' }
setMethod("dbGetRowCount", "SparkRResult", function(res, ...) {
    sdf <- SparkR::sql(res@state$statement)
    SparkR::count(sdf)
})