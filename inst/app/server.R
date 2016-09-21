
HTMLMenuLi <- function(e, id){
  title <- attr(e, "yaml")$title
  subtitle <- attr(e, "yaml")$subtitle
  icon <- attr(e, "yaml")$icon

  if (is.null(icon)) icon <- "fa-road"
  if (is.null(subtitle)) subtitle <- "Add a subtitle to your YAML header"
  if (is.null(title)) title <- "Add a title to your YAML header"

  tags$li(
    tags$a(id = id, href="#", class="media shiny-id-el shiny-force",
      tags$div(class="media-left", 
        tags$span(class="icon-wrap bg-danger",
          tags$i(class="fa fa-calendar fa-lg")
        )
      ),
      tags$div(class="media-body", 
        tags$div(class="text-nowrap", title),
        tags$small(class="text-muted", subtitle)
      )
    )
  )
}                           


HTMLMenu <- function(STORIES){
  # tags$p("dsfsdfsd")
  
  tagList(
    tags$div(id="iSelectorFeedback", class="shiny-id-callback",
      tags$ul(class = "head-list", 
        tagList(
        Map(HTMLMenuLi, e = STORIES, id = names(STORIES))
        )
      )
    ),
    tags$script('
          $(".shiny-id-el").click(function() {
                $(".shiny-id-el").removeClass("active");
                $(this).addClass("active");
              });
      '
    )
  )
}


HTMLx13view <- function(view, title = "My Story"){

  # if first or last, buttons are disabled
  p.button <- tags$button(id = "prev", class = "btn btn-box-tool shiny-id-el", style="", type = "button", "Prev")
  n.button <- tags$button(id = "next", class = "btn btn-box-tool shiny-id-el", type = "button", "Next")
  
  if (view$first) p.button$attribs$disabled <- NA
  if (view$last) n.button$attribs$disabled <- NA



  tagList(
    tags$div(id="iStoryFeedback", class="box",
      tags$div(class = "box-header with-border",
        tags$h3(class = "box-title", title),
        tags$div(class="box-tools pull-right", 
          tags$div(class = "btn-group",
            p.button,
            n.button,
            tags$button(id = "close", class = "btn btn-box-tool shiny-id-el", tags$i(class = "fa fa-times"))
          )#,
          #tags$button(id = "close", class = "btn btn-default shiny-id-el", tags$i(class = "fa fa-times"))
        )
      ),

      tags$div(class = "progress xxs", 
        tags$div(style = paste0("width: ", view$percent, "%;"), class = "progress-bar progress-bar-info")
      ),
      tags$div(class = "box-body story-body", 
        HTML(view$body.html)
      )
    ),



    tags$script('
          $(".shiny-id-el").click(function() {
                // $(".shiny-id-el").removeClass("active");
                var thisid = new Array();
                thisid.push($(this).attr("id"))
                thisid.push(Math.random());
                Shiny.onInputChange("iStoryFeedback", thisid);                
              });
      '
    )
  )
}








library(shiny)
library(dygraphs)
library(xts)
library(seasonal)
library(xtable)

# library(shinyAce)


shinyServer(function(input, output, session) {

# --- reactive model estimation ------------------------------------------------

# if (exists("ser", envir = globalenv())) rm("ser", envir = globalenv())

senv <- environment()  # the session environment 

# probably due to bad programming 
rUplMsg <- reactiveValues(upd = 0)   


rFOpts <- list()

gFiveBestMdl <- structure(list(arima = c("(0 1 0)(0 1 1)", "(1 1 1)(0 1 1)", "(0 1 1)(0 1 1)", "(1 1 0)(0 1 1)", "(0 1 2)(0 1 1)"), bic = c(-4.007, -3.986, -3.979, -3.977, -3.97)), .Names = c("arima", "bic"), row.names = c(NA, -5L), class = "data.frame")



# --- initialisazion -----------------------------------------------------------

rModel <- reactiveValues(seas = init.model, senv = senv)
rError <- reactiveValues(msg = "")   
# rStory <- reactiveValues(story = NULL, view.no = 1)
rStory <- reactiveValues(story = story.rendered, view.no = 1)
rStoryFeedback <- reactiveValues(click = NULL, timestamp = Sys.time())

# assign("gLastUpdateTime", Sys.time(), env = senv)




upd_or_fail <- function(z){
  if (inherits(z, "try-error")){
    rError$msg <- z
  } else {
    rModel$seas <- z
    rError$msg <- ""
  }
}   

# # user loging
# UserSession <- isolate(session$clientData$url_hostname)

# write(paste(Sys.time(), UserSession, "New Session started"), file = paste0(gLdir, format(Sys.time(), "%Y-%m"), ".txt"), append = TRUE)

# qstr <- isolate(session$clientData$url_search)
# ql <- parseQueryString(qstr)
# if (!is.null(ql$call)){
#   txt <- ql$call
#   call <- try(as.call(parse(text = txt)[[1]]))
#   if (inherits(call, "try-error")){
#     z <- call
#   } else {
#     z <- upd_seas(init.model, call = call, senv = senv)
#   }
#   upd_or_fail(z)
# }


# rModelCall  <- reactiveValues(cstr = icstr)
# gCstrLastSuccess <- icstr
# gCstr <- icstr
# gCstrLastSuccessX13 <- "dsfdsdf"

# upd_seas() is to add the $view element

# --- call updater -------------------------------------------------------------

# triggered by view
observe({
  series <- input$iSeries
  # message("hereit is")

  # message("rModel$seas$series.view: ", isolate(rModel$seas$series.view))
  # message("input$iSeries: ", input$iSeries)
  # browser()
  m <- isolate(rModel$seas)
  z <- upd_seas(m, series = series, senv = senv)
  upd_or_fail(z)

  # message("rModel$seas$series.view (after upd): ", isolate(rModel$seas$series.view))

})


# triggered by r or x13 terminal
observe({
 if (input$iEvalCall > 0){
    at <- isolate(input$iActiveTerminal)
    m <- isolate(rModel$seas)

    if (at == "R"){
      txt <- isolate(input$iTerminal)
      call <- try(as.call(parse(text = txt)[[1]]))
      if (inherits(call, "try-error")){
        z <- call
      } else {
        z <- upd_seas(m, call = call, senv = senv)
      }
    } else if (at == "X-13"){
      txt <- isolate(input$iTerminalX13)
      call <- import.spc2(txt = txt)$seas
      if (inherits(call, "try-error")){
        z <- call
      } else {
        call$x <- m$call$x
        call$xreg <- m$call$xreg
        call$xtrans <- m$call$xtrans
        z <- upd_seas(m, call = call, senv = senv)
      }
    } else {
      stop("wrong at value")
    }
    upd_or_fail(z)
  }
})

   
# triggered by selectors
observe({ 
  FOpts <- list()
  FOpts$method <- input$iMethod
  FOpts$transform <- input$iTransform
  FOpts$arima <- input$iArima
  FOpts$outlier <- input$iOutlier
  FOpts$easter <- input$iEaster
  FOpts$td <- input$iTd

  m <- isolate(rModel$seas)

  if (length(FOpts) > 0 && !is.null(m)){
    call <- AddFOpts(m, FOpts)
    z <- upd_seas(m, call = call, senv = senv)
    upd_or_fail(z)
  }
 })


# triggered by new example series 
# (this is badly written, should use own shiny widget here)
# rExmpl <- reactiveValues(x = NULL)
# observe(if (input$iSeriesAirPassengers > 0) rExmpl$x <- as.name("AirPassengers"))
# observe(if (input$iSeriesldeaths > 0) rExmpl$x <- as.name("ldeaths"))
# observe(if (input$iSeriesimp > 0) rExmpl$x <- as.call(parse(text = "window(imp, start = 2000)")[[1]]))
# observe(if (input$iSeriesiip > 0) rExmpl$x <- as.name("iip"))

# observe({ 
#   series.name <- rExmpl$x
#   m <- isolate(rModel$seas)

#   if (!is.null(series.name)){
#     call <- m$call
#     call$x <- series.name
#     z <- upd_seas(m, call = call, senv = senv)
#     upd_or_fail(z)
#   }

#  })


# --- consequences of rModel update --------------------------------------------

# plot
output$oMainPlot <- renderDygraph({

  m <- rModel$seas
  # could even get view from m
  p <- plot_dygraph(m, series = m$series.view)  
  shiny::validate(shiny::need(!is.null(p), 
  "This view is not available for the model. Change view or model."))

  p <- dygraphs::dyOptions(p, gridLineColor = "#E1E5EA", axisLineColor = "#303030")

  p
})


# view selector (depends on adjustment method (x11/seats))
output$oViewSelect <- renderUI({
  m <- rModel$seas
  cc <- lSeries
  if (adj_method(m) == "x11"){
    # cc$FORECAST <- c(cc$FORECAST, "Backcasts" = "forecast.backcasts")
  } 

  # message("selector set to: ", m$series.view)
  a <- selectInput("iSeries", NULL, choices = cc, selected = m$series.view, width = "240px")
  # print(a)
  return(a)

    # return(HTML("dsdddfsdf"))
})


# selectors updated by rModel
output$oFOpts <- renderUI({
  m <- rModel$seas

  fopts <- GetFOpts(m)

  # update if new fivebestmdl are available, otheœrwise, use last fivebestmdl
  if (is.null(m$spc$automdl$print)){
    fbm <- gFiveBestMdl
  } else {
    fbm <- fivebestmdl(m)
    assign("gFiveBestMdl", fbm, envir = senv)
    # gFiveBestMdl <<- fbm
  }

  if (!fopts$arima %in% c("auto", fbm$arima)){
    fopts$arima <- "user"
  }

  lFOpts2 <- lFOpts

  is.user <- sapply(fopts, identical, "user")
  lFOpts2[is.user] <- lFOpts.user[is.user]

  ll <- as.list(fbm$arima)
  names(ll) <- ll

  lFOpts2$arima$MANUAL <- c(ll, lFOpts2$arima$MANUAL)
  list(
    selectInput("iMethod", "Adjustment Method", choices = lFOpts2$method, selected = fopts$method, width = '100%'),
    selectInput("iTransform", "Pre-Transformation", choices = lFOpts2$transform, selected = fopts$transform, width = '100%'),
    selectInput("iArima", "Arima Model", choices = lFOpts2$arima, selected = fopts$arima, width = '100%'),
    selectInput("iOutlier", "Outlier", choices = lFOpts2$outlier, selected = fopts$outlier, width = '100%'),
    selectInput("iEaster", "Holiday", choices = lFOpts2$easter, selected = fopts$easter, width = '100%'),
    selectInput("iTd", "Trading Days", choices = lFOpts2$td, selected = fopts$td, width = '100%')    )
})



# # summary
output$oSummaryCoefs <- renderUI({
  HTML(HTMLCoefs(rModel$seas))
})

output$oSummaryStats <- renderUI({
  HTML(HTMLStats(rModel$seas))
})

output$oSummaryTests <- renderUI({
  HTML(HTMLTests(rModel$seas))
})


# terminal
output$oTerminal <- renderUI({
  m <- rModel$seas
  cstr <- format_seascall(m$call)
  tags$textarea(id="iTerminal", class="form-control", rows=12, cols=60, cstr)
})

# x13terminal
output$oTerminalX13 <- renderUI({
  m <- rModel$seas
  cstr <- seasonal:::deparse_spclist(m$spc)
  tags$textarea(id="iTerminalX13", class="form-control", rows=40, cols=60, cstr)
})





# --- stories ------------------------------------------------------------------



# show dom only if code is present
output$oStory <- shiny::renderUI({
  story <- rStory$story
  view.no <- rStory$view.no
  if (is.null(story)){
    return(NULL)
  } else {
    title <- attr(story, "yaml")$title
    return(withMathJax(HTMLx13view(story[[view.no]], title = title)))
  }
})


# to avoid infinite loop cause by repeated clicks on 'next'
observe({
  iStoryFeedback <- input$iStoryFeedback[1]

# message((Sys.time() - isolate(rStoryFeedback$timestamp)) > 1)
  # wait 0.5 sec to accept new input
  if ((Sys.time() - isolate(rStoryFeedback$timestamp)) > 0.5){
    rStoryFeedback$click <- c(iStoryFeedback, rnorm(1))
    rStoryFeedback$timestamp <- Sys.time()
  }
})


# remove story DOM on close
observe({
  sfb <- rStoryFeedback$click[1]

  if (!is.null(sfb)){
    if (sfb == "close"){
      rStory$story <- NULL
      rStory$view.no <- 1
    }
  }
})


# update rStory by iSelectorFeedback
observe({
  sf <- input$iSelectorFeedback[1]
  if (!is.null(sf)){
    if (!sf %in% names(STORIES)){
      stop("ID not in names(STORY): ", sf)
    }
    rStory$story <- STORIES[[sf]]
    rStory$view.no <- 1
  }
})

# update rStory by Next and Prev
observe({
  sfb <- rStoryFeedback$click[1]


  p <- isolate(rStory$view.no)
  pp <- length(isolate(rStory$story))

  if (!is.null(sfb)){
    if (sfb == "next"){
      p <- min(p + 1, pp)
    } else if (sfb == "prev"){
      p <- max(1, p - 1)
    } else {
      return(NULL)
    }
    
    rStory$view.no <- p

  }
})


# update rModel by rStory
observe({
  # message("STORY UPD")
  story <- rStory$story
  view.no <- rStory$view.no

  if (is.null(story)){
    return(NULL)
  }

  # message(view.no)
  view <- story[[view.no]]

  # message(m$series.view)
  m <- view$m

  # message("view set by story to: ", m$series.view)


  # m <- isolate(rModel$seas)
  z <- upd_seas(m, series = m$series.view, senv = senv)
  rModel$seas <- z

  # message(view$m$series.view)
  # assign data to senv envirnoment
  # if (is.null(view$data)){
  #   dnames <- names(view$data)
  #   for (n in dnames){
  #     assign(n, view$data[[n]], envir = senv)
  #   }
  # }
  # and activate the model
  # browser()
  # rModel$seas <- view$m

  # series <- input$iSeries
  # message(series)
  # m <- isolate(rModel$seas)
  # z <- upd_seas(m, series = series, senv = senv)
  # upd_or_fail(z)
})



# --- errrors -----------------------------------------------------------------

# show error msg on error
observe({
  if (rError$msg == "") return(NULL)
  rawerr <- seasonal:::err_to_html(rError$msg)
  irev <- HTML('<button id="iRevert" type="button" class="btn action-button btn-danger" style = "margin-right: 4px; margin-top: 10px;">Revert</button>')
  error.id <<- showNotification(HTML(rawerr), action = irev, duration = NULL, type = "error")
})

# remove error msg if error is gone
observe({
   if (rError$msg != "") return(NULL)
   if (exists("error.id"))
   removeNotification(error.id)
  })


# click on iRevert does a pseudo-manipulation of the last working model and thus
# triggers an update (but no run of X-13)
observe({ 
  if (!is.null(input$iRevert)){
    if (input$iRevert > 0){
    m <- isolate(rModel$seas)
    z <- upd_seas(m, senv = senv)
    z$msg <- ""  
    upd_or_fail(z)
    }
  }
})



# --- upload and download ------------------------------------------------------

# output$oDownloadCsv <- downloadHandler(
#   filename = "download.csv",
#   content = function(file) {
#       m <- isolate(rModel$seas)
#       view <- m$series.view

#       if (view %in% c("main", "mainpc")){
#         dta <- cbind(original = original(m), final = final(m))
#         if (view == "mainpc") dta <- PC(dta)
#       } else {
#         if (view %in% c("irregular", "seasonal", "trend")){
#           view <- paste0(tolower(isolate(input$iMethod)), ".", view)
#         }
#         dta <- series(m, view, reeval = FALSE)
#       }
#       dta <- data.frame(time = paste(floor(time(dta)), cycle(dta), sep = ":"), dta)
#       write(paste(Sys.time(), UserSession, "DOWNLOAD csv"), file = paste0(gLdir, format(Sys.time(), "%Y-%m"), ".txt"), append = TRUE)
#       write.csv(dta, file, row.names = FALSE)
#   }, 
#   contentType = "text/csv")


# output$oDownloadXlsx <- downloadHandler(
#   filename = "download.xlsx",
#   content = function(file) {
#       m <- isolate(rModel$seas)
#       view <- m$series.view

#       if (view %in% c("main", "mainpc")){
#         dta <- cbind(original = original(m), final = final(m))
#         if (view == "mainpc") dta <- PC(dta)
#       } else {
#         if (view %in% c("irregular", "seasonal", "trend")){
#           view <- paste0(tolower(isolate(input$iMethod)), ".", view)
#         }
#         dta <- series(m, view, reeval = FALSE)
#       }
#       dta <- data.frame(time = paste(floor(time(dta)), cycle(dta), sep = ":"), dta)
#       write(paste(Sys.time(), UserSession, "DOWNLOAD xlsx"), file = paste0(gLdir, format(Sys.time(), "%Y-%m"), ".txt"), append = TRUE)
#       require(openxlsx)
#       write.xlsx(dta, file)
#       # file.rename(paste0(file, ".xlsx"), file)
#   }, 
#   contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")



# observe({
#   upl <- input$iFile
#   m <- isolate(rModel$seas)

#   if (!is.null(upl)){

#     uplMsg <- function(x, type = "danger"){

#       assign("gUplMsgText", x, envir = senv)
#       assign("gUplMsgType", type, envir = senv)

#       # gUplMsgText <<- x
#       # gUplMsgType <<- type
#       rUplMsg$upd <- isolate(rUplMsg$upd) + 1
#     }

#     if (upl$size == 0){
#       uplMsg("Error while trying to upload data file. Uploaded file is of size 0.")
#     }
#     type <- tools::file_ext(upl$name)

#     if (!type %in% c("xlsx", "csv")){
#       uplMsg("Error while trying to upload data file. File type must be either xlsx or csv.")
#       return(NULL)
#     } 

#     ser <- try(ReadAnything(file.path(upl$datapath), type))

#     if (inherits(ser, "try-error")){
#        uplMsg("Error while trying to read time series. The file should have the time in the first, the data in the second column. Several time formats are supported, including Excel time formats. If you need an example file, download one of the demo series; the file is also uploadable.")

#       write(paste(Sys.time(), UserSession, "UPLOAD failed"), file = paste0(gLdir, format(Sys.time(), "%Y-%m"), ".txt"), append = TRUE)
#     } else {

#       uplMsg("Upload has been successful. Time dimension has been successfully recognized.", "success")

#       write(paste(Sys.time(), UserSession, "UPLOAD successful"), file = paste0(gLdir, format(Sys.time(), "%Y-%m"), ".txt"), append = TRUE)
      
#       call <- m$call
#       call$x <- as.name("ser")
    
#       assign("ser", ser, envir = senv)

#       # also update if the call look the same; data has changed.
#       z <- upd_seas(m, call, force = TRUE, senv = senv)

#       upd_or_fail(z)

#     }
#   }
# })






})