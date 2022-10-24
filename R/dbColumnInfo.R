#' dbColumnInfo DBI method
#' Describe columns name, type and sql.type from a SparkRResult object
#' To correctly get the R type of the columns, the method evaluate and collect a row from the query. This can fail in case of the existence of heterogenous data type in the column (example: with NA an integer can be casted to float)
#' DBI documentation: https://dbi.r-dbi.org/reference/dbColumnInfo.html
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' res <- dbGetQuery(db, "SELECT * FROM mtcars WHERE cyl == ?cyl")
#' dbColumnInfo(res)
#' }
setMethod("dbColumnInfo", "SparkRResult", function(res, ...) {
    # We get the R type by collecting a row

    sdf <- SparkR::sql(res@state$statement)
    columns <- as.character(SparkR::columns(sdf))
    columns_sql_type <- as.character(sapply(SparkR::dtypes(sdf), function(x) { x[2] }))
    columns_type <- as.character(sapply(
        SparkR::collect(
            SparkR::limit(sdf, 1)
        ), 
        class
    ))

    data.frame(name=columns, type=columns_type, sql.type=columns_sql_type, stringsAsFactors = FALSE)
})