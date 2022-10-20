# Generating a SparkContext
load(DBI)
sc <- SparkR::sparkR.session(
    master = "local", 
    sparkConfig = list(spark.driver.memory = "2g")
)
