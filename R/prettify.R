#' Prettier Plots (or Other Stuff, at Some Point)
#'
#' @param expr  An R expression, usually resulting in a plot
#' @param family font family, to be matched with latex font
#' @export
#' @examples
#' \dontrun{
#' library(seasonal)
#' m <- seas(AirPassengers)
#' 
#' prettify(pacf(resid(m), main = ""))
#' prettify(plot(spectrum(diff(resid(m)), method = "ar"), main = ""))
#' prettify(plot(m, main = "", xlab = ""))
#' prettify(monthplot(m, main = "", xlab = ""))
#' prettify(plot(AirPassengers))
#' prettify(plot(density(resid(m)), main = ""))
#' prettify(qqnorm(resid(m), main = ""))
#' }
prettify <- function(expr, family = "Palatino", grid = TRUE, box = FALSE){
  op <- par(family = family)
  on.exit(par(op))

  sexpr <- substitute(expr)

  if (class(sexpr) == "{"){
    exprlist <- as.list(sexpr)[-1]
  } else {
    exprlist <- list(sexpr)
  }

  if (!box){
    is.plot <- vapply(exprlist, function(e) as.character(e[[1]]) %in% c("spectrum", "acf", "pacf", "plot", "qqnorm"), TRUE)
    exprlist[is.plot] <- lapply(exprlist[is.plot], update_call, bty = "l")

    is.monthplot <- vapply(exprlist, function(e) as.character(e[[1]]) == "monthplot", TRUE)
    exprlist[is.monthplot] <- lapply(exprlist[is.monthplot], update_call, box = FALSE)


    lapply(exprlist, eval)
  }

  if (grid){
    grid()
  }

}


# helper function, just to update a call
update_call <- function(call, ...){
  extras <- match.call(expand.dots = FALSE)$...
  if (length(extras)) {
      existing <- !is.na(match(names(extras), names(call)))
      for (a in names(extras)[existing]) call[[a]] <- extras[[a]]
      if (any(!existing)) {
          call <- c(as.list(call), extras[!existing])
          call <- as.call(call)
      }
  }
  call
}






# pdf("~/test.pdf", width = 10, height = 6.5)
# op <- par(family = "Palatino")
# xplot(cbind(mdeaths, fdeaths), legend.pos = "none", ylim = c(0, 2700))
# text(1978.35, 230, "Female", pos = 4)
# text(1974.88, 2300, "Male", pos = 4)
# par(op)
# dev.off()

# browseURL("/Users/christoph/test.pdf")