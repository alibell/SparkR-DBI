sc <- load_context()
conn <- createSparkRConnection(sc)

test_that("dbSendQuery produce a SparkResult object", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM testTable")
    expect_s4_class(res, "SparkRResult")
})

test_that("dbColumnInfo produce the list and type of the columns", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM testTable")
    info <- dbColumnInfo(res)

    expect_equal(info$name, colnames(df))
    expect_equal(info$type, c("integer", "character"))
    expect_equal(info$sql.type, c("int", "string"))
})

test_that("dbGetStatement return the content of the statement", {
    statement <- "SELECT * FROM testTable"
    res <- dbSendQuery(conn, statement)

    expect_equal(dbGetStatement(res), statement)
})

test_that("dbGetRowCount return the right number of rows", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM testTable")

    expect_equal(dbGetRowCount(res), 3)
})

test_that("dbFetch return the full dataset when n = -1", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM testTable")
    output_df <- dbFetch(res, n=-1)
    input_df <- generate_fake_df()

    expect_equal(output_df, input_df)
})

test_that("dbFetch return a subpart of the dataset when n > 0", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM testTable")
    input_df <- generate_fake_df()

    expect_equal(dbFetch(res, n=1), input_df[c(1),,drop=FALSE])
    expect_equal(dbFetch(res, n=1), input_df[c(2),,drop=FALSE])
})

test_that("dbHasCompleted return TRUE when all rows are fetched", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM testTable")
    output_df <- dbFetch(res, n=-1)

    expect_equal(dbHasCompleted(res), TRUE)
})

test_that("dbClearResult clean the content of a SparkRResult object", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM testTable")
    output_df <- dbFetch(res, n=-1)
    dbClearResult(res)

    except_null(res@state[["df"]])
    except_true(res@state[["cleared"]])
})