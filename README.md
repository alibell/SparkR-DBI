# SparkR DBI

This package is a DBI front-end for the SparkR packages.  
It provides all the needed libraries to enable SparkR compatibility with DBI based tools.

## Installation

You should have `SparkR` and `remotes` installed in your R environment.  
Then, you can install the packages using `remotes`.

```
    Sys.setenv(GITHUB_PAT="")
    remotes::install_github("alibell/SparkR-DBI")
```

## How to use it

The SparkR DBI library provides an object from the S4 class `SparkRConnection`. You should initialize it from your SparkR session as follow :

```
    library(DBI)
    library(SparkRDBI)
    
    sc <- SparkR::SparkR.session() # Create your SparkR session with proper paramters is missing
    conn <- createSparkRConnection(sc)
```

Then, you can use it like a traditional `DBIConnection` object, example:
```
    dbWriteTable(conn, "mtcars", mtcars)
    dbGetQuery(conn, "SELECT * FROM mtcars WHERE cyl == 4")
```

# Collaborations

This project is under MIT licence.  
I am open to public collaborations.  
In case of changes, you should check that the unit-test are still appropriate. Only the PR which pass all the unit-test will be merged.