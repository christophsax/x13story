
 #' @export
xplot <- function(x, ylab = NULL, family = "Palatino", legend.pos = "bottomright", ...){
  nm <- deparse(substitute(x))

  op <- par(family = family)
  on.exit(par(op))

  n <- NCOL(x)
  if (n == 1){
    return({
      if (is.null(ylab)) ylab <- nm
      plot(x, xlab="" , ylab = ylab, bty = "n", axes = FALSE, family = family, ...)
      axis(1, tick = FALSE, family = family)
      axis(2, tick = FALSE, family = family)
      grid()
    })
  }
  cn <- colnames(x) 
  if (is.null(cn)){
    cn <- as.character(1:n)
  }

  cols <- rainbow(n)
  plot(x, xlab="", ylab="", bty = "n", axes = FALSE, family = family, lty = seq(n), plot.type = "single", ...)
  axis(1, tick = FALSE, family = family)
  axis(2, tick = FALSE, family = family)
  grid()
  if (legend.pos != "none"){
    legend(legend.pos, lty = seq(n), legend = cn, bty = "n")
  }
}




# pdf("~/test.pdf", width = 10, height = 6.5)
# op <- par(family = "Palatino")
# xplot(cbind(mdeaths, fdeaths), legend.pos = "none", ylim = c(0, 2700))
# text(1978.35, 230, "Female", pos = 4)
# text(1974.88, 2300, "Male", pos = 4)
# par(op)
# dev.off()

# browseURL("/Users/christoph/test.pdf")