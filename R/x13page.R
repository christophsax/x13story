#' @export
x13page <- function(cstr, view){
  z <- list()
  z$cstr <- cstr
  z$view <- view
  class(z) <- "x13page"
  z
}

#' @method print x13page
#' @export
print.x13page <- function(x){
  m <- eval(parse(text = x$cstr), envir = globalenv())
  cat("Model: ", x$cstr, "\n")
  cat("View:  ", x$view)

  if (x$view == 'main') {
    dta <- cbind(raw = original(m), adjusted = final(m))
    return(xplot(dta))
  }
  s <- series(m, series = x$view)
  xplot(s, ylab = x$view)
}
