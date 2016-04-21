library(seasonal)
seas(AirPassengers)


if (Sys.getenv("TRAVIS") != ""){
  odir <- file.path(Sys.getenv("TRAVIS_BUILD_DIR"), "out")
  write.csv(cars, file = file.path(odir, "cars.csv"))
}


