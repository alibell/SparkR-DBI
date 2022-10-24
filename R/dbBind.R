#' dbBind DBI method
#' Parametrised query is not officialy supported in Spark environment,
#' it is here managed with the sqlInterpolate method
#' DBI documentation: https://dbi.r-dbi.org/reference/dbBind.html
#' @param res SparkRResult object
#' @param params List of parameters values
#' @param ... Extra parameters
#' @export
#' @examples
#' \dontrun{
#' db <- createSparkRConnection(sc=sc)
#' dbWriteTable(db, "mtcars", mtcars)
#' res <- dbGetQuery(db, "SELECT * FROM mtcars WHERE cyl == ?cyl")
#' dbBind(res, cyl = 4)
#' dbFetch(res)
#' }
setMethod("dbBind",
          "SparkRResult",
          function(res, params, ...) {
  extra_parameters <- list(...)

  for (i in seq_along(extra_parameters)) {
    param_name <- names(extra_parameters)[i]
    if (!(param_name %in% names(params)) && param_name != "params") {
      params[[param_name]] <- extra_parameters[[param_name]]
    }
  }

  params[["conn"]] <- res@conn
  params[["sql"]] <- res@statement
  res@state$statement <- do.call(sqlInterpolate, params)
})
