#' dbBind DBI method
#' Parametrised query is not officialy supported in Spark environment, it is here managed with the sqlInterpolate method
#' DBI documentation: https://dbi.r-dbi.org/reference/dbBind.html
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' res <- dbGetQuery(db, "SELECT * FROM mtcars WHERE cyl == ?cyl")
#' dbBind(res, cyl = 4)
#' dbFetch(res)
#' }
setMethod("dbBind", "SparkRResult", function(res, ...) {
  res@state$statement <- sqlInterpolate(conn, res@statement, ...)
})