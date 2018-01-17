#' linked_scatterplot
#'
#' A scatterplot with links
#' @param x x values
#' @param y y values
#' @param groups Groups to color the points by.
#' @param text Hovertext for the points
#' @param title Plot title
#' @param xlab,ylab X/Y axis title
#' @param xlim,ylim Range of X/Y axis
#' @param colors Colors to use for the groups
#' @examples
#' linked_scatterplot(
#'  1:10,
#'  1:10,
#'  rep("https://www.google.com", 10),
#'  groups=sample(letters[1:2], 10, replace=TRUE))
#' @importFrom assertthat assert_that
#' @export
linked_scatterplot <- function(x,
        y,
        links,
        groups=rep("1", length(x)),
        text = rep("", length(x)),
        title="",
        xlab="",
        xlim = range(x, na.rm=TRUE) * 1.1,
        ylim = range(y, na.rm=TRUE) * 1.1,
        ylab="",
        colors=RColorBrewer::brewer.pal(length(unique(groups)), "Set2")) {
    assert_that(length(x) == length(y),
        length(links) == length(x),
        length(groups) == length(y),
        length(text) == length(y),
        length(colors) == length(unique(groups)))

    createWidget("linked_scatterplot",
        x = list(x=x,
            xlab=xlab,
            xlim=xlim,
            y=y,
            ylab=ylab,
            ylim=ylim,
            links=links,
            groups=groups,
            colors=colors,
            title=title,
            text=text),
        sizingPolicy = sizingPolicy(browser.fill = TRUE, viewer.fill = TRUE),
        package = "EdinbrPlotly")
}
