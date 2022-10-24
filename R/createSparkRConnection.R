#' createSparkRConnection
#' Return an instance of the SparkRConnection from a Spark Context object.
#'
#' @param sc Spark Context object
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' dbGetQuery(db, "SELECT * FROM mtcars WHERE cyl == 4")
#' }
createSparkRConnection <- function(sc, ...) {
  new("SparkRConnection", sc = sc, ...)
}