context("plotlyutils")


test_that("boxplot works", {
  expect_is(plotly_boxplot(iris[, -5]), "plotly")
})
test_that("density plot works", {
  p <- plotly_density(
    log2(GBMdata@assays[[1]][, 1:10] + 0.5),
    palette = colorspace::rainbow_hcl,
    xlab = "log<sub>2</sub>(reads + 0.5)"
  )
  expect_is(
    p,
    "plotly"
  )
})

test_that("dropdown lineplot works", {
  set.seed(42)
  df <- lapply(1:26, function(x) rnorm(50)) %>%
    as.data.frame()
  colnames(df) <- letters
  df[["seq"]] <- 1:50

  p <- df %>% dropdown_lineplot(x = "seq")
  expect_is(p, "plotly")
})

test_that("linked scatter_plot works", {
  tt <- GBMtopTable[sample(seq_len(nrow(GBMtopTable)), 1000), ]
  p <- linked_scatter_plot(
    x = tt[["logFC"]],
    xlab = "log<sub>2</sub>(fold-change)",
    y = -log10(tt[["adj.P.Val"]]),
    ylab = "-log<sub>10</sub>(FDR-adjusted p-value)",
    xlim = c(-max(abs(tt[["logFC"]])), max(abs(tt[["logFC"]]))) * 1.1,
    text = tt[["Text"]],
    links = tt[["Links"]],
    groups = tt[["Group"]],
    title = "Glioblastoma - IDH1 mutant vs wt",
    colors = c("#0000ff", "#000000", "#ff0000")
  )
  expect_is(p, "htmlwidget")
})

test_that("linked scatter_plot works", {
  p <- selectable_scatter_plot(
    mtcars,
    mtcars
  )
  expect_is(p, "htmlwidget")
})
