## ---- echo = FALSE-------------------------------------------------------
suppressPackageStartupMessages(library("SummarizedExperiment"))
suppressPackageStartupMessages(library("plotlytalk"))

## ---- fig.caption = "Correlation heatmap"--------------------------------
## https://www.sciencedirect.com/science/article/pii/S1673852717301492
df <- colData(GBMdata)[, "subtype_IDH.status", drop = FALSE]
colnames(df) <- "IDH1 status"
gene_signature <- c("ALDOB",
    "ENO1",
    "GALM",
    "GAPDH",
    "HK2",
    "HK3",
    "LDHA",
    "LDHB",
    "PKLR")
raw_mat <- assay(GBMdata)
raw_median_mat <- sweep(raw_mat, 1, rowMedians(raw_mat))
heatmaply_cor(cor(raw_median_mat[gene_signature, ]),
    row_side_colors = df,
    plot_method = "plotly",
    showticklabels = c(FALSE, FALSE))

## ------------------------------------------------------------------------
voom_mat <- voomed_GBM$E
voom_median_mat <- sweep(voom_mat, 1, rowMedians(voom_mat))
max <- max(abs(voom_median_mat[gene_signature, ]))
heatmaply(t(voom_median_mat[gene_signature, ]),
    row_side_colors = df,
    showticklabels = c(TRUE, FALSE),
    limits = c(-max, max),
    plot_method = "plotly",
    col = cool_warm)

