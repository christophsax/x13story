

# #' @export
# inspect2 <- function(x = NULL, fun = NULL, check.version = TRUE, quiet = TRUE, ...){ 

#   if (!requireNamespace("shiny", quietly = TRUE)){
#     stop("the inspect function depends on the 'shiny' package. To install it from CRAN, type: \n\n  install.packages('shiny')\n ")
#   }

#   if (packageVersion("shiny") < "0.14.0" && check.version){
#     stop("You need to have at least shiny version 0.14.0 installed to run inspect smoothly. To ignore this test, use the 'check.version = FALSE' argument. To update shiny from CRAN, type:  \n\n  install.packages('shiny')\n")
#   }

#   # if (!inherits(x, "seas")){
#   #   stop("first argument must be of class 'seas'")
#   # }

#   cat("Press ESC (or Ctrl-C) to get back to the R session\n")



#   wd <- system.file("app", package = "seasonalInspect")
#   # source(file.path(wd, "global.R"), local = TRUE)

#   # init.model <- x
#   # init.icstr <- format_seascall(init.model$call)


#   shiny::runApp(wd)

# }



# an example


#' Local Display of Interactive Stories
#' @param file character, path to the rmarkdown file containing an X-13 story.
#' @param quiet logical, should the output of shiny be suppressed
#' @examples
#' \dontrun{
#' file <- system.file(package = "x13story", "stories", "x11.Rmd")
#' viewer(file)
#' }
#' 
#' @export
viewer <- function(file, quiet = TRUE){ 

  if (!grepl("\\.Rmd", file, ignore.case = TRUE)){
    stop("File must have rmarkdown extension (.Rmd)")
  }

  # auto download from the internet
  if (grepl("^http", file)){
    tfile <- tempfile(fileext = ".Rmd")
    download.file(file, tfile)
    file <- tfile
  }

  file <- normalizePath(file)
  story.rendered <- x13story::parse_x13story(file = file)

  cat("Press ESC (or Ctrl-C) to get back to the R session\n")

  wd <- system.file("app", package = "seasonalInspect")
  shiny::runApp(wd, quiet = quiet)

}

