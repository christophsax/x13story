#' X-13 story format.
#'
#' Format for creating X-13 stories.
#'
#' @inheritParams rmarkdown::pdf_document
#' @param ... Arguments to \code{rmarkdown::pdf_document}
#'
#' @return R Markdown output format to pass to
#'   \code{\link[rmarkdown:render]{render}}
#'
#' @examples
#'
#' \dontrun{
#' library(rmarkdown)
#' draft("MyArticle.Rmd", template = "x13_handout", package = "x13story")
#' }
#'
#' @export
x13_handout <- function(...) {

  x13_handout.sty <- system.file("rmarkdown", "templates", "x13_handout", "skeleton",
                              "x13_handout.sty",
                               package = "x13story")

  z <- rmarkdown::pdf_document(..., fig_caption = TRUE, includes = rmarkdown::includes(in_header = x13_handout.sty))

  z
}



