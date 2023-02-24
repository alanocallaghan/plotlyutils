#' selectable_scatter_plot
#'
#' A scatterplot with dropdown menus to select both the x & y variables and
#' the variable used to colour the points.
#' @param mat Matrix to calculate PCs.
#' @param df \code{data.frame} of covariates to associate with PCs of \code{mat}.
#' @param coords data.frame or matrix of point co-ordinates
#' Each column will be an entry in the X and Y drop-down menus
#' @param colours data.frame of variables used to colour points
#' @param select_first Variable to use as default colour when plot is loaded.
#' @param title Plot title.
#' @param ... Passed to \code{\link{selectable_scatter_plot}}.
#' @examples
#' pcs <- prcomp(mtcars)
#' colours <- mtcars[, c("cyl", "vs", "am", "gear", "carb")]
#' colours[] <- lapply(colours, as.character)
#' selectable_scatter_plot(
#'   pcs$x,
#'   colours,
#'   "Interactive PCA plot"
#' )
#' @importFrom assertthat assert_that
#' @rdname selectable_scatter_plot
#' @export
selectable_scatter_plot <- function(
        coords,
        colours,
        title = "",
        select_first = NULL
    ) {

    assert_that(
        inherits(coords, "matrix") || inherits(coords, "data.frame"),
        inherits(colours, "data.frame"),
        nrow(coords) == nrow(colours)
    )
    coords <- as.data.frame(coords)
    colours <- as.data.frame(colours)
    stopifnot(select_first %in% colnames(colours))
    createWidget(
        "selectable_scatter_plot",
        x = list(
            coords = coords,
            colours = colours,
            names = rownames(coords),
            title = title,
            select_first = select_first
        ),
        sizingPolicy = sizingPolicy(
            browser.fill = TRUE,
            viewer.fill = TRUE
        ),
        package = "plotlyutils"
    )
}

#' @export
#' @rdname selectable_scatter_plot
pca_selectable_scatter_plot <- function(mat, df, ...) {
    pc <- prcomp(mat)
    pcs <- pc$x

    # calculate variance explained
    eigs <- (pc$sdev^2)
    varexp <- eigs / sum(eigs)
    varexp <- round(varexp * 100, digits = 1)

    # add to x/y labels
    colnames(pcs) <- paste0(colnames(pcs), " (", varexp, "%)")
    df <- df[, order(colnames(df))]
    selectable_scatter_plot(pcs, df, ...)
}
