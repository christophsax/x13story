

# file = "/Users/christoph/git/x13story/inst/example/Untitled.Rmd"


# parse_x13lesson(file)

#' @export
parse_x13lesson <- function(file){

  # run R chunks im Rmd file and save snapshots in object.
  tempR <- tempfile(fileext = ".R")
  library(knitr)
  purl(file, output=tempR)

  # we don't want graphic output, so sending it to the pdf device is a workaround
  op <- options(x13view.mode = "html", device = "pdf")  
  on.exit(options(op))


  # capture.output is only to mute 'source'. 'cat' statements aren't suppressed by
  # echo = FLASE
  # a <- capture.output(

  source(tempR, echo = FALSE, local = TRUE)

  # a global object we get from source, now rescue from the danger zone
  l.x13view <- gX13view
  rm("gX13view", envir = globalenv())
  # so we have the views. Now we need the same amount of bodys.

  # to check if everything works as expected
  expected.no.x13view <- length(l.x13view)

  # rmarkdown:::read_lines_utf8   
  lines <- readLines(file)
  yaml <- rmarkdown:::parse_yaml_front_matter(lines)


  lno.ticks <- grep("```", lines)
  lno.ticks.r <- grep("```\\{r", lines)
  lno.ticks.r.close <- lno.ticks[which(lno.ticks %in% lno.ticks.r) + 1]


  # line numbers with r code
  lno.r <- unlist(Map(function(e1, e2) e1:e2, e1 = lno.ticks.r, e2 = lno.ticks.r.close))

  # line numbers with x13view() (in R chunks)
  lno.x13view <- lno.r[grep("^ ?x13view\\(", lines[lno.r])]

  if (length(lno.x13view) != expected.no.x13view){
    stop("Number of x13view expected: ", expected.no.x13view, ". Found: ", length(lno.x13view))
  }


  # closing ticks of the chunk that contains x13view
  lno.x13view.close <- vapply(lno.x13view, 
    function(e) min(lno.ticks.r.close[e < lno.ticks.r.close]), 0)

  # blank out r chunks 
  lines0 <- lines
  lines0[lno.r] <- ""

  # start and lno of the x13view body 
  lno.start <- lno.x13view.close + 1
  lno.end <- c((lno.start - 1)[-1], length(lines0))

  # extract x13view body
  l.x13view.body <- Map(function(e1, e2) lines0[e1:e2], e1 = lno.start, e2 = lno.end)

  # add body to x13view list
  l.x13view <- Map(function(e1, e2) {e1$body <- e2; e1}, e1 = l.x13view, e2 = l.x13view.body)


  # an x13view object
  x <- l.x13view[[1]]

  l.x13view <- Map(function(e1, e2) {e1$body <- e2; e1}, e1 = l.x13view, e2 = l.x13view.body)

  body_to_html <- function(x){
    x$body.html <- markdown::renderMarkdown(file = NULL, text = x$body)
    x$body <- NULL  # probably not needed anymore
    x
  }

  l.x13view <- lapply(l.x13view, body_to_html)

  attr(l.x13view, "yaml") <- yaml
  class(l.x13view) <- "x13lesson"
  l.x13view

}





