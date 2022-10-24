#' SparkR results class.
#'
#' @slot conn SparkRConnection object
#' @slot state Environment contaning the Result binded statement,
#'       the fetching location (start and end), output data and
#'       the cleared and completed state
#' @slot statement Original provided statement (before binding)
#' @name SparkRResult
#' @keywords internal
#' @export
setClass("SparkRResult",
  contains = "DBIResult",
  slots = list(
    conn = "SparkRConnection",
    state = "environment",
    statement = "character"
  )
)