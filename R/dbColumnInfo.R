#' @export
setMethod("dbColumnInfo", "SparkRResult", function(res, ...) {
    # We get the R type by collecting a row

    sdf <- SparkR::sql(res@state$statement)
    columns <- SparkR::columns(sdf)
    columns_sql_type <- sapply(SparkR::dtypes(sdf), function(x) { x[2] })
    columns_type <- sapply(
        SparkR::collect(
            SparkR::limit(sdf, 1)
        ), 
        class
    )

    data.frame(name=columns, type=columns_type, sql.type=columns_sql_type)
})