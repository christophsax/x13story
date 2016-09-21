library(shiny)
library(shinydashboard)
library(DT)
library(dygraphs)


dashboardPage(

  dashboardHeader(
    title = "seasonal: R-interface to X-13ARIMA-SEATS", titleWidth = 420
  ),
  dashboardSidebar(
    disable = TRUE
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "docs.css")#,
      # tags$script(src = "js/shinyIDCallback.js")
    ),

    fluidRow(
      column(4,
        uiOutput("oStory"),
        box(title = "Options", uiOutput("oFOpts"), width = NULL, collapsible = TRUE),

        tabBox(
          # Title can include an icon
          title = actionButton("iEvalCall", "Run Call"),
          id = "iActiveTerminal",
          tabPanel("R",
            uiOutput("oTerminal")
          ),
          tabPanel("X-13", 
            uiOutput("oTerminalX13")
          ), 
          width = NULL
        )
      ),

      column(8,
        # box(uiOutput("oViewSelect"), width = NULL),  

        box(title = uiOutput("oViewSelect"), dygraphOutput("oMainPlot"), footer = uiOutput("oLabel"), width = NULL),
        box(title = "Summary", 
          fluidRow(
            column(4, uiOutput("oSummaryCoefs")),
            column(4, uiOutput("oSummaryStats")),
            column(4, uiOutput("oSummaryTests"))
          ), width = NULL
        )
      )

    )
  ),


)