## ---- echo=FALSE---------------------------------------------------------
suppressPackageStartupMessages(library("plotlytalk"))

## ------------------------------------------------------------------------
g <- ggplot(mpg, aes(class, hwy))
g <- g + geom_boxplot()
print(g)
ggplotly(g)

## ------------------------------------------------------------------------
plot_ly(mpg, x = ~class, y = ~hwy, type = "box")

## ------------------------------------------------------------------------
print(plotly_boxplot)

plotly_boxplot(iris[, -5])

