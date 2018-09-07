#' Density plot using plotly
#'
#' Creates a density plot of all columns of a matrix or data.frame like
#' structure.
#'
#' @return A plotly htmlwidget
#'
#' @examples
#' plotly_density(iris[, -5], title="Density plot of Iris dataset",
#'      xlab = "Value")
#'
#' plotly_density(voomed_GBM$E, title="Density plot of voomed GBM data",
#'      xlab = "Expression level")
#' @importFrom magrittr %>%
#' @export
plotly_density <- function(
    mat, 
    title = "", 
    xlab = "",
    palette = viridis) {

  assert_that(inherits(mat, "matrix"))

  if (is.null(colnames(mat))) colnames(mat) <- seq_len(ncol(mat))
  densities <- lapply(seq_len(ncol(mat)), function(i) {
    stats::density(mat[, i])
  })
  coords <- lapply(
    seq_len(ncol(mat)),
    function(i) {
      data.frame(
        Sample = colnames(mat)[i],
        x = densities[[i]][["x"]],
        y = densities[[i]][["y"]]
      )
    }
  )

  plot_ly(
    do.call(rbind, coords),
    x = ~x,
    y = ~y,
    color = ~Sample,
    text = ~paste0(
      "Sample: ", Sample, "<br>",
      "x: ", x, "<br>",
      "Density: ", y
    ),
    hoverinfo = "text",
    colors = palette(ncol(mat)),
    type = "scatter",
    mode = "lines"
  ) %>% layout(
    title = title,
    hovermode = "closest",
    xaxis = list(title = xlab),
    yaxis = list(title = "Density")
  )
}
