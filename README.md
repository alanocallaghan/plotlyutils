-   [plotlyutils](#plotlyutils)
-   [Installation](#installation)
-   [Outline](#outline)
    -   [A boxplot with jittered
        points](#a-boxplot-with-jittered-points)
    -   [A line plot with selectable y
        variable](#a-line-plot-with-selectable-y-variable)
    -   [A density plot of a matrix or
        data.frame](#a-density-plot-of-a-matrix-or-data.frame)
    -   [A scatter plot wherein clicking on a point opens a link in a
        new
        tab](#a-scatter-plot-wherein-clicking-on-a-point-opens-a-link-in-a-new-tab)
    -   [A scatter plot where x/y/colour variables can be selected
        dynamically](#a-scatter-plot-where-xycolour-variables-can-be-selected-dynamically)
-   [Useful links](#useful-links)

[![Build
Status](https://travis-ci.org/Alanocallaghan/plotlyutils.png?branch=master)](https://travis-ci.org/Alanocallaghan/plotlyutils)
[![codecov.io](https://codecov.io/github/Alanocallaghan/plotlyutils/coverage.svg?branch=master)](https://codecov.io/github/Alanocallaghan/plotlyutils?branch=master)

plotlyutils
===========

This package some utility functions and htmlwidgets for
[plotly](https://plot.ly/), and a related talk (see vignettes and the
[package site](https://alanocallaghan.github.io/plotlyutils/) (built
with [pkgdown](https://github.com/r-lib/pkgdown)).

Installation
============

    devtools::install_github("Alanocallaghan/plotlyutils")

Outline
=======

The talk shows many examples of
[ggplotly](https://www.rdocumentation.org/packages/plotly/versions/4.7.1/topics/ggplotly),
some examples of how to plot using plotly, several functions which
create plotly objects using the R API, and two custom htmlwidget written
using JavaScript.

The custom plots are shown below:

A boxplot with jittered points
------------------------------

    plotly_boxplot(iris[, -5])

![](README_files/figure-markdown_strict/unnamed-chunk-3-1.png)

A line plot with selectable y variable
--------------------------------------

    set.seed(42)
    df <- lapply(1:26, function(x) rnorm(50)) %>% 
        as.data.frame()
    colnames(df) <- letters
    df[["seq"]] <- 1:50

    df %>% dropdown_lineplot(x="seq", yvars = letters)

![](README_files/figure-markdown_strict/unnamed-chunk-4-1.png)

A density plot of a matrix or data.frame
----------------------------------------

    plotly_density(
        log2(assay(GBMdata[, 1:10]) + 0.5), 
        palette=colorspace::rainbow_hcl,
        xlab = "log<sub>2</sub>(reads + 0.5)") %>% 
        layout(showlegend = FALSE)

![](README_files/figure-markdown_strict/unnamed-chunk-5-1.png)

A scatter plot wherein clicking on a point opens a link in a new tab
--------------------------------------------------------------------

    set.seed(42)
    tt <- GBMtopTable[sample(seq_len(nrow(GBMtopTable)), 1000), ]
    linked_scatter_plot(
        x = tt[["logFC"]],
        xlab = "log<sub>2</sub>(fold-change)",
        y = -log10(tt[["adj.P.Val"]]),
        ylab = "-log<sub>10</sub>(FDR-adjusted p-value)",
        xlim = c(-max(abs(tt[["logFC"]])), max(abs(tt[["logFC"]]))) * 1.1,
        text = tt[["Text"]],
        links = tt[["Links"]],
        groups = tt[["Group"]],
        title = "Glioblastoma - IDH1 mutant vs wt",
        colours = c("#0000ff", "#000000", "#ff0000"))

![](README_files/figure-markdown_strict/unnamed-chunk-6-1.png)

A scatter plot where x/y/colour variables can be selected dynamically
---------------------------------------------------------------------

    mat <- mtcars
    colours <- mtcars
    ## Make some things character for demonstration
    colours[, c("cyl", "gear")] <- lapply(colours[, c("cyl", "gear")], as.character)

    selectable_scatter_plot(
        mat,
        colours
    )

![](README_files/figure-markdown_strict/unnamed-chunk-7-1.png)

Useful links
============

-   [The pkgdown site for this
    package](https://alanocallaghan.github.io/plotlyutils/)
-   [github repository](https://github.com/Alanocallaghan/plotlyutils/)
-   [plotly
    (CRAN)](https://cran.r-project.org/web/packages/plotly/index.html)
-   [plotly for R (book)](https://plotly-book.cpsievert.me)
-   [plotly (R reference)](https://plot.ly/r/reference/)
-   [plotly (JavaScript
    reference)](https://plot.ly/javascript/reference/)
-   [plotly (github)](https://github.com/ropensci/plotly/)
-   [Carson Sievert's github (plotly R package
    maintainer)](https://github.com/cpsievert/)
-   [heatmaply (CRAN)](https://github.com/talgalili/heatmaply)
-   [heatmaply
    (github)](https://cran.r-project.org/web/packages/plotly/index.html)
-   [heatmaply
    (publication)](https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btx657/4562328)
-   [iheatmapr
    (CRAN)](https://cran.r-project.org/web/packages/iheatmapr/index.html)
-   [iheatmapr (github)](https://github.com/ropensci/iheatmapr)
