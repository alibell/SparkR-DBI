#' @export
setMethod("dbRemoveTable", signature(conn="SparkRConnection", name="character"), function(conn, name, temporary=FALSE, fail_if_missing=TRUE, ...) {
    temporaryTables <- SparkR::collect(
        SparkR::select(
            SparkR::filter(SparkR::tables(), "isTemporary = TRUE")
            , "tableName"
        )
    )$tableName
    exists <- dbExistsTable(conn, name)
    isTemporary <- name %in% temporaryTables

    # Check that name is a temporary table if temporary parameter is TRUE
    if (temporary && !isTemporary) {
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