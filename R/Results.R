#' SparkR results class.
#'
#' @keywords internal
#' @export
setClass("SparkRResult",
  contains = "DBIResult",
  slots = list(state = "environment", statement = "character")
)