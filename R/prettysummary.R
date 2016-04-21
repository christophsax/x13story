# #' @export
# xtable_seas_coef <- function (x, digits = max(3, getOption("digits") - 3), 
#                               signif.stars = getOption("show.signif.stars"), ...) {
  


#   # cat("\nCall:\n", paste(deparse(x$call), sep = "\n", collapse = "\n"), "\n",
#   #     sep = "")
  
#   if (is.null(coef(x))) {
#     cat("\nNo Coefficients\n")
#   } else {
#     cat("\nCoefficients:\n")
#     xtable:::xtable.summary.lm(summary(m))
#   }
# }


#' @export
seas_stats <- function (x, digits = max(3, getOption("digits") - 3), 
                              signif.stars = getOption("show.signif.stars"), ...) {

  z <- list()

  if (!is.null(x$spc$seats)){
    z['method'] <- "SEATS adj."
  } else if (!is.null(x$spc$x11)){
    z['method'] <- "X11 adj."
  } else {
    z['method'] <- "No adj."
  }
  

  z['ARIMA'] <- x$model$arima$model
  z['Obs.'] <- formatC(x$lks['nobs'], format = "d")
  z['Transform'] <- transformfunction(x)
  z['nAICc'] <- formatC(x$lks['Aicc'], digits = digits)
  z['BIC'] <- formatC(x$lks['bic'], digits = digits)

  # QS Test
  qsv <- qs(x)[c('qssadj'), ]
  qsstars <- symnum(as.numeric(qsv['p-val']), 
                    corr = FALSE, na = FALSE, legend = FALSE,
                    cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1), 
                    symbols = c("***", "**", "*", ".", " "))
  z['QS'] <- paste0(formatC(as.numeric(qsv['qs']), digits = digits)," ", qsstars)
  
  if (!is.null(resid(x))){
    # Box Ljung Test
    bltest <- Box.test(resid(x), lag = 24, type = "Ljung")
    blstars <- symnum(bltest$p.value, 
                      corr = FALSE, na = FALSE, legend = FALSE,
                      cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1), 
                      symbols = c("***", "**", "*", ".", " "))
    z['Box-Ljung'] <- paste(formatC(bltest$statistic, digits = digits), blstars)
    
    # Normality
    swtest <- shapiro.test(resid(x))
    swstars <- symnum(swtest$p.value, 
                      corr = FALSE, na = FALSE, legend = FALSE,
                      cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1), 
                      symbols = c("***", "**", "*", ".", " "))
    z['Shapiro'] <- paste(formatC(swtest$statistic, digits = digits), swstars)
  
  }

  z

}





#' @export
prettysummary <- function(x, caption = NULL){
  stopifnot(inherits(x, "seas"))

  # pdf.coef = TRUE
  library(xtable)
  options(xtable.comment = FALSE)
  options(xtable.booktabs = TRUE)
  options(xtable.floating = FALSE)

  cat("\\begin{table}")
  cat("\\centering")
  
  # stats string
  tex <- function(texfun){
    function(x) {
      paste0("\\", texfun, "{", x, "}")
    }
  }

  if (is.null(caption)){
    caption = ""
  }

  st <- unlist(seas_stats(m))
  st <- gsub("^ +| +$", "", st)

  ee <- paste0(tex("emph")(names(st)), ": ", st)

  z <- character()
  z[1] <- paste(ee[1:4], collapse = " -- ")
  z[2] <- paste(ee[5:9], collapse = " -- ")
  str <- paste(paste(tex("multicolumn{5}{c}")((z)), "\\\\\n"), collapse = "")


  a <- xtable:::xtable.summary.lm(summary(m), align = c("l", "r", "r", "r", "r"))
  
  attr(a, "align") <- c("p{4cm}", "r", "r", "r", "r")

  addtorow <- list()
  addtorow$pos <- list(0, NROW(a), NROW(a))

  # addtorow$pos <- list(2, 4)

  addtorow$command <- c(" & Estimate & Std. Error & z value & Pr($>$$|$z$|$)  \\\\\n", "\\midrule  \n", str) 


  print(a, add.to.row = addtorow, include.colnames = FALSE)

  cat(tex("caption")(caption))
  cat("\\end{table}")
}




