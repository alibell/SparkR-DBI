#' @export
setMethod("dbExistsTable", signature(conn="SparkRConnection"), function(conn, name, ...) {
    exists <- tryCatch(
        expr = {
            SparkR::tableToDF(name)
            exists <- TRUE
        },
        error = function(e){ 
            exists <- FALSE
        }
    )

    exists
})