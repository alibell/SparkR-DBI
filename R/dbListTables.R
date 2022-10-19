#' @export
setMethod("dbListTables", signature(conn="SparkRConnection"), function(conn, database=NULL, ...) {
    tables <- SparkR::tableNames(database)
    unlist(tables)
})