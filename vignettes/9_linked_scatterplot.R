## ---- echo=FALSE---------------------------------------------------------
suppressPackageStartupMessages(library("plotlytalk"))

## ---- eval=FALSE, echo=FALSE---------------------------------------------
#  head(GBMtopTable)
#  GBMtopTable$pval <- -log10(GBMtopTable$adj.P.Val)

## ------------------------------------------------------------------------
set.seed(42)
tt <- GBMtopTable[sample(seq_len(nrow(GBMtopTable)), 1000), ]
title <- "Glioblastoma - IDH1 mutant vs wt"
xtitle <- "log<sub>2</sub>(fold-change)"
ytitle <- "-log<sub>10</sub>(FDR-adjusted p-value)"
colours <- c("#0000ff", "#000000", "#ff0000")

plot_ly(tt, 
    x = ~logFC, 
    y = ~-log10(P.Value),
    color = ~ Group,  
    text = ~ Symbol,
    hoverinfo = "x+y+text",
    type = "scatter", 
    mode = "markers") %>%
    layout(title = "Glioblastoma - IDH1 mutant vs wt",
        xaxis = list(title = xtitle),
        yaxis = list(title = ytitle))

