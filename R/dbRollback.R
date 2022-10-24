#' dbRollback DBI method
#' Not supported in Spark environment
#' Defined in SparkR-DBI to keep compatibility with dbplyr
#' DBI documentation: https://dbi.r-dbi.org/reference/transactions.html
#' @export
setMethod("dbRollback", "SparkRConnection", function(conn) {
  TRUE
})