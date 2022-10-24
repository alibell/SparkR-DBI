#' SparkR results class.
#'
#' @name SparkRResult
#' @keywords internal
#' @export
setClass("SparkRResult",
  contains = "DBIResult",
  slots = list(state = "environment", statement = "character")
)