# Generating a SparkContext
load_context <- function() {
    sc <- SparkR::sparkR.session()
    
    return (sc)
}

generate_fake_df <- function () {
    return(data.frame(a = 1:3, b = c("a", "b", "c"), stringsAsFactors = FALSE))
}

# Generate DF
generate_fake_sdf <- function() {
    load_context()

    if (!("testDF" %in% SparkR::tableNames())) {
        df <- generate_fake_df()
        sdf <- SparkR::as.DataFrame(df)
        SparkR::saveAsTable(sdf, "test_table", mode="overwrite")
    }
}

sc <- load_context()
conn <- createSparkRConnection(sc)
