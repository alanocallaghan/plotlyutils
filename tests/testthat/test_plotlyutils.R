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

  p <- df %>% dropdown_lineplot(x = "seq", yvars=setdiff(colnames(df), "seq"))
  expect_is(p, "plotly")
})

test_that("linked scatter_plot works", {
  p <- linked_scatter_plot(
    1:10,
    1:10,
    rep("https://www.google.com", 10),
    groups = sample(letters[1:2], 10, replace=TRUE))
  expect_is(p, "htmlwidget")
})

test_that("linked scatter_plot works", {
  p <- selectable_scatter_plot(
    mtcars,
    mtcars
  )
  expect_is(p, "htmlwidget")
})
