#' A boxplot with jittered points
#' @param x A data.frame
#' @param box_hoverinfo Show hoverinfo for the boxplot trace? (logical)
#' @param colours The colours to be used for the x-axis groups
#' @return A plotly object
#' @examples
#'  plotly_boxplot(iris[, -5])
#' @importFrom plotly add_trace
#' @export
plotly_boxplot <- function(
        x,
        box_hoverinfo = FALSE,
        colours = RColorBrewer::brewer.pal(ncol(x), "Paired")
    ) {

    names(colours) <- colnames(x)
    p <- plot_ly(type = "box", boxpoints = FALSE)
    set.seed(42)
    col_n <- as.numeric(factor(colnames(x)))
    for (i in seq_len(ncol(x))) {
        col <- colnames(x)[[i]]
        col_num <- col_n[[i]]
        col_num_jitter <- col_num + runif(nrow(x), -0.25, 0.25)
        p <- p %>%
            add_trace(
                x = col_num,
                y = x[, col],
                name = col,
                legendgroup = col,
                marker = list(color = colours[[col]]),
                line = list(color = colours[[col]]),
                hoverinfo = if (box_hoverinfo) "x+y+name+text" else "none"
            ) %>%
            add_trace(
                x = col_num_jitter,
                y = x[, col],
                text = rownames(x),
                name = col,
                legendgroup = col,
                type = "scatter",
                mode = "markers",
                hoverinfo = "x+y+name+text",
                marker = list(color = colours[[col]]),
                showlegend = FALSE,
                opacity = 0.5,
                inherit = FALSE
            )
    }
    p
}
