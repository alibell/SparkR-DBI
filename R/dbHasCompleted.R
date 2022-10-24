#' dbHasCompleted DBI method
#' Return the completion status of a SparkRResult object.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbHasCompleted.html
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' res <- dbGetQuery(db, "SELECT * FROM mtcars")
#' dbFetch(res)
#' dbHasCompleted(res)
#' }
setMethod("dbHasCompleted", "SparkRResult", function(res, ...) {
   res@state[["completed"]]
})