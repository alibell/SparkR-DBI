# Generating a SparkContext
sc <- sparkR.session(
    master = "local", 
    sparkConfig = list(spark.driver.memory = "2g")
)
print(sc)