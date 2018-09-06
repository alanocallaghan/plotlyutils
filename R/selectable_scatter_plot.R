#' linked_scatterplot
#'
#' A scatterplot with links
#' @param coords
#' @param colours
#' @param title Plot title
#' @examples
#' pcs <- prcomp(mtcars)
#' colours <- mtcars[, c("cyl", "vs", "am", "gear", "carb")]
#' colours[] <- lapply(colours, as.character)
#' selectable_scatter_plot(
#'   pcs,
#'   colours,
#'   "interactive PCA plot"
#' )
#' @importFrom assertthat assert_that
#' @export
selectable_scatter_plot <- function(
    coords,
    colours,
    title = "") {

  createWidget(
    "selectable_scatter_plot",
    x = list(
      coords = coords,
      colours = colours,
      title = title
    ),
    sizingPolicy = sizingPolicy(
      browser.fill = TRUE, 
      viewer.fill = TRUE),
    package = "plotlytalk"
  )
}
