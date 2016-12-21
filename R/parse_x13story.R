
#' Prepare an .Rmd file for use in the interactive tools
#' 
#' @param file path
#' @importFrom rmarkdown draft
#' @importFrom markdown renderMarkdown
#' @importFrom yaml yaml.load
#' @export
parse_x13story <- function(file){
  # file = "/Users/christoph/git/x13story/inst/stories/x11.Rmd"
 
  # use namespace of rmarkdown somewhere, R CMD CHECK complains otherwise
  if (FALSE) rmarkdown::draft() 

  # run R chunks im Rmd file and save snapshots in object.
  tempR <- tempfile(fileext = ".R")
  knitr::purl(file, output=tempR, quiet = TRUE)

  # we don't want graphic output, so sending it to the pdf device is a workaround
  op <- options(x13page.mode = "html", device = "pdf")  
  on.exit(options(op))

  x13page.env <- new.env(parent = emptyenv())

  options(x13page.env = x13page.env)

  assign("l.x13page", NULL, envir = x13page.env)

  source(tempR, echo = FALSE)

  l.x13page <- get("l.x13page", envir = x13page.env)

  # to check if everything works as expected
  expected.no.x13page <- length(l.x13page)

  lines <- readLines(file)
  yaml.lines <- lines[2:(grep("---", lines)[2] - 1)]
  yaml <- yaml::yaml.load(paste(yaml.lines, collapse = "\n"))


  lno.ticks <- grep("```", lines)
  lno.ticks.r <- grep("```\\{r", lines)
  lno.ticks.r.close <- lno.ticks[which(lno.ticks %in% lno.ticks.r) + 1]


  # line numbers with r code
  lno.r <- unlist(Map(function(e1, e2) e1:e2, e1 = lno.ticks.r, e2 = lno.ticks.r.close))

  # line numbers with x13page() (in R chunks)
  lno.x13page <- lno.r[grep("^ ?x13page\\(", lines[lno.r])]

  if (length(lno.x13page) != expected.no.x13page){
    stop("Number of x13page expected: ", expected.no.x13page, ". Found: ", length(lno.x13page))
  }


  # closing ticks of the chunk that contains x13page
  lno.x13page.close <- vapply(lno.x13page, 
    function(e) min(lno.ticks.r.close[e < lno.ticks.r.close]), 0)

  # blank out r chunks 
  lines0 <- lines
  lines0[lno.r] <- ""

  # start and lno of the x13page body 
  lno.start <- lno.x13page.close + 1
  lno.end <- c((lno.start - 1)[-1], length(lines0))

  # extract x13page body
  l.x13page.body <- Map(function(e1, e2) lines0[e1:e2], e1 = lno.start, e2 = lno.end)

  # add body to x13page list
  l.x13page <- Map(function(e1, e2) {e1$body <- e2; e1}, e1 = l.x13page, e2 = l.x13page.body)

  body_to_html <- function(x){
    x$body.html <- markdown::renderMarkdown(file = NULL, text = x$body)
    x$body <- NULL  # probably not needed anymore
    x
  }

  l.x13page <- lapply(l.x13page, body_to_html)

  # add strucural info to view
  pp <- length(l.x13page)

  for (p in seq(l.x13page)){
    l.x13page[[p]]$percent <- 100 * (p / pp)
    l.x13page[[p]]$first <- p == 1
    l.x13page[[p]]$last <- p == pp
  }

  attr(l.x13page, "yaml") <- yaml
  class(l.x13page) <- "x13lesson"

  l.x13page

}





