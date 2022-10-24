#' dbDataType DBI method
#' Find the database data type related with an R object
#' This is performed by creating a Spark DF from the R object and thus letting Spark automatically cast the object.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbDataType.html
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbDataType(db, "test")
#' }
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