#' dbListTables DBI method
#' Return the tables name according to a database name.
#' If the database name is NULL, the current database table are listed.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbListTables.html
#' @param conn SparkRConnection object
#' @param database Database name
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' dbListTables(db)
#' }
setMethod("dbListTables",
        signature(conn = "SparkRConnection"),
        function(conn, database = NULL, ...) {
    tables <- SparkR::tableNames(database)
    unlist(tables)
})