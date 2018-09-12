library("TCGAbiolinks")
library("edgeR")
library("limma")
library("devtools")
library("gdata")
library("SummarizedExperiment")


query <- GDCquery(
  project = "TCGA-GBM",
  data.category = "Transcriptome Profiling",
  data.type = "Gene Expression Quantification",
  workflow.type = "HTSeq - Counts"
)
GDCdownload(query)
data <- GDCprepare(query)



genes <- rowData(data)[[2]]
ind_symb <- !is.na(genes)
data <- data[ind_symb, ]
data <- data[!duplicated2(genes), ]
ind_not_na <- !is.na(colData(data)$subtype_IDH.status)
data <- data[, ind_not_na]
rownames(data) <- rowData(data)[[2]]
GBMdata <- data


dge <- edgeR::DGEList(counts = assay(GBMdata))
dge <- edgeR::calcNormFactors(dge, method = "TMM")


voomed_GBM <- limma::voom(dge)
gene_signature <- c("ALDOB",
    "ENO1",
    "GALM",
    "GAPDH",
    "HK2",
    "HK3",
    "LDHA",
    "LDHB",
    "PKLR")
ind_gene <- which(rownames(GBMdata) %in% gene_signature)
ind <- union(ind_gene, 1:5000)
GBMdata <- GBMdata[ind, ]
use_data(GBMdata, overwrite = TRUE)
full_voomed <- voomed_GBM 
voomed_GBM <- voomed_GBM[ind, ]
use_data(voomed_GBM, overwrite = TRUE)

design <- model.matrix(~ 0 + colData(GBMdata)$subtype_IDH.status)
colnames(design) <- gsub(
  "colData(GBMdata)$subtype_IDH.status", "",
  colnames(design), fixed = TRUE
)

fit <- lmFit(full_voomed, design = design)

contrasts <- makeContrasts("Mutant-WT", levels = design)

fit <- contrasts.fit(fit, contrasts)

ebayes <- eBayes(fit)
GBMtopTable <- topTable(ebayes, number = nrow(ebayes))

GBMtopTable$Symbol <- rownames(GBMtopTable)

GBMtopTable$Links <- paste0(
  "https://www.ncbi.nlm.nih.gov/gene?term=(", GBMtopTable$Symbol,
  "[gene])%20AND%20(Homo%20sapiens[orgn])%20AND%20alive[prop]%20NOT%20newentry[gene]&sort=weight"
)


GBMtopTable$Text <- paste0(
  "log<sub>2</sub>(fold change): ", format(GBMtopTable$logFC, digits = 3), "<br>",
  "Adjusted p-value: ", format(GBMtopTable$adj.P.Val, digits = 3), "<br>",
  "Gene symbol: ", GBMtopTable$Symbol
)

GBMtopTable$Group <- ifelse(GBMtopTable$adj.P.Val < 0.05,
  ifelse(GBMtopTable$logFC > 0, "Up-regulated", "Down-regulated"),
  "Not sig."
)
GBMtopTable <- GBMtopTable[rownames(GBMtopTable) %in% rownames(GBMdata), ]

use_data(GBMtopTable, overwrite = TRUE)
