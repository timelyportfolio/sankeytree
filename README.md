sankeytree
==========

> Sankey Diagrams as Collapsible Trees

[![Linux Build
Status](https://travis-ci.org//sankeytree.svg?branch=master)](https://travis-ci.org//sankeytree)
[![](http://www.r-pkg.org/badges/version/sankeytree)](http://www.r-pkg.org/pkg/sankeytree)
[![CRAN RStudio mirror
downloads](http://cranlogs.r-pkg.org/badges/sankeytree)](http://www.r-pkg.org/pkg/sankeytree)

Combining Sankey diagrams with collapsible trees and adding some new
interactivity might help us analyze, instruct, and decide.

Installation
------------

    devtools::install_github("timelyportfolio/sankeytree")

Usage
-----

    library(rpart)
    library(partykit)
    library(pipeR)
    library(sankeytreeR)

    #set up a little rpart as an example
    rp <- rpart(
      hp ~ cyl + disp + mpg + drat + wt + qsec + vs + am + gear + carb,
      method = "anova",
      data = mtcars,
      control = rpart.control(minsplit = 4)
    )

    #convert rpart to a hierarchy using convert_rpart in converters.R
    # this was the original conversion
    # and I already see lots of room for improvement
    sankeytreeR:::convert_rpart(rp)

    #see what it looks like
    sankeytree(rp)

    sankeytree(rp, maxLabelLength = 10, nodeHeight = 100)



    # do with kyphosis example
    sankeytree(
      rpart(Kyphosis ~ Age + Number + Start, data = kyphosis),
      maxLabelLength = 10,
      nodeHeight = 200
    )

License
-------

MIT + file LICENSE © [Kenton Russell](https://github.com/)
