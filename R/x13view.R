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





#' @export
x13view <- function(m, series = "main", pdf.call = FALSE, pdf.series = FALSE, pdf.summary = FALSE){
  x13view.mode = getOption("x13view.mode", "pdf")

  if (x13view.mode == "pdf") {  # storymode "pdf" "web"

    # m <- eval(parse(text = z$cstr), envir = globalenv())

    if (pdf.summary){
      prettysummary(m)
    } 

    if (pdf.call){
      cat("Call:\n", paste(deparse(m$call), sep = "\n", collapse = "\n"))
    }
    
    if (pdf.series){
      if (series == 'main') {
        s <- cbind(raw = original(m), adjusted = final(m))
      } else {
        s <- series(m, series = series)
      }
      prettyplot(s, ylab = series)
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
    class(z) <- "x13view"
    if (exists("gX13view")){
      gX13view <<- c(gX13view, list(z))
    } else {
      gX13view <<- list(z)
    }
  }
  
  
}
