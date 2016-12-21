#' Initialize an interacitve view
#'
#' @param m an object of class \code{"seas"}
#' @param series character string indicating which series to show (see
#'   \code{?series})
#' @param pdf    logical, should a plot be drawn in pdf mode
#' @export
#' @examples
#' # view(story = system.file("stories", "outlier.Rmd", package="x13story"))
x13page <- function(m, series = "main", pdf = TRUE){

  x13page.mode = getOption("x13page.mode", "pdf")

  if (x13view.mode == "pdf") {  # storymode "pdf" "web"
    # if (pdf.summary){
    #   prettysummary(m)
    # } 

    # if (pdf.call){
    #   cat("Call:\n", paste(deparse(m$call), sep = "\n", collapse = "\n"))
    # }
    
    if (pdf.series){
      if (series == 'main') {
        s <- cbind(raw = original(m), adjusted = final(m))
      } else {
        s <- series(m, series = series)
      }
      prettify(plot(s, ylab = series, main = ""))
    }
  } else {
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
    class(z) <- "x13page"

    l.x13page <- get("l.x13page", envir = getOption("x13page.env"))

    if (is.null(l.x13page)){
      assign("l.x13page", list(z), envir = getOption("x13page.env"))
    } else {
      assign("l.x13page", c(l.x13page, list(z)), envir = getOption("x13page.env"))
    }
  }
  
}
