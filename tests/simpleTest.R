library(seasonal)

seas(AirPassengers)


if (Sys.getenv("TRAVIS") != ""){

  library(x13story)
  idir <- file.path(Sys.getenv("TRAVIS_BUILD_DIR"), "inst/stories")
  odir <- file.path(Sys.getenv("TRAVIS_BUILD_DIR"), "out")


  message("Testing Skeleton")
  sk <- file.path(Sys.getenv("TRAVIS_BUILD_DIR"), "inst/rmarkdown/templates/x13story/skeleton/skeleton.Rmd")
  sk <- normalizePath(sk)
  x13story::parse_x13story(file = sk)
  rmarkdown::render(sk, x13story::x13story())


  ff <- list.files(idir, pattern = "\\.Rmd$", ignore.case = TRUE, full.names = TRUE)

  message("HTML rendering")
  STORIES <- lapply(ff, function(x) x13story::parse_x13story(file = x))
  names(STORIES) <- gsub("(.+?)\\..+", "\\1", basename(ff))
  save(STORIES, file = file.path(odir, "stories.RData"))

  write.csv(cars, file = file.path(odir, "cars2.csv"))
  message("PDF rendering")
  lapply(ff, function(x) rmarkdown::render(x, x13story::x13story()))
  ipdf <- list.files(idir, pattern = "\\.pdf$", ignore.case = TRUE, full.names = TRUE)

  file.copy(ipdf, file.path(odir, basename(ipdf)))


  # add a minimal index.html to link PDFs
  header <- '
  <!DOCTYPE html>
  <html>
  <head>
     <meta charset="utf-8">
     <!-- tell google not to index or follow -->
     <meta name="robots" content="noindex,nofollow"/>
  </head>
  '
  footer <- '
  </body>
  </html>
  '
  bn <- basename(ipdf)
  bn <- paste0(gsub(".Rmd", "", bn, ignore.case = TRUE), ".pdf")
  bn.link <- paste0("http://www.chirstophsax.com/x13story/", bn)
  body <- paste0('<a href = "',bn.link ,'">',bn ,'</a>')
  writeLines(c(header, body, footer), file.path(odir, "index.html"))

}


