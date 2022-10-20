# Generating a SparkContext
load_context <- function() {
    sc <- SparkR::sparkR.session()
    
    return (sc)
}
