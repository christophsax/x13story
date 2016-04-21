#' X-13 story format
#'
#' Format for creating X-13 stories
#' 
#' @param fig_width  to be implemented
#' @export
x13story <- function(fig_width = 5) {

  x13story.sty <- system.file("rmarkdown", "templates", "x13story", "skeleton",
                              "x13story.sty",
                               package = "x13story")

  z <- rmarkdown::pdf_document(fig_caption = TRUE, includes = rmarkdown::includes(in_header = x13_handout.sty))

  z
}
