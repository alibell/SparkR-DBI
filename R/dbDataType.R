#' Find the database data type associated with an R object
#' @export
setMethod("dbDataType", signature(dbObj="SparkRConnection"), function(dbObj, obj, ...) {
  if (is.data.frame(obj)) {
    df <- obj
  } else {
    df <- data.frame(column=obj)
  }

  sdf <- SparkR::as.DataFrame(df)
  dtypes <- SparkR::dtypes(sdf)

  if (length(dtypes) == 1) {
    output <- dtypes[[1]][[2]]
  } else {
    output <- sapply(dtypes, function(x) { x[2] })
    names(output) <- sapply(dtypes, function(x) { x[1] })
  }

  toupper(output)
})