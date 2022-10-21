#' @export
setMethod("dbFetch", "SparkRResult", function(res, n=-1, ...) {
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
  output_df <- df[start:end, colnames(df), drop=FALSE]
 
  # Updating start and end date
  if (end == nrow(df)) {
    res@state[["start"]] <- NULL
    res@state[["completed"]] <- TRUE
  } else {
    res@state[["start"]] <- end + 1
  }
  res@state[["end"]] <- -1

  return (output_df)
})