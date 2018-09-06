#' linked_scatter_plot
#'
#' A scatterplot with links
#' @param x x values
#' @param y y values
#' @param groups Groups to color the points by.
#' @param text Hovertext for the points
#' @param title Plot title
#' @param xlab,ylab X/Y axis title
#' @param xlim,ylim Range of X/Y axis
#' @param colours Colours to use for the groups
#' @examples
#' linked_scatter_plot(
#'  1:10,
#'  1:10,
#'  rep("https://www.google.com", 10),
#'  groups = sample(letters[1:2], 10, replace=TRUE))
#' @importFrom assertthat assert_that
#' @export
linked_scatter_plot <- function(
    x,
    y,
    links,
    groups = rep("1", length(x)),
    text = rep("", length(x)),
    title = "",
    xlab = "",
    xlim = range(x, na.rm = TRUE) * 1.1,
    ylim = range(y, na.rm = TRUE) * 1.1,
    ylab = "",
    colours = NULL) {

  if (is.null(colours)) {
    colours <- suppressWarnings(RColorBrewer::brewer.pal(length(unique(groups)), "Set2"))[seq_len(length(unique(groups)))]
  }
  
  assert_that(
    length(x) == length(y),
    length(links) == length(x),
    length(groups) == length(y),
    length(text) == length(y),
    length(colours) == length(unique(groups))
  )

  createWidget(
    "linked_scatter_plot",
    x = list(
      x = x,
      xlab = xlab,
      xlim = xlim,
      y = y,
      ylab = ylab,
      ylim = ylim,
      links = links,
      groups = groups,
      colours = colours,
      title = title,
      text = text
    ),
    sizingPolicy = sizingPolicy(browser.fill = TRUE, viewer.fill = TRUE),
    package = "plotlytalk"
  )
}
