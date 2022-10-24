#' dbClearResult DBI method
#' Release memory consumption of a SparkRResult object and prevent future Fetch
#' DBI documentation: https://dbi.r-dbi.org/reference/dbClearResult.html
#' @param res SparkRResult object
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' res <- dbGetQuery(db, "SELECT * FROM mtcars WHERE cyl == ?cyl")
#' dbClearResult(res)
#' }
setMethod("dbClearResult", "SparkRResult", function(res, ...) {
  res@state[["cleared"]] <- TRUE
  res@state[["df"]] <- NULL

  TRUE
})