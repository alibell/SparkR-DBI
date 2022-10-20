#' SparkR connection class.
#'
#' @export
#' @keywords internal
setClass("SparkRConnection",
  contains = "DBIConnection",
  slots = list(
    sc = 'jobj'
  )
)