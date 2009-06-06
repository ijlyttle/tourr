#' Parallel coordinates tour path animation.
#'
#' Animate a nD tour path with a parallel coordinates plot. 
#'
#' The lines show the observations, and the points, the values of the 
#' projection matrix.
#'
#' @param data matrix, or data frame containing numeric columns
#' @param tour_path tour path generator, defaults to the grand tour
#' @param ... other arguments passed on to \code{\link{animate}}
#' @seealso \code{\link{animate}} for options that apply to all animations
#' @keywords hplot
#' @examples
#' animate_pcp(flea[, 1:6], grand_tour(3))
#' animate_pcp(flea[, 1:6], grand_tour(5))
animate_pcp <- function(data, tour_path = grand_tour(3), ...) {


  animate(
    data = data, tour_path = tour_path, 
    display = display_pcp(data,...), ...
  )
}


display_pcp <- function(data, ...)
{
  labels <- NULL
  init <- function(data)
  {
  	labels <<- abbreviate(colnames(data),2)
  }
  
  render_frame <- function() {
    blank_plot(xlim = c(0, 1), ylim = c(-2, 2))
  }
  render_transition <- function() {
    # rect(0, -1.99, 1, 1.99, col="#FFFFFFE6", border=NA)
  }
  render_data <- function(data, proj, geodesic) { 
    d <- ncol(proj)
    xpos <- seq(0, 1, length = d+ 2)[-c(1, d + 2)]
    ys <- as.vector(t(cbind(data %*% proj, NA)))
    xs <- rep(c(xpos, NA), length = length(ys))
    
    render_frame()
    # Grid lines
    segments(xpos, 1.99, xpos, -1.99, col="grey90")
    segments(0, 0, 1, 0, col="grey90")
    
    # Projection values
    label_df <- data.frame(
      x = xpos, 
      y = as.vector(t(proj)),
      label = rep(labels, each = d)
    )
    with(
      subset(label_df, abs(y) > 0.05), 
      text(x, y, label = label, col="grey50", pos = 4)
    )
    with(label_df, points(x, y, col="grey50", pch = 20))
    
    # Data values
    lines(xs, ys)
  }  
  
  list(
    init = init,
    render_frame = render_frame,
    render_transition = render_transition,
    render_data = render_data,
    render_target = nul
  )
  
}