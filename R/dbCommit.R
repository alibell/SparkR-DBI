#' dbBegin DBI method
#' Not supported in Spark environment
#' Defined in SparkR-DBI to keep compatibility with dbplyr
#' DBI documentation: https://dbi.r-dbi.org/reference/transactions.html
#' @param conn SparkRConnection object
#' @export
setMethod("dbCommit", "SparkRConnection", function(conn) {
  TRUE
})