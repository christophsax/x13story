#' Deprecated Viewer Function
#' @param x character, path to the rmarkdown file containing an X-13 story.
#' 
#' @export
viewer <- function(x){ 
  stop("The viewer function is defunct. Use instead: \n\n  view(story = x)")
  view(story = x)
}
