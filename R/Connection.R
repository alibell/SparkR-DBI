#' @import DBI
setOldClass("jobj")

#' SparkR connection class.
#'
#' @name SparkRConnection
#' @keywords internal
#' @export
setClass("SparkRConnection",
  contains = "DBIConnection",
  slots = list(
    sc = 'jobj'
  )
)