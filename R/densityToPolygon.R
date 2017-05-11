#' @title A function for turning a kernel density estimate into x,y points that can be interpretted as a polygon
#' 
#' @description \code{densityToPolygon} takes a kernel density estimate object and turns this into x and y coordinates that then be plotted using R's \code{polygon} function.
#' @param \code{d} a kernel density estimate object from the R function \code{kde}.
#' @return The function returns a list containing two numeric vectors named \code{x} and \code{y}.  These are the x and y coordinates for the vertices of a polygon that can be plotted as a probability density function.
#' @examples 
#' samples <- rnorm(1000)
#' d <- kde(samples)
#' p <- densityToPolygon(d)
#' m = max(d$y)
#' plot(d, ylim = c(0, m*1.25), xlab = "Estimate", col = "white", main = "Hatch Probability (Sterile Mated)", ylab = "Density")
#' polygon(p$x, p$y, col = "blue")
#' @export

densityToPolygon = function(d)
{
	x = c(d$x, rev(d$x), d$x[1])
	y = c(rep(0, length(d$x)), rev(d$y), 0)
	return(list(x = x, y = y))
}

