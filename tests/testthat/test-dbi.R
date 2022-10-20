sc <- load_context()
conn <- createSparkRConnection(sc)

# Populating the spark context
df <- data.frame(a = 1:3, b = c("a", "b", "c"))
sdf <- SparkR::as.DataFrame(df)
SparkR::saveAsTable(sdf, "testTable")

# dbSendQuery should produce a SparkResult object
res <- dbSendQuery(conn, "SELECT * FROM testTable")
expect_identical(class(res), "SparkResult")