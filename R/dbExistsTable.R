#' @export
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