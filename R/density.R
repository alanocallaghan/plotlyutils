#' @examples 
#' plotly_density(iris[, -5], title="Density plot of Iris dataset",
#'      xlab = "Value")
#' @export
plotly_density <- function(mat, title = "", xlab = "",
        palette = viridis) {
    densities <- lapply(seq_len(ncol(mat)), function(i) {
        stats::density(mat[, i])
    })
    coords <- lapply(seq_len(ncol(mat)),
        function(i) {
            data.frame(
                Sample = colnames(mat)[i], 
                x = densities[[i]][["x"]],
                y = densities[[i]][["y"]]
            )
        }   
    )

    plot_ly(do.call(rbind, coords),
        x = ~x,
        y = ~y,
        color = ~Sample,
        text = ~paste0("Sample: ", Sample, "<br>",
            "x: ", x, "<br>",
            "Density: ", y),
        hoverinfo = "text",
        colors = palette(ncol(mat)),
        type = "scatter",
        mode = "lines") %>% layout(title = title,
            hovermode = "closest", 
            xaxis = list(title = xlab),
            yaxis = list(title = "Density"))

}
