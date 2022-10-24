#' dbWriteTable DBI method
#' Write a table from a R dataframe.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbWriteTable.html
#' @param conn SparkRConnection object
#' @param name Name of the output table
#' @param value R data.frame to write
#' @param append If TRUE the table is appened to existing one
#' @param overwrite If TRUE, the existing table is overwritten
#' @param temporary If TRUE, the table if written as a temporary view
#' @param row.names If TRUE, a column containing the row names if created, if NA it is created only if the row names are different from 1:nrow(), if it is a character the created column is named according to the row.names value
#' @param field.types Vector containing the type to cast to the written column
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' }
setMethod("dbWriteTable", "SparkRConnection", function(conn, name, value, append=FALSE, overwrite=FALSE, temporary=FALSE, row.names=FALSE, field.types=FALSE, ...) {
  df <- value
  hasRowName <- FALSE
  rowName <- NULL

  # Processing row.names arguments
  if (!is.na(row.names) && !is.null(row.names) && row.names == TRUE) {
        hasRowName <- TRUE
        rowName <- "row_names"
  } else if (is.na(row.names)) {
    if (!identical(as.character(rownames(df)), as.character(1:nrow(df)))) {
        hasRowName <- TRUE
        rowName <- "row_names"
    }
  } else if (is.character(row.names)) {
      hasRowName <- TRUE
      rowName <- row.names
  }

  if (hasRowName) {
    df[,rowName] <- row.names(df)
  }

  # Setting Spark DataFrame schema parameters
  schemaParameters <- NULL

  # Casting schema instead of infer
  if (is.character(field.types) && length(field.types) %in% c(ncol(df), ncol(df)-hasRowName)) {
    field.types.parameters <- NULL

    # Two case: #1 without hasRowName or length(field.types) == ncol(df) OR #2 with hasRowName and length(field.types) == ncol(df)-1
    if (hasRowName && length(field.types) == (ncol(df)-1)) {
        field.types.parameters <- as.data.frame(rbind(
            colnames(df),
            c(field.types, "string")
        ))
    } else if (length(field.types) == ncol(df)) {
        field.types.parameters <- as.data.frame(rbind(
            colnames(df),
            field.types
        ))
    }

    if (!is.null(field.types.parameters)) {
        structFields <- lapply(field.types.parameters, function(x) { SparkR::structField(x[1], x[2]) })
        names(structFields) <- NULL
        schemaParameters <- do.call(SparkR::structType, structFields)
    }
  }

  # Creating Spark DataFrame
  if (is.null(schemaParameters)) {
    sdf <- SparkR::as.DataFrame(df)
  } else {
    sdf <- SparkR::as.DataFrame(df, schema = schemaParameters)
  }

  # Getting writting mode
  if (append) {
    mode = 'append'
  } else if (overwrite) {
    mode = 'overwrite'
  } else {
    mode = 'error'
  }

  # Writting table
  if (temporary) {
    SparkR::createOrReplaceTempView(sdf, name)
  } else {
    SparkR::saveAsTable(sdf, name, mode=mode)
  }
})