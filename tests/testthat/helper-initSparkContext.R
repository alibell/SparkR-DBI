# Generating a SparkContext
load_context <- function() {
    sc <- SparkR::sparkR.session(
        master = "local", 
        sparkConfig = list(spark.driver.memory = "2g")
    )
    
    return (sc)
}
