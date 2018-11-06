#' selectable_scatter_plot
#'
#' A scatterplot with dropdown menus to select the x/y variables and
#' the variable used to colour the points
#' @param coords data.frame or matrix of point co-ordinates
#' @param colours data,frame of variables used to colour points
#' @param title Plot title
#' @examples
#' pcs <- prcomp(mtcars)
#' colours <- mtcars[, c("cyl", "vs", "am", "gear", "carb")]
#' colours[] <- lapply(colours, as.character)
#' selectable_scatter_plot(
#'   pcs$x,
#'   colours,
#'   "Interactive PCA plot"
#' )
#' @importFrom assertthat assert_that
#' @export
selectable_scatter_plot <- function(
    coords,
    colours,
    title = "") {

  assert_that(
    inherits(coords, "matrix") || inherits(coords, "data.frame"),
    inherits(colours, "data.frame"),
    nrow(coords) == nrow(colours)
  )
  coords <- as.data.frame(coords)
  colours <- as.data.frame(colours)

  createWidget(
    "selectable_scatter_plot",
    x = list(
      coords = coords,
      colours = colours,
      names = rownames(coords),
      title = title
    ),
    sizingPolicy = sizingPolicy(
      browser.fill = TRUE, 
      viewer.fill = TRUE),
    package = "plotlyutils"
  )
}
