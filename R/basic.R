#' @export
plotly_boxplot <- function(x,
        box_hoverinfo = FALSE,
        colors = RColorBrewer::brewer.pal(ncol(x), "Paired")
        ) {

    names(colors) <- colnames(x)
    p <- plot_ly(type="box", boxpoints = FALSE)
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
                marker = list(color = colors[[col]]),
                line = list(color=colors[[col]]),
                hoverinfo = if(box_hoverinfo) "x+y+name+text" else "none"
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
                marker = list(color=colors[[col]]),
                showlegend = FALSE,
                opacity = 0.5,
                inherit = FALSE)

    }
    p
}

