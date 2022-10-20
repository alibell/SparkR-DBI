# Generating a SparkContext
library(DBI)
sc <- SparkR::sparkR.session(
    master = "local", 
    sparkConfig = list(spark.driver.memory = "2g")
)
conn <- createSparkConnection(sc)