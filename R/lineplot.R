## https://stackoverflow.com/questions/48096600/can-i-make-a-line-plot-with-a-dropdown-menu-in-r-without-using-shiny-or-plotly/
#' A line plot with selectable y variables
#' @param df A data.frame
#' @param x The column name (as a string) of the x variable
#' @param yvars The column names (as strings) to be used as y variables
#' @return A plotly object
#' @examples
#' set.seed(42)
#' df <- lapply(1:26, function(x) rnorm(50)) %>%
#'     as.data.frame()
#' colnames(df) <- letters
#' df[["seq"]] <- 1:50
#' df %>% dropdown_lineplot(x="seq", yvars = letters)
#' @importFrom plotly add_lines
#' @export
dropdown_lineplot <- function(df, x, yvars) {
  ## Add trace directly here, since plotly adds a blank trace otherwise
  p <- plot_ly(
    type = "scatter",
    mode = "lines",
    x = ~ df[[x]],
    y = ~ df[[yvars[[1]]]],
    name = yvars[[1]]
  )
  ## Add arbitrary number of traces
  ## Ignore first col as it has already been added
  for (col in yvars[-1]) {
    p <- p %>% add_lines(
      x = ~ df[[x]],
      y = df[[col]],
      name = col,
      visible = FALSE
    )
  }

  p %>%
    layout(
      title = "Dropdown line plot",
      xaxis = list(title = "x"),
      yaxis = list(title = "y"),
      updatemenus = list(
        list(
          y = 0.7,
          ## Add all buttons at once
          buttons = lapply(yvars, function(col) {
            list(
              method = "restyle",
              args = list("visible", yvars == col),
              label = col
            )
          })
        )
      )
    )
}
