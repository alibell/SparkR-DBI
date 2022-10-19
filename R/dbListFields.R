#' @export
setMethod("dbListFields", signature(conn="SparkRConnection", name="character"), function(conn, name, ...) {
    if (!dbExistsTable(conn, name)) {
        stop("Missing table", name)
    }

    sdf <- SparkR::tableToDF(name)

    SparkR::columns(sdf)
})