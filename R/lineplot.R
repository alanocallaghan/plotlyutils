## https://stackoverflow.com/questions/48096600/can-i-make-a-line-plot-with-a-dropdown-menu-in-r-without-using-shiny-or-plotly/
#' @export
dropdown_lineplot <- function(df, x) {
    ## Add trace directly here, since plotly adds a blank trace otherwise
    cols <- setdiff(colnames(df), x)
    p <- plot_ly(
        type = "scatter",
        mode = "lines",
        x = ~ df[[x]],
        y = ~ df[[cols[[1]]]],
        name = cols[[1]])
    ## Add arbitrary number of traces
    ## Ignore first col as it has already been added
    for (col in cols[-1]) {
        p <- p %>% add_lines(
          x = ~ df[[x]],
          y = df[[col]],
          name = col,
          visible = FALSE)
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
                buttons = lapply(cols, function(col) {
                  list(method="restyle",
                    args = list("visible", cols == col),
                    label = col)
                })
            )
        )
    )
}
