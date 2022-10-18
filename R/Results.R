#' SparkR results class.
#'
#' @keywords internal
#' @export
setClass("SparkRResult",
  contains = "DBIResult",
  slots = list(res = "SparkDataFrame", state = "environment")
)