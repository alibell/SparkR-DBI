test_that("dbSendQuery produce a SparkResult object", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM test_table")
    expect_s4_class(res, "SparkRResult")
})

test_that("dbSendQuery execute parametrised query", {
    df <- generate_fake_df()
    dbWriteTable(
        conn,
        name = "temp_table_dbsendquery",
        value = df,
        overwrite = TRUE
    )
    expect_true(dbExistsTable(conn, "temp_table_dbsendquery"))
    res <- dbSendQuery(
        conn,
        "DROP TABLE ?table",
        params = list(table = "temp_table_dbsendquery")
    )
    expect_false(dbExistsTable(conn, "temp_table_dbsendquery"))
})

test_that("dbColumnInfo produce the list and type of the columns", {
    generate_fake_sdf()
    df <- generate_fake_df()

    res <- dbSendQuery(conn, "SELECT * FROM test_table")
    info <- dbColumnInfo(res)

    expect_equal(info$name, colnames(df))
    expect_equal(info$type, c("integer", "character"))
    expect_equal(info$sql.type, c("int", "string"))
})

test_that("dbGetStatement return the content of the statement", {
    statement <- "SELECT * FROM test_table"
    res <- dbSendQuery(conn, statement)

    expect_equal(dbGetStatement(res), statement)
})

test_that("dbGetRowCount return the right number of rows", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM test_table")

    expect_equal(dbGetRowCount(res), 3)
})

test_that("dbFetch return the full dataset when n = -1", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM test_table")
    output_df <- dbFetch(res, n = -1)
    input_df <- generate_fake_df()

    expect_equal(output_df, input_df)
})

test_that("dbFetch return a subpart of the dataset when n > 0", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM test_table")
    input_df <- generate_fake_df()

    expect_equal(dbFetch(res, n = 1), input_df[c(1), , drop = FALSE])
    expect_equal(dbFetch(res, n = 1), input_df[c(2), , drop = FALSE])
})

test_that("dbHasCompleted return TRUE when all rows are fetched", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM test_table")
    output_df <- dbFetch(res, n = -1)

    expect_equal(dbHasCompleted(res), TRUE)
})

test_that("dbClearResult clean the content of a SparkRResult object", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM test_table")
    output_df <- dbFetch(res, n = -1)
    dbClearResult(res)

    expect_null(res@state[["df"]])
    expect_true(res@state[["cleared"]])
})

test_that("dbBind fill a parametrised query", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM test_table WHERE a = ?a")
    dbBind(res, a = 1)
    output_df <- dbFetch(res)

    expect_equal(length(unique(output_df$a)), 1)

    res <- dbSendQuery(conn, "SELECT * FROM test_table WHERE a = ?a")
    dbBind(res, params = list(a = 1))
    output_df <- dbFetch(res)
    expect_equal(length(unique(output_df$a)), 1)
})

test_that("dbDataType provide informations about data types", {
    expect_equal(dbDataType(conn, "test"), "STRING")
    expect_equal(dbDataType(conn, 5.0), "DOUBLE")
    expect_equal(dbDataType(conn, as.integer(5)), "INT")
    expect_equal(dbDataType(conn, Sys.Date()), "DATE")
    expect_equal(dbDataType(conn, as.POSIXct.Date(Sys.Date())), "TIMESTAMP")
    expect_equal(dbDataType(conn, TRUE), "BOOLEAN")
    expect_equal(dbDataType(conn, raw(5)), "BINARY")
})

test_that("dbExistsTable return TRUE when a table exists and FALSE otherwise", {
    generate_fake_sdf()
    expect_true(dbExistsTable(conn, "test_table"))
    expect_false(dbExistsTable(conn, "toto"))
})

test_that("dbListFields return the list of fields of a table", {
    generate_fake_sdf()
    expect_equal(dbListFields(conn, "test_table"), c("a", "b"))
})

test_that("dbListTables return the list of tables", {
    generate_fake_sdf()
    expect_true("test_table" %in% dbListTables(conn))
})

test_that("dbQuoteIdentifier correctly quotes the query parameters", {
    expect_equal(dbQuoteIdentifier(conn, "a"), "`a`")
    expect_equal(dbQuoteIdentifier(conn, "a.b"), "`a`.`b`")
    expect_equal(dbQuoteIdentifier(conn, "`a`.b"), "`a`.`b`")
    expect_equal(dbQuoteIdentifier(conn, "`a.b`"), "`a`.`b`")
})

test_that("dbRemoveTable correctly remove the table", {
    df <- generate_fake_df()
    dbWriteTable(
        conn,
        name = "temp_table_remove",
        value = df,
        overwrite = TRUE
    )
    exists_before <- dbExistsTable(conn, "temp_table_remove")
    dbRemoveTable(conn, "temp_table_remove")
    exists_after <- dbExistsTable(conn, "temp_table_remove")

    expect_true(exists_before && !exists_after)
})

test_that("dbWriteTable correctly write, overwrite and append table", {
    df <- generate_fake_df()
    dbWriteTable(
        conn,
        name = "temp_table_dbWrite",
        value = df,
        overwrite = FALSE,
        append = FALSE
    )
    res <- dbSendQuery(conn, "SELECT * FROM temp_table_dbWrite")
    expect_equal(
        dbGetRowCount(res),
        nrow(df)
    )
    dbWriteTable(
        conn,
        name = "temp_table_dbWrite",
        value = df,
        overwrite = TRUE,
        append = FALSE
    )
    res <- dbSendQuery(conn, "SELECT * FROM temp_table_dbWrite")
    expect_equal(
        dbGetRowCount(res),
        nrow(df)
    )

    dbWriteTable(
        conn,
        name = "temp_table_dbWrite",
        value = df,
        overwrite = FALSE,
        append = TRUE
    )
    res <- dbSendQuery(conn, "SELECT * FROM temp_table_dbWrite")
    expect_equal(
        dbGetRowCount(res),
        2 * nrow(df)
    )
})

test_that("dbWriteTable row.names parameter create the dedicated column", {
    df <- generate_fake_df()

    dbWriteTable(
        conn,
        name = "temp_table_dbWrite_rowNames",
        value = df,
        overwrite = TRUE,
        row.names = TRUE
    )
    new_df <- dbGetQuery(conn, "SELECT * FROM temp_table_dbWrite_rowNames")
    expect_equal(
        new_df$row_names,
        rownames(df)
    )

    # --- If row.names if NA and row names is 1:nrow()
    # Then, the column shouldn't be created
    dbWriteTable(
        conn,
        name = "temp_table_dbWrite_rowNames",
        value = df,
        overwrite = TRUE,
        row.names = NA
    )
    new_df <- dbGetQuery(conn, "SELECT * FROM temp_table_dbWrite_rowNames")
    expect_false("row_names" %in% colnames(new_df))

    # --- If row.names if NA and row names is not 1:nrow()
    # Then, the column should be created
    rownames(df) <- c("a", "b", "c")
    dbWriteTable(
        conn,
        name = "temp_table_dbWrite_rowNames",
        value = df,
        overwrite = TRUE,
        row.names = NA
    )
    new_df <- dbGetQuery(conn, "SELECT * FROM temp_table_dbWrite_rowNames")
    expect_equal(
        new_df$row_names,
        rownames(df)
    )

    # --- If row.names if of type character
    # Then, the row_names columns should be named as that
    dbWriteTable(
        conn,
        name = "temp_table_dbWrite_rowNames",
        value = df,
        overwrite = TRUE,
        row.names = "test_row_name"
    )
    new_df <- dbGetQuery(conn, "SELECT * FROM temp_table_dbWrite_rowNames")
    expect_equal(
        new_df$test_row_name,
        rownames(df)
    )
})