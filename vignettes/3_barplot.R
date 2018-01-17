## ---- echo=FALSE---------------------------------------------------------
suppressPackageStartupMessages(library("plotlytalk"))

## ------------------------------------------------------------------------
g <- ggplot(mpg, aes(class))
g <- g + geom_bar(aes(fill=drv))
print(g)

ggplotly(g)

