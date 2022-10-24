#' dbRemoveTable DBI method
#' Remove a table according to its name.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbRemoveTable.html
#' @param conn SparkRConnection object
#' @param name Table to remove
#' @param temporary If TRUE the table is removed only it is a temporary table
#' @param fail_if_missing If TRUE the table an error
#'                        is raised if the table if missing
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' dbRemoveTable(db, "mtcars")
#' }
setMethod("dbRemoveTable", signature(
        conn = "SparkRConnection",
        name = "character"
    ), function(
        conn,
        name,
        temporary = FALSE,
        fail_if_missing = TRUE,
        ...
    ) {
        temporary_tables <- SparkR::collect(
            SparkR::select(
                SparkR::filter(SparkR::tables(), "isTemporary = TRUE")
                , "tableName"
            )
        )$tableName
        exists <- dbExistsTable(conn, name)
        is_temporary <- name %in% temporary_tables

        # Check that name is a temporary table if temporary parameter is TRUE
        if (temporary && !is_temporary) {
            stop(name, " is not a temporary table.")
        }

        # Check that the table exists
        if (fail_if_missing && !exists) {
            stop("Missing table ", name)
        }

        # Removing table
        if (exists) {
            query <- paste("DROP TABLE", dbQuoteIdentifier(conn, name))
            SparkR::sql(query)
        }
})