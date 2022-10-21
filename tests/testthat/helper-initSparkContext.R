# Generating a SparkContext
load_context <- function() {
    sc <- SparkR::sparkR.session()
    
    return (sc)
}

generate_fake_df <- function () {
    return(data.frame(a = 1:3, b = c("a", "b", "c")))
}

# Generate DF
generate_fake_sdf <- function() {
    if (!("testDF" %in% SparkR::tableNames())) {
        sdf <- SparkR::as.DataFrame(df)
        SparkR::saveAsTable(sdf, "testTable")
    }
}