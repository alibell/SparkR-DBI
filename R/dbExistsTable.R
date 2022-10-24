
#' dbExistsTable DBI method
#' Check for table existence
#' If the table name if a simple string (example: abc), the table is searched inside the current used database.
#' If the table name contains a dot (example: databaseName.abc), the table is searched inside the specified database, named databaseName in this example.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbExistsTable.html
#' @param conn SparkRConnection object
#' @param name Database name
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' dbExistsTable(db, "mtcars")
#' }
setMethod("dbExistsTable", signature(conn="SparkRConnection"), function(conn, name, ...) {
    name_components <- strsplit(name, "\\.")[[1]]
    if (length(name_components) == 2) {
        table <- name_components[1]
        database <- name_components[2]
    } else {
        table <- name_components[1]
        database <- NULL
    }

    exists <- tolower(table) %in% dbListTables(conn, database=database)

    exists
})