test_that("dbSendQuery produce a SparkResult object", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM testTable")
    expect_s4_class(res, "SparkRResult")
})

test_that("dbColumnInfo produce the list and type of the columns", {
    generate_fake_sdf()
    df <- generate_fake_df()

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

    expect_null(res@state[["df"]])
    expect_true(res@state[["cleared"]])
})

test_that("dbBind fill a parametrised query", {
    generate_fake_sdf()
    res <- dbSendQuery(conn, "SELECT * FROM testTable WHERE a = ?a")
    dbBind(res, a=1)
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
    expect_true(dbExistsTable(conn, "testTable"))
    expect_false(dbExistsTable(conn, "toto"))
})

test_that("dbListFields return the list of fields of a table", {
    expect_equal(dbListFields(conn, "testTable"), c("a", "b"))
})

test_that("dbListTables return the list of tables", {
    generate_fake_sdf()
    expect_true("testTable" %in% dbListTables(conn))
})

test_that("dbQuoteIdentifier correctly quotes the query parameters", {
    expect_equal(dbQuoteIdentifier(conn, "a"), "`a`")
    expect_equal(dbQuoteIdentifier(conn, "a.b"), "`a`.`b`")
    expect_equal(dbQuoteIdentifier(conn, "`a`.b"), "`a`.`b`")
    expect_equal(dbQuoteIdentifier(conn, "`a.b`"), "`a`.`b`")
})

test_that("dbRemoveTable correctly remove the table", {
    df <- generate_fake_df()
    dbWriteTable(conn, name="temp_table", value=df, overwrite=TRUE)
    existsBefore <- dbExistsTable("temp_table")
    dbRemoveTable(conn, "temp_table")
    existsAfter <- dbExistsTable("temp_table")

    expect_true(existsBefore && !existsAfter)
})

test_that("dbWriteTable correctly write, overwrite and append table", {
    df <- generate_fake_df()
    dbWriteTable(conn, name="temp_table_dbWrite", value=df, overwrite=FALSE, append=FALSE)
    expect_equal(
        dbGetRowCount(dbSendQuery("SELECT * FROM temp_table_dbWrite")), 
        nrow(df)
    )
    
    dbWriteTable(conn, name="temp_table_dbWrite", value=df, overwrite=TRUE, append=FALSE)
    expect_equal(
        dbGetRowCount(dbSendQuery("SELECT * FROM temp_table_dbWrite")), 
        nrow(df)
    )

    dbWriteTable(conn, name="temp_table_dbWrite", value=df, overwrite=FALSE, append=TRUE)
    expect_equal(
        dbGetRowCount(dbSendQuery("SELECT * FROM temp_table_dbWrite")), 
        2*nrow(df)
    )
})

test_that("dbWriteTable row.names parameter create the dedicated column", {
    df <- generate_fake_df()

    dbWriteTable(conn, name="temp_table_dbWrite", value=df, overwrite=TRUE, row_names=TRUE)
    new_df <- dbGetQuery(conn, "SELECT * FROM temp_table_dbWrite")
    expect_equal(
        new_df$row_names,
        rownames(df)
    )

    # --- If row.names if NA and row names is 1:nrow(), the column shouldn't be created
    dbWriteTable(conn, name="temp_table_dbWrite", value=df, overwrite=TRUE, row_names=NA)
    new_df <- dbGetQuery(conn, "SELECT * FROM temp_table_dbWrite")
    expect_false("row_names" %in% colnames(new_df))

    # --- If row.names if NA and row names is not 1:nrow(), the column should be created
    colnames(df) <- c("a", "b", "c")
    dbWriteTable(conn, name="temp_table_dbWrite", value=df, overwrite=TRUE, row_names=NA)
    new_df <- dbGetQuery(conn, "SELECT * FROM temp_table_dbWrite")
    expect_equal(
        new_df$row_names,
        rownames(df)
    )

    # --- If row.names if of type character, the row_names columns should be named as that
    dbWriteTable(conn, name="temp_table_dbWrite", value=df, overwrite=TRUE, row_names="test_row_name")
    new_df <- dbGetQuery(conn, "SELECT * FROM temp_table_dbWrite")
    expect_equal(
        new_df$test_row_name,
        rownames(df)
    )
})

test_that("dbWriteTable field.types should force casting", {
    df <- generate_fake_df()

    dbWriteTable(conn, name="temp_table_dbWrite_field_type", value=df, overwrite=TRUE, row.names=FALSE, field.types=c("string", "string"))
    expect_equal(
        dbColumnInfo(dbSendQuery("SELECT * FROM temp_table_dbWrite_field_type"))$sql.type,
        c("string", "string")
    )
}
