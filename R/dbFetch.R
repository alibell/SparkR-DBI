#' dbFetch DBI method
#' Fetch results from a SparkRResult object.
#' As Spark doesn't support cursor, we simulate this by fetching and keeping
#' in memory the whole DataFrame during the first fetch and then deliver
#' the requested subparts of that DataFrame.
#' DBI documentation: https://dbi.r-dbi.org/reference/dbFetch.html
#' @param res SparkRResult object
#' @param n Number of rows to fetch, if n=-1 all the rows are fetched
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' res <- dbGetQuery(db, "SELECT * FROM mtcars")
#' dbFetch(res, n=10)
#' }
setMethod("dbFetch", "SparkRResult", function(res, n = -1, ...) {
  if (res@state[["completed"]]) {
    stop("All the results have been fetched")
  }

  if (res@state[["cleared"]]) {
    stop("Result cleared")
  }

  sdf <- SparkR::sql(as.character(
    res@state$statement
  ))

  if (n == 0) {
    return(SparkR::collect(
        SparkR::limit(sdf, 0)
    ))
  }

  # Cannot collect with iterator with R, we shall collect everything
  if (is.null(res@state[["df"]])) {
    # Collecting the DF once
    res@state[["df"]] <- SparkR::collect(sdf)
  }
  df <- res@state[["df"]]

  # Getting start and end offset
  start <- res@state[["start"]]
  end <- res@state[["end"]]

  if (n > 0) {
    end <- start + n - 1
  } else {
    end <- nrow(df)
  }
  end <- min(end, nrow(df))

  # Getting output dataframe
  output_df <- df[start:end, colnames(df), drop = FALSE]

  # Updating start and end date
  if (end == nrow(df)) {
    res@state[["start"]] <- NULL
    res@state[["completed"]] <- TRUE
  } else {
    res@state[["start"]] <- end + 1
  }
  res@state[["end"]] <- -1

  return(output_df)
})