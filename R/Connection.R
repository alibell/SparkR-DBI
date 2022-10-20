#' SparkR connection class.
#'
#' @export
#' @keywords internal
setOldClass("jobj")
setClass("SparkRConnection",
  contains = "DBIConnection",
  slots = list(
    sc = 'jobj'
  )
)