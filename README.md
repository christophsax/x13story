Interactive Stories on Seasonal Adjustment with X-13ARIMA-SEATS
---------------------------------------------------------------

[![Build Status](https://travis-ci.org/christophsax/x13story.svg?branch=master)](https://travis-ci.org/christophsax/x13story)

**this is very, very preliminary!**

Authors: [James Livsey](http://www.census.gov/research/researchers/profile.php?cv_profile=3922&cv_submenu=title) and [Christoph Sax](http://www.christophsax.com)

To get **a more detailed description** of the package and its use, have a look at the 
[**vignette**](https://github.com/christophsax/x13story/raw/master/vignettes/x13story.pdf).

An R package containing:

- Example X-13 stories: R markdown documents that describe various aspects of
  seasonal adjustment.

- Infrastructure to generate PDFs from X-13 stories.

- Infrastructure to interactively run X-13 stories on a website.


X-13 stories are kept in [`inst/stories`](https://github.com/christophsax/x13story/tree/master/inst/stories) and are rendered automatically both as interactive views and as PDFs. 

To add or modify, update the files on a branch where the build process is tested
and do a pull request. Only when on `master`, the successful builds are copied
to:

- Interactive views are shown on this [test site](http://www.seasonal.website/x13story) 
  (graduate cap in the menu).

- PDFs can be downloaded from [here](http://www.christophsax.com/x13story).

To install this package from Github:

    if (!require(devtools)) install.packages("devtools")
    devtools::install_github("christophsax/x13story")

In newer versions of RStudio, you can select the template from the menu:

    New Document Symbol > R Markdown ... > From Template > X-13 Handout
    
If you are using R from another environment, use:

    rmarkdown::draft("MyArticle.Rmd", template = "x13story", package = "x13story")

To **generate a PDF document**, you can use the <kbd>knitr</kbd> button in RStudio, or run *knitr* from your environment.

To **generate an interactive story**, use the `viewer` function of *x13story*:

    viewer("https://raw.githubusercontent.com/christophsax/x13story/master/inst/stories/x11.Rmd")


### Roadmap

- [X] Offline version of [www.seasonal.website](www.seasonal.website)
   - [X] Substitute Nifty with Open Source [LTEAdmin](https://almsaeedstudio.com/preview)
   - [X] Substitute Frutiger font with Open Sans
   - [X] Local website version that is part of the package
   - [X] Render function that takes an `.Rmd` file as an argument and show it as interactive lesson
- [ ] Add more stories
- [ ] Structure story menu into topics
    
