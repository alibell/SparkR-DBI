sc <- load_context()
conn <- createSparkRConnection(sc)
df <- data.frame(a = 1:3, b = c("a", "b", "c"))

test_that("dbSendQuery produce a SparkResult object", {
    sdf <- SparkR::as.DataFrame(df)
    SparkR::saveAsTable(sdf, "testTable", overwrite=T)
    res <- dbSendQuery(conn, "SELECT * FROM testTable")
    message(class(res))
    expect_identical(class(res), "SparkResult")
})