#' selectable_histogram
#'
#' A scatterplot with dropdown menus to select the x/y variables and
#' the variable used to colour the points
#' @param coords data.frame or matrix of variables 
#'   (each column will be a separate histogram).
#' @param title Plot title
#' @param histnorm See https://plot.ly/javascript/reference/#histogram-histnorm
#' @examples
#' df <- lapply(1:10, function(...) rnorm(1000))
#' df <- as.data.frame(df)
#' colnames(df) <- paste("Histogram", letters[1:10])
#' selectable_histogram(df, "Interactive histogram")
#' 
#' @importFrom assertthat assert_that
#' @export
selectable_histogram <- function(
    coords,
    title = "",
    histnorm = c("probability density", "", "percent", "probability", "density")
  ) {

  histnorm <- match.arg(histnorm)
  assert_that(
    inherits(coords, "matrix") || inherits(coords, "data.frame")
  )
  coords <- as.data.frame(coords)


  createWidget(
    "selectable_histogram",
    x = list(
      coords = coords,
      title = title,
      histnorm = histnorm
    ),
    sizingPolicy = sizingPolicy(
      browser.fill = TRUE, 
      viewer.fill = TRUE),
    package = "plotlyutils"
  )
}
