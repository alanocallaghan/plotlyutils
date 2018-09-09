## ---- echo=FALSE---------------------------------------------------------
suppressPackageStartupMessages(library("plotlyutils"))

## ------------------------------------------------------------------------

library(datasauRus)
library(plotly)
library(magrittr)

datasaurus_dozen$dataset %<>% factor(
    levels = c(
        "away", 
        "high_lines", 
        "wide_lines",
        "h_lines", 
        "v_lines",
        "slant_down", 
        "slant_up", 
        "dots",
        "bullseye",
        "circle",
        "star", 
        "x_shape",
        "dino")
    )

ax <- list(
  title = "",
  zeroline = FALSE,
  showline = FALSE,
  showticklabels = FALSE,
  showgrid = FALSE
)

plot_ly(datasaurus_dozen, 
    x = ~x, 
    y = ~y, 
    frame = ~dataset, 
    mode = "markers",
    type = "scatter",
    showlegend = FALSE) %>%
    layout(xaxis = ax, yaxis = ax) %>%
    animation_opts(frame = 5000, transition = 500)


