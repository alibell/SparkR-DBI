#' SparkR connection class.
#'
#' @name SparkRConnection
#' @export
#' @keywords internal
setOldClass("jobj")
setClass("SparkRConnection",
  contains = "DBIConnection",
  slots = list(
    sc = 'jobj'
  )
)