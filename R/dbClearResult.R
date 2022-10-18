#' @export
setMethod("dbClearResult", "SparkRResult", function(res, ...) {
  res@state[["cleared"]] <- TRUE
  res@state[["df"]] <- NULL

  TRUE
})