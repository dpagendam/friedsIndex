#' \code{friedsIndex} is an R package for efficiently calculating Fried's index and other
#' useful statistics from insect mating competitveness experiments.  The approach behind the code
#' is presented in the journal paper XXXXXXX which shows how better estimates of Fried's index can
#' be obtained by using only mixed mating cages with analysis using a two-component binomial 
#' mixture model.
#' 
#' The package has two main functions, \code{friedsIndexBMM} which performs the Bayesian inference
#' using the R package \code{rstan}, and \code{credibleIntervals} which summarises the output from
#' \code{friedsIndexBMM} to produce plots and summary statistics useful to the experimentalist.