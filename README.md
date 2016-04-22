Interactive Stories on Seasonal Adjustment with X-13ARIMA-SEATS
---------------------------------------------------------------

[![Build Status](https://travis-ci.org/christophsax/x13story.svg?branch=master)](https://travis-ci.org/christophsax/x13story)

**this is a very preliminary**

Authors: James Livsey and Christoph Sax

An R package containing:

- X-13 stories: R markdown documents that describe various aspects of seasonal 
  adjustment.

- Infrastructure to generate PDFs from X-13 stories.

- Infrastructure to interatively run X-13 stories.


Update stories in [`inst/stories`](https://github.com/christophsax/x13story/tree/master/inst/stories) to trigger automated rendering on Travis. After
successful rendering, they should be shown on the website. A test site is located [here](http://52.30.3.168/story3).


To install this package from Github:

    if (!require(devtools)) install.packages("devtools")
    devtools::install_github("christophsax/x13story")


To create a fresh template in an arbitrary R environment, use:

    library(x13story)
    draft("MyArticle.Rmd", template = "x13story", package = "x13story")


In the latest version of RStudio, you can select the template from the menu.

    New Dokument Symbol > R Markdown ... > From Template > X-13 Handout



