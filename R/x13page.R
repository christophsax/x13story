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
  x13view(m, x$view)
}

#' @export
x13view <- function(x, view){
  # this will also deal with the website specific views, such as 'main'
  if (view == 'main') {
    dta <- cbind(raw = original(x), adjusted = final(x))
    return(xplot(dta))
  }
  s <- series(x, series = view)
  xplot(s, ylab = view)
}
