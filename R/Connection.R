#' @import DBI
setOldClass("jobj")

#' SparkR connection class
#'
#' @slot sc Spark Context object
#' @name SparkRConnection
#' @keywords internal
#' @export
setClass("SparkRConnection",
  contains = "DBIConnection",
  slots = list(
    sc = 'jobj'
  )
)