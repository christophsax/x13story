Interactive Stories on Seasonal Adjustment with X-13ARIMA-SEATS
---------------------------------------------------------------

**this is a very preliminary**

Authors: James Livsey and Christoph Sax

An R package containing:

- X-13 stories: R markdown documents to describing various aspects of seasonal 
  adjustment.

- Infrastructure to generate pdfs out of X-13 stories

- Infrastructure to interatively run X-13 stories


Update stories in `inst/stories` to trigger automatic rendering on Travis. After
successful rendering, they should be shown on the website.


To install this package from Github:

    if (!require(devtools)) install.packages("devtools")
    devtools::install_github("christophsax/x13story")


To create a fresh template in an arbitrary R environment, use:

    library(x13story)
    draft("MyArticle.Rmd", template = "x13_handout", package = "x13story")


In the latest version of RStudio, you can select the template from the menu.

    New Dokument Symbol > R Markdown ... > From Template > X-13 Handout



