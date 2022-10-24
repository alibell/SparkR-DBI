#' dbGetStatement DBI method
#' Return the statement of a SparkRResult object.
#' The returned statement is the providen one and not the statement generated after dbBind execution.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbGetStatement.html
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' res <- dbGetQuery(db, "SELECT * FROM mtcars")
#' dbGetStatement(res)
#' }
setMethod("dbGetStatement", "SparkRResult", function(res, ...) {
    res@statement
})