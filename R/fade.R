#' @title A function for creating transparent colours
#' 
#' @description \code{fade} provides the name of a semi-transparent R colour after passing the name of a base colour or colours (e.g. "blue") and the degree of opacity desired.
#' @param \code{colors} is a character string of colour names to which transparency should be added.
#' @param \code{alpha} is a numeric vector specifying the desired opactity for each colour in \code{colors}.  This should be an integer between 0 and 255
#' @return The function returns a string containing the hexidecimal colour code and is then easily used as the colour to use in standard R plot commands.
#' @examples 
#' newColour <- fade(c("blue", "green", "purple"), c(50, 100, 200))
#' @export


fade <- function(colors,alpha)
{
    rgbcols <- col2rgb(colors)
    rgb(rgbcols[1,],rgbcols[2,],rgbcols[3,],alpha,max=255)
}

