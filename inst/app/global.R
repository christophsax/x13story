library(seasonal)
library(dygraphs)
library(xts)

data(holiday)
data(seasonal)

data(holiday, envir = environment())  # avoid side effects

gLdir = "www/log7134/"



# --- List with options ------------------------------------------------------

lFOpts <- list()
lFOpts$method <- c("SEATS", "X11")

lFOpts$transform <- 
  list("AUTOMATIC" = list("AIC Test" = "auto"), 
       "MANUAL" = list("Logarithmic" = "log", 
                       "Square Root" = "sqrt",
                       "No Transformation" = "none"))

lFOpts$arima <- 
  list("AUTOMATIC" = list("Auto Search" = "auto"))

lFOpts$outlier <- 
  list("AUTOMATIC" = list("Auto Critical Value" = "auto", 
                          "Low Critical Value (3)" = "cv3", 
                          "Medium Critical Value (4)" = "cv4",
                          "High Critical Value (5)" = "cv5"), 
       "MANUAL" = list("No detection" = "none"))

lFOpts$easter <- 
  list("AUTOMATIC" = list("AIC Test Easter" = "easter.aic"), 
      "MANUAL" = list("1-Day before Easter" = "easter[1]", 
                      "1-Week before Easter" = "easter[8]", 
                      "Chinese New Year" = "cny",
                      "Indian Diwali" = "diwali",
                      "No Adjustment" = "none"))
lFOpts$td <- 
  list("AUTOMATIC" = list("AIC Test" = "td.aic"), 
      "MANUAL" = list("1-Coefficient" = "td1coef", 
                      "6-Coefficients" = "td", 
                      "No Adjustment" = "none"))

lFOpts.unlist <- lapply(lFOpts, unlist)


lFOpts.user <- lFOpts
for (i in 2:length(lFOpts)){
   lFOpts.user[[i]]$MANUAL$User <- "user"
}


# # make sure you have the same wd as on server
# if (version$os != "linux-gnu"){ 

#   setwd(system.file("app", package = "seasonalInspect"))
# } 


wd <- system.file("app", package = "x13story")

  # SPECS <- read.csv("ressources/speclist/table_web.csv", header = TRUE, stringsAsFactors = FALSE)
  # save(SPECS, file = "~/seasweb/specs.rdata")

load(file = file.path(wd, "specs.rdata"))
sapply(list.files(file.path(wd, "functions"), full.names=TRUE), source)






lSeries <- list()
lSeries$MAIN <- c("Original and Adjusted Series" = "main", "Original and Adjusted Series (%)" = "mainpc")

SPECS2 <- SPECS[SPECS$seats, ]
SPECS2$long <- gsub("seats.", "", SPECS2$long)
SPECS2$spec <- gsub("seats", "seats/x11", SPECS2$spec)

sp <- unique(SPECS2$spec)
for (spi in sp){
  argi <- SPECS2[SPECS2$spec == spi, ]$long
  names(argi) <- SPECS2[SPECS2$spec == spi, ]$descr
  lSeries[[toupper(spi)]] <- argi
}



# add rarely used views
data(specs)

# views already there
pres <- c(unname(unlist(lSeries)), "forecast.backcasts")

sp <- c(sp, "rarely used views")
ruv <- SPECS[SPECS$is.save & SPECS$is.series, ]$long

ruv <- ruv[!ruv %in% pres]
class(ruv)
names(ruv) <- ruv
lSeries$`RARELY USED VIEWS` <- ruv


# so we don't do this calculation for each session

# loading the already evaluated init.model saves 1/4 sec.

# init.model <- seas(AirPassengers)
# save(init.model, file = "init.model.rdata")

# load("init.model.rdata")
init.model <- seas(AirPassengers)
init.model <- upd_seas(init.model, series = "main")


# --- storytelling -------------------------------------------------------------


# ff <- list.files("stories", pattern = "md$", full.names = TRUE)

# lStory <- lapply(ff, render_story)

# lStory <- Map(function(e1, e2){names(e1) <- paste0(e2, ".", seq(e1)); e1}, 
#               e1 = lStory, e2 = seq(lStory))


# # extract story titles
# cStoryTitle <- sapply(lStory, function(e) attr(e, "yaml")["title"])
# names(cStoryTitle) <- cStoryTitle
# cStoryTitle[] <- paste0(seq(cStoryTitle), ".1")

# # flatten the list
# lStory <- do.call("c", lStory)


# so we can run it as 'app', too, outside of inspect
if (!exists("story.rendered")){
  story.file <- system.file(package = "x13story", "stories", "x11.Rmd")
  story.rendered <- x13story::parse_x13story(file = story.file)
}













