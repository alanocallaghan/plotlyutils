## ---- echo = FALSE-------------------------------------------------------
suppressPackageStartupMessages(library("SummarizedExperiment"))
suppressPackageStartupMessages(library("magrittr"))
suppressPackageStartupMessages(library("plotlytalk"))
suppressPackageStartupMessages(library("limma"))

## ---- fig.caption = "Density plot of counts"-----------------------------

plotly_density(
    log2(assay(GBMdata) + 0.5), 
    palette=colorspace::rainbow_hcl,
    xlab = "log<sub>2</sub>(reads + 0.5)") %>% 
    layout(showlegend = FALSE)


## ---- fig.caption = "Voomed density"-------------------------------------
plotly_density(
    voomed_GBM$E, 
    palette=colorspace::rainbow_hcl,
    xlab = "log<sub>2</sub>(normalised counts per million)") %>%
    layout(showlegend = FALSE)



