#' Raw RNAseq counts for TCGA glioblastoma samples
#' 
#' See data-raw for details.
#' 
#' @name GBMdata
#' @docType data
#' @source GDC - TCGA-GBM
#' @keywords data
NULL

#' Voom-transformed log2 counts per million for TCGA glioblastoma samples
#'
#' See data-raw for details.
#' 
#' @name voomed_GBM
#' @docType data
#' @references https://genomebiology.biomedcentral.com/articles/10.1186/gb-2014-15-2-r29
#' @source Derived from GBMdata
#' @keywords data
NULL

#' Linear model results for IDH1 mut vs wt
#'
#' See data-raw for details.
#' 
#' @name GBMtopTable
#' @docType data
#' @source Derived from voomed_GBM
#' @keywords data
NULL
