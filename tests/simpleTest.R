library(seasonal)

seas(AirPassengers)


if (Sys.getenv("TRAVIS") != ""){

  library(x13story)
  idir <- file.path(Sys.getenv("TRAVIS_BUILD_DIR"), "inst/stories")
  odir <- file.path(Sys.getenv("TRAVIS_BUILD_DIR"), "out")


  # message("Testing Skeleton")
  # sk <- file.path(Sys.getenv("TRAVIS_BUILD_DIR"), "inst/rmarkdown/templates/x13story/skeleton/skeleton.Rmd")
  # sk <- normalizePath(sk)
  # x13story::parse_x13story(file = sk)
  # rmarkdown::render(sk, x13story::x13story())


  ff <- list.files(idir, pattern = "\\.Rmd$", ignore.case = TRUE, full.names = TRUE)

  message("HTML rendering")
  STORIES <- lapply(ff, function(x) x13story::parse_x13story(file = x))
  names(STORIES) <- gsub("(.+?)\\..+", "\\1", basename(ff))
  # save(STORIES, file = file.path(odir, "stories.RData"))

  write.csv(cars, file = file.path(odir, "cars2.csv"))
  message("PDF rendering")
  lapply(ff, function(x) rmarkdown::render(x, x13story::x13story()))
  ipdf <- list.files(idir, pattern = "\\.pdf$", ignore.case = TRUE, full.names = TRUE)

  file.copy(ipdf, file.path(odir, basename(ipdf)))

}




# library(x13story)
# library(rmarkdown)

# idir <- file.path("~/git/x13story/inst/stories")
# odir <- file.path("~/git/x13story/out")

# ff <- list.files(idir, pattern = "\\.Rmd$", ignore.case = TRUE, full.names = TRUE)






# STORIES <- lapply(ff, function(x) x13story::x13story(file = x))

# names(STORIES) <- gsub("(.+?)\\..+", "\\1", basename(ff))

#  