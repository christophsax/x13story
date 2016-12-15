Simplified Discussions on Seasonal Adjustment
---------------------------------------------

[![Build Status](https://travis-ci.org/christophsax/x13story.svg?branch=master)](https://travis-ci.org/christophsax/x13story)

An R package providing infrastructure for writing **X-13 stories**, essentially
[R Markdown](http://rmarkdown.rstudio.com) documents that describe various 
aspects of seasonal adjustment with 
[X-13ARIMA-SEATS](https://www.census.gov/srd/www/x13as/).

The package allows you to render an *X-13 story* 
([example](https://raw.githubusercontent.com/christophsax/x13story/master/inst/stories/x11.Rmd)) as:

- a nicely formated PDF ([example](http://www.christophsax.com/x13story/x11.pdf))

- or as an online story that can be manipulated interactively, see screenshot).

![](https://raw.githubusercontent.com/christophsax/seasonalview/master/out/x13story.png)

We see both static PDFs and interactive online stories as part of an
ideal workflow that simplifies discussions on seasonal adjustment. A preliminary
draft of the [vignette](https://github.com/christophsax/x13story/raw/master/vignettes/x13story.pdf) describes the workflow in more detail.


### Installation

As the package is not yet on CRAN, it needs to be installed from GitHub:

    library(devtools)  # if you don't have devtools: install.packages("devtools")
    install_github("christophsax/x13story")

The *x13story* package depends on the R package 
[seasonal](https://CRAN.R-project.org/package=seasonal), which interfaces to 
X-13ARIMA-SEATS. If you install *x13story*, seasonal and the X-13ARIMA-SEATS 
binaries (through [x13binary](https://CRAN.R-project.org/package=x13binary)) are 
installed automatically.


### Authoring Stories

In newer versions of [RStudio](https://www.rstudio.com/products/RStudio/), you 
can select the R Makrdown template from the menu:

    New Document Symbol > R Markdown ... > From Template > X-13 Handout
    
If you are using R from another environment, use:

    rmarkdown::draft("MyArticle.Rmd", template = "x13story", package = "x13story")

To generate a **PDF**, you can use the <kbd>knitr</kbd> button in RStudio, or 
run *knitr* from the console.

To generate an **interactive story**, use the `view` function from the
[seasonalview](https://CRAN.R-project.org/package=seasonalview) package. The function accepts a local or a remote file path, so the
following downloads an X-13 story from the Internet and interactively displays
it in the browser:

    library(seasonalview)
    view("https://raw.githubusercontent.com/christophsax/x13story/master/inst/stories/x11.Rmd")


### Sharing Stories

As we argue in the 
[vignette](https://github.com/christophsax/x13story/raw/master/vignettes/x13story.pdf), 
R offers the single most convenient way to discuss and exchange seasonal
adjustment problems, as it relies on free open source tools that can be
installed anywhere with a single line of code (see above).

For sharing, the `viewer` function allows you to interactively inspect X-13 
stories anywhere on the web. For example, you can put it to
[GitHub Gist](https://gist.github.com/christophsax/713ba85ec7540541a140cb000189e190) and make the link available to anyone you
want, even without setting up an account.

We intend to collect stories on X-13ARIMA-SEATS in the *x13story* package and
make them interactively available
[online]([example](http://www.christophsax.com/x13story/)). X-13 stories are 
currently kept in 
[`inst/stories`](https://github.com/christophsax/x13story/tree/master/inst/stories). 
Stories are rendered automatically both as 
[interactive views](http://www.seasonal.website/x13story) and as [PDFs](http://www.christophsax.com/x13story).

This is work in progress. We greatly appreciate feedback and
contributions of X-13 stories, even when they are still edgy.


### Authors

[James Livsey](http://www.census.gov/research/researchers/profile.php?cv_profile=3922&cv_submenu=title) (United States Census Bureau) and 
[Christoph Sax](http://www.christophsax.com) (University of Basel)


### License

GPL-3

