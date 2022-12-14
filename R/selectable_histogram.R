#' selectable_histogram
#'
#' A scatterplot with dropdown menus to select the x/y variables and
#' the variable used to colour the points
#' @param vars data.frame or matrix of variables
#'   (each column will be a separate histogram).
#' @param title Plot title
#' @param histnorm See https://plot.ly/javascript/reference/#histogram-histnorm
#' @examples
#' df <- lapply(1:10, function(...) rnorm(1000))
#' df <- as.data.frame(df)
#' colnames(df) <- paste("Histogram", letters[1:10])
#' selectable_histogram(df, "Interactive histogram")
#'
#' @importFrom assertthat assert_that
#' @export
selectable_histogram <- function(
        vars,
        title = "",
        histnorm = c(
            "probability density",
            "",
            "percent",
            "probability",
            "density"
        )
    ) {

    histnorm <- match.arg(histnorm)
    vars <- as.data.frame(vars)
    vars <- as.data.frame(vars)

    createWidget(
        "selectable_histogram",
        x = list(
            coords = vars,
            title = title,
            histnorm = histnorm
        ),
        sizingPolicy = sizingPolicy(
            browser.fill = TRUE,
            viewer.fill = TRUE
        ),
        package = "plotlyutils"
    )
}
