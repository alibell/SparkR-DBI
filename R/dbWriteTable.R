#' dbWriteTable DBI method
#' Write a table from a R dataframe.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbWriteTable.html
#' @param conn SparkRConnection object
#' @param name Name of the output table
#' @param value R data.frame to write
#' @param append If TRUE the table is appened to existing one
#' @param overwrite If TRUE, the existing table is overwritten
#' @param temporary If TRUE, the table if written as a temporary view
#' @param row.names If TRUE, a column containing the row names if created,
#'                  if NA it is created only if the row names are different
#'                  from 1:nrow(), if it is a character the created column
#'                  is named according to the row.names value
#' @param field.types Vector containing the type to cast to the written column
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' }
setMethod("dbWriteTable", "SparkRConnection", function(
  conn,
  name,
  value,
  append = FALSE,
  overwrite = FALSE,
  temporary = FALSE,
  row.names = FALSE,
  field.types = FALSE,
  ...
) {
  df <- value
  has_row_name <- FALSE
  row_name <- NULL

  # Processing row.names arguments
  if (!is.na(row.names) && !is.null(row.names) && row.names == TRUE) {
        has_row_name <- TRUE
        row_name <- "row_names"
  } else if (is.na(row.names)) {
    if (!identical(
      as.character(rownames(df)),
      as.character(seq_len(nrow(df)))
    )) {
        has_row_name <- TRUE
        row_name <- "row_names"
    }
  } else if (is.character(row.names)) {
      has_row_name <- TRUE
      row_name <- row.names
  }

  if (has_row_name) {
    df[, row_name] <- row.names(df)
  }

  # Setting Spark DataFrame schema parameters
  schema_parameters <- NULL

  # Casting schema instead of infer
  if (is.character(field.types) &&
      length(field.types) %in% c(
        ncol(df),
        ncol(df) - has_row_name
      )
  ) {
    field_types_parameters <- NULL

    # Two case:
    #   1 without has_row_name
    #     or length(field.types) == ncol(df)
    #   2 with has_row_name
    #   and length(field.types) == ncol(df)-1
    if (has_row_name && length(field.types) == (ncol(df) - 1)) {
        field_types_parameters <- as.data.frame(rbind(
            colnames(df),
            c(field.types, "string")
        ))
    } else if (length(field.types) == ncol(df)) {
        field_types_parameters <- as.data.frame(rbind(
            colnames(df),
            field.types
        ))
    }

    if (!is.null(field_types_parameters)) {
        struct_fields <- lapply(
          field_types_parameters,
          function(x) {
            SparkR::structField(x[1], x[2])
          }
        )
        names(struct_fields) <- NULL
        schema_parameters <- do.call(SparkR::structType, struct_fields)
    }
  }

  # Creating Spark DataFrame
  if (is.null(schema_parameters)) {
    sdf <- SparkR::as.DataFrame(df)
  } else {
    sdf <- SparkR::as.DataFrame(df, schema = schema_parameters)
  }

  # Getting writting mode
  if (append) {
    mode <- "append"
  } else if (overwrite) {
    mode <- "overwrite"
  } else {
    mode <- "error"
  }

  # Writting table
  if (temporary) {
    SparkR::createOrReplaceTempView(sdf, name)
  } else {
    SparkR::saveAsTable(sdf, name, mode = mode)
  }
})