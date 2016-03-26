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
snapshot <- function(m, series = "main", pdf.call = FALSE, pdf.series = TRUE, pdf.summary = FALSE){
  if (TRUE) {  # storymode "pdf" "web"

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
  }
  
}
