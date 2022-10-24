#' dbQuoteIdentifier DBI method
#' Generate quote to prevent SQL injection.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbQuoteIdentifier.html
#' @param conn SparkRConnection object
#' @param x String to encapsulate with quotes
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbQuoteIdentifier(db, "databaseName.columnName")
#' }
setMethod("dbQuoteIdentifier",
        signature(conn = "SparkRConnection", x = "character"),
        function(conn, x) {
    # Spitting according to dot
    string_components <- strsplit(x, "\\.")[[1]]
    # Removing escape characters
    string_components <- sapply(
        string_components,
        function(content) {
            gsub("^`|`$", "", content)
        }
    )
    # Generating output
    string_components <- sapply(
        string_components,
        function(x) {
            paste("`", x, "`", sep = "")
        }
    )
    output <- paste(string_components, collapse = ".")
    output
})