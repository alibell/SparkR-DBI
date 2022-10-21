#' @export
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

    data.frame(name=columns, type=columns_type, sql.type=columns_sql_type,stringsAsFactors = FALSE)
})