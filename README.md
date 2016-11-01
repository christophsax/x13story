Simplified Discussions on Seasonal Adjustment
---------------------------------------------

[![Build Status](https://travis-ci.org/christophsax/x13story.svg?branch=master)](https://travis-ci.org/christophsax/x13story)

An R package providing infrastructure for writing **X-13 stories**, essentially
[R Markdown](http://rmarkdown.rstudio.com) documents that describe various 
aspects of seasonal adjustment with 
[X-13ARIMA-SEATS](https://www.census.gov/srd/www/x13as/).

The package allows you to render an *X-13 story* 
([example](https://raw.githubusercontent.com/christophsax/x13story/master/inst/stories/x11.Rmd)) 
either as:

- a nicely formated PDF report ([example](http://www.christophsax.com/x13story/x11.pdf))

- or as an online story that can be manipulated interactively ([example](http://www.christophsax.com/x13story/), see below).

![](https://raw.githubusercontent.com/christophsax/x13story/master/out/screenshot.png)

We see both static PDF documents and interactive online stories as part of an
ideal workflow that simplifies discussions on seasonal adjustment. A preliminary
draft of the  
[vignette](https://github.com/christophsax/x13story/raw/master/vignettes/x13story.pdf)  describes this workflow in more detail.


### Installation

As *x13story* is not yet on CRAN, it needs to be installed from GitHub:


    library(devtools)  # if you don't have devtools: install.packages("devtools")

    install_github("christophsax/x13story")


*x13story* relies on the R package 
[seasonal](https://CRAN.R-project.org/package=seasonal) to interface to 
X-13ARIMA-SEATS. If you install *x13story*, seasonal and the X-13ARIMA-SEATS 
binaries (through [x13binary](https://CRAN.R-project.org/package=x13binary)) are 
automatically installed.

### Authoring Stories

In newer versions of [RStudio](https://www.rstudio.com/products/RStudio/), you 
can select the template from the menu:

    New Document Symbol > R Markdown ... > From Template > X-13 Handout
    
If you are using R from another environment, use:

    rmarkdown::draft("MyArticle.Rmd", template = "x13story", package = "x13story")

To generate a **PDF document**, you can use the <kbd>knitr</kbd> button in
RStudio, or run *knitr* from the console.

To generate an **interactive story**, use the `viewer` function from the
*x13story* package. The function accepts a local or a remote file name, so the
following downloads an X-13 Story from the internet and interactively displays
it in your browser:

    viewer("https://raw.githubusercontent.com/christophsax/x13story/master/inst/stories/x11.Rmd")


### Sharing Stories

As we argue in the [vignette](https://github.com/christophsax/x13story/raw/master/vignettes/x13story.pdf), R offers the single easiest workflow of discussing and 
exchanging seasonal adjustment problems. The *x13story* package allows to 
document and publish discussions both as a traditional documentation or as an 
interactive online story.

For personal sharing, the `viewer` function allows you interactively inspect an
X-13 Story anywhere on the web. For example, you can put it to
[GitHubGist](https://gist.github.com) and make the link available to anyone you
want, even without setting up an account.

We intend to collect stories on X-13ARIMA-SEATS in the *x13story* package and
make them interactively available
[online]([example](http://www.christophsax.com/x13story/)). We currently keep
X-13 stories in 
[`inst/stories`](https://github.com/christophsax/x13story/tree/master/inst/stories). 
Stories are rendered automatically both as 
[interactive views](http://www.seasonal.website/x13story) and as [PDFs]((http://www.christophsax.com/x13story).

This is still work in progress. We greatly appreachiate feedback and
contributions of X-13 stories, even when they are still a bit edgy.


### Authors

[James Livsey](http://www.census.gov/research/researchers/profile.php?cv_profile=3922&cv_submenu=title) (United States Census Bureau) and 
[Christoph Sax](http://www.christophsax.com) (University of Basel)


### License

GPL-3

