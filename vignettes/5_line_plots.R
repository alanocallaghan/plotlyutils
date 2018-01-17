## ---- echo=FALSE---------------------------------------------------------
suppressPackageStartupMessages(library("plotlytalk"))

## ------------------------------------------------------------------------
set.seed(42)
df <- lapply(1:26, function(x) rnorm(50)) %>% 
    as.data.frame()
colnames(df) <- letters
df[["seq"]] <- 1:50

df %>% plot_ly(x = ~seq, y = ~b, type = "scatter", mode = "lines")

