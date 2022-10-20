sc <- load_context()
conn <- createSparkRConnection(sc)
df <- data.frame(a = 1:3, b = c("a", "b", "c"))

test_that("dbSendQuery produce a SparkResult object", {
    sdf <- SparkR::as.DataFrame(df)
    SparkR::saveAsTable(sdf, "testTable", mode="overwrite")
    res <- dbSendQuery(conn, "SELECT * FROM testTable")
    expect_s4_class(res, "SparkRResult")
})

test_that("dbColumnInfo produce the list and type of the columns", {
    sdf <- SparkR::as.DataFrame(df)
    SparkR::saveAsTable(sdf, "testTable", mode="overwrite")
    res <- dbSendQuery(conn, "SELECT * FROM testTable")
    info <- dbColumnInfo(res)

    expect_equal(info$name, colnames(df))
    expect_equal(info$type, sapply(df, class))
    expect_equal(info$sql.type, sapply("integer", "string"))
})