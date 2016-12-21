# #' @export
# x13page <- function(cstr, view){
#   z <- list()
#   z$cstr <- cstr
#   z$view <- view
#   class(z) <- "x13page"
#   z
# }

# #' @method print x13page
# #' @export
# print.x13page <- function(x){
#   m <- eval(parse(text = x$cstr), envir = globalenv())
#   cat("Model: ", x$cstr, "\n")
#   cat("View:  ", x$view)

#   if (x$view == 'main') {
#     dta <- cbind(raw = original(m), adjusted = final(m))
#     return(xplot(dta))
#   }
#   s <- series(m, series = x$view)
#   xplot(s, ylab = x$view)
# }



#' Initialize an interacitve view
#'
#' @param m an object of class \code{"seas"}
#' @param series character string indicating which series to show (see
#'   \code{?series})
#' @param pdf.summary  logical, should a summary be shown in pdf mode
#' @param pdf.call   logical, should a call be shown in pdf mode
#' @param pdf.series    logical, should a series be shown in pdf mode
#' @export
#' @import seasonal
#' @examples
#' view(story = system.file("stories", "outlier", package="x13story"))
x13view <- function(m, series = "main"){

  x13view.mode = getOption("x13view.mode", "pdf")

  if (x13view.mode != "pdf") {
    ee <- parent.frame()
    all.obj <- ls(envir = ee)
    
    # find out which objects from the parent frame are used in the call.
    # Its a hack, but it should even work with user defined functions.
    cl_as_list <- function(cl){
      z <- as.list(cl)
      isc <- sapply(z, is.call)
      z[isc] <- lapply(z[isc], cl_as_list)
      z
    }
    
    ll <- cl_as_list(m$call)
    obj.in.call <- unlist(lapply(ll, as.character))
    obj <- intersect(all.obj, obj.in.call)
    data <- lapply(obj, get, envir = ee)
    names(data) <- obj
    # we add series.view to the seas object, the same way as we treat it in 
    # server.R
    m$series.view = series
    z <- list(m = m, data = data)
    class(z) <- "x13view"

    l.x13view <- get("l.x13view", envir = getOption("x13view.env"))

    if (is.null(l.x13view)){
      assign("l.x13view", list(z), envir = getOption("x13view.env"))
    } else {
      assign("l.x13view", c(l.x13view, list(z)), envir = getOption("x13view.env"))
    }
  }
  
}
