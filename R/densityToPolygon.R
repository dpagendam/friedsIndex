
densityToPolygon = function(d)
{
	x = c(d$x, rev(d$x), d$x[1])
	y = c(rep(0, length(d$x)), rev(d$y), 0)
	return(list(x = x, y = y))
}

