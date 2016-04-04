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
#' draft("MyArticle.Rmd", template = "x13story_article", package = "x13story")
#' }
#'
#' @export
x13_handout <- function(...) {
  library(x13story)

  # template <- find_resource("x13story_article", "template.tex")

  # base <- inherit_pdf_document(..., template = template)

  # z <- rmarkdown::pdf_document(...)
  # z$inherits <- "pdf_document"
  # z

  x13_handout.sty <- system.file("rmarkdown", "templates", "x13_handout", "skeleton",
                              "x13_handout.sty",
                               package = "x13story")

  # template.tex <- system.file("rmarkdown", "templates", "x13story_article", 
  #                           "template.tex",
  #                            package = "x13story")

# browser()
  z <- rmarkdown::pdf_document(..., fig_caption = TRUE, includes = includes(in_header = x13_handout.sty))

  # z <- rmarkdown::pdf_document(..., template = template.tex)

    # includes:
    #   in_header: x13story.sty   

  # add sty to pandoc_args
  # z$pandoc$args <- c(z$pandoc$args,
  #                      "--sty",
  #                      rmarkdown::pandoc_path_arg(sty))

  z
}




 

#   # Render will generate tex file, post-process hook generates appropriate
#   # RJwrapper.tex and use pandoc to build pdf from that
#   base$pandoc$to <- "latex"
#   base$pandoc$ext <- ".tex"

#   # base$post_processor <- function(metadata, utf8_input, output_file, clean, verbose) {
#   #   filename <- tools::file_path_sans_ext(basename(output_file))
#   #   wrapper_metadata <- list(preamble = metadata$preable, filename = filename)
#   #   wrapper_template <- find_resource("x13story_article", "RJwrapper.tex")
#   #   wrapper_output <- file.path(getwd(), "RJwrapper.tex")
#   #   template_pandoc(wrapper_metadata, wrapper_template, wrapper_output, verbose)

#   #   tools::texi2pdf("RJwrapper.tex", clean = clean)
#   #   "RJwrapper.pdf"
#   # }

#   # # Mostly copied from knitr::render_sweave
#   # base$knitr$opts_chunk$comment <- "#>"

#   # hilight_source <- knitr_fun('hilight_source')
#   # hook_chunk = function(x, options) {
#   #   if (output_asis(x, options)) return(x)
#   #   paste('\\begin{Schunk}\n', x, '\\end{Schunk}', sep = '')
#   # }
#   # hook_input <- function(x, options)
#   #   paste(c('\\begin{Sinput}', hilight_source(x, 'sweave', options), '\\end{Sinput}', ''),
#   #     collapse = '\n')
#   # hook_output <- function(x, options) paste('\\begin{Soutput}\n', x, '\\end{Soutput}\n', sep = '')

#   # base$knitr$knit_hooks$chunk   <- hook_chunk
#   # base$knitr$knit_hooks$source  <- hook_input
#   # base$knitr$knit_hooks$output  <- hook_output
#   # base$knitr$knit_hooks$message <- hook_output
#   # base$knitr$knit_hooks$warning <- hook_output
#   # base$knitr$knit_hooks$plot <- knitr::hook_plot_tex

#   base
# }


