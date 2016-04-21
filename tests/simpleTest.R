library(seasonal)
seas(AirPassengers)


if (Sys.getenv("TRAVIS") != ""){

  library(x13story)
  idir <- file.path(Sys.getenv("TRAVIS_BUILD_DIR"), "inst/stories")
  odir <- file.path(Sys.getenv("TRAVIS_BUILD_DIR"), "out")

  ff <- list.files(idir, pattern = "\\.Rmd$", ignore.case = TRUE, full.names = TRUE)

  STORIES <- lapply(ff, function(x) x13story::parse_x13story(file = x))

  names(STORIES) <- gsub("(.+?)\\..+", "\\1", basename(ff))

  save(STORIES, file = file.path(odir, "stories.RData"))
}




# library(x13story)
# idir <- file.path("~/git/x13story/inst/stories")
# odir <- file.path("~/git/x13story/out")

# ff <- list.files(idir, pattern = "\\.Rmd$", ignore.case = TRUE, full.names = TRUE)

# STORIES <- lapply(ff, function(x) x13story::parse_x13story(file = x))

# names(STORIES) <- gsub("(.+?)\\..+", "\\1", basename(ff))

#  