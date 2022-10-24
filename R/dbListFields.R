#' dbListFields DBI method
#' Return the columns name according to a table name (example: abc, databaseName.tableName, ...).
#' DBI documentation: https://dbi.r-dbi.org/reference/dbListFields.html
#' @param conn SparkRConnection object
#' @param name Table name
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' dbListFields(db, "mtcars")
#' }
setMethod("dbListFields", signature(conn="SparkRConnection", name="character"), function(conn, name, ...) {
    if (!dbExistsTable(conn, name)) {
        stop("Missing table", name)
    }

    sdf <- SparkR::tableToDF(name)

    SparkR::columns(sdf)
})