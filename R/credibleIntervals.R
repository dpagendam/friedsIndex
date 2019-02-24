#' @title Summarise the posterior samples from a binomial mixture model (BMM) undertaken using the function \code{friedsIndexBMM}.
#' 
#' @description \code{credibleIntervals} provides credible intervals and posterior density plots for: (i) the hatch probabilities (hatch rates) under sterile male mating; (ii) the hatch probabilities (hatch rates) under wildtype male mating; (iii) the proportion of matings that were between wildtye females and sterilised males; and (iv) Fried's index.
#' @param \code{samples} is a list obtained as the output from running the function \code{friedsIndexBMM}.
#' @param \code{wildToSterileRatio} is a numeric value that gives the ratio of wildtype to sterile males used in the cage experiments.  It is assumed that all cages used the same ratio.  The default value is 1.0, which corresponds to equal numbers of wildtype to sterile males. 
#' @param \code{quantiles} are the quantiles that the sure would like summarised to the terminal window from the posterior samples.  By default this is \code{quantiles = c(0.025, 0.25, 0.5, 0.75, 0.975)} which can be used to obtain the median and credible intervals.
#' @details The function generates a plot and prints posterior summary information in the form of credible intervals to the terminal window.
#' @return The function returns NULL.
#' @examples 
#' data(dataset_multiRep)
#' samples <- friedsIndexBMM(dataset_multiRep)
#' credibleIntervals(samples, wildToSterileRatio = 1) 
#' 
#' data(dataset_singleRep)
#' samples <- friedsIndexBMM(dataset_singleRep)
#' credibleIntervals(samples, wildToSterileRatio = 1) 
#' @export



credibleIntervals = function(samples, wildToSterileRatio = 1, col = "blue", quantiles = c(0.025, 0.25, 0.5, 0.75, 0.975))
{
	samples_p1 = samples$p[, 1]
	samples_p2 = samples$p[, 2]
	samples_pi_global = samples$pi_global
	samples_frieds = samples$pi_global/(1 - samples$pi_global)*wildToSterileRatio
	
	d1 = stats::density(samples_p1)
	p1 = friedsIndex::densityToPolygon(d1)
	d2 = stats::density(samples_p2)
	p2 = friedsIndex::densityToPolygon(d2)
	d3 = stats::density(samples_pi_global)
	p3 = friedsIndex::densityToPolygon(d3)
	d4 = stats::density(samples_frieds)
	p4 = friedsIndex::densityToPolygon(d4)
	
	par(mfrow = c(2,2))
	m = max(d1$y)
	plot(d1, ylim = c(0, m*1.25), xlab = "Estimate", col = "white", main = "Hatch Probability (Sterile/Incompatible Mated)", ylab = "Density")
	polygon(p1$x, p1$y, col = friedsIndex::fade(col, 75))
	
	m = max(d2$y)
	plot(d2, ylim = c(0, m*1.25), xlab = "Estimate", col = "white", main = "Hatch Probability (Wildtype/Compatible Mated)", ylab = "Density")
	polygon(p2$x, p2$y, col = friedsIndex::fade(col, 75))
	
	m = max(d3$y)
	plot(d3, ylim = c(0, m*1.25), xlab = "Estimate", col = "white", main = "Proportion of Sterile/Incompatible Mated Females", ylab = "Density")
	polygon(p3$x, p3$y, col = friedsIndex::fade(col, 75))
	
	m = max(d4$y)
	plot(d4, ylim = c(0, m*1.25), xlab = "Estimate", col = "white", main = "Fried's Index", ylab = "Density")
	polygon(p4$x, p4$y, col = friedsIndex::fade(col, 75))
	
	cat("-----------------------------------\n")
	cat("Quantiles and Mean for Hatch Probability (Sterile/Incompatible Mated)\n")
	q = quantile(samples_p1, quantiles)
	cat("\n")
	cat("Percentile \t \t Estimate \n")
	for(i in 1:length(quantiles))
	{
		cat(quantiles[i]*100); cat(" \t \t \t"); cat(q[i]); cat("\n")
	}
	cat("\n")
	cat("Mean: "); cat(mean(samples_p1)); cat("\n")
	cat("-----------------------------------\n")
	cat("Quantiles and Mean for Hatch Probability (Wildtype/Compatible Mated)\n")
	q = quantile(samples_p2, quantiles)
	cat("\n")
	cat("Percentile \t \t Estimate \n")
	for(i in 1:length(quantiles))
	{
		cat(quantiles[i]*100); cat(" \t \t \t"); cat(q[i]); cat("\n")
	}
	cat("\n")
	cat("Mean: "); cat(mean(samples_p2)); cat("\n")
	cat("-----------------------------------\n")
	cat("Quantiles and Mean for Proportion of Sterile/Incompatible Mated Females\n")
	q = quantile(samples_pi_global, quantiles)
	cat("\n")
	cat("Percentile \t \t Estimate \n")
	for(i in 1:length(quantiles))
	{
		cat(quantiles[i]*100); cat(" \t \t \t"); cat(q[i]); cat("\n")
	}
	cat("\n")
	cat("Mean: "); cat(mean(samples_pi_global)); cat("\n")
	cat("-----------------------------------\n")
	cat("Quantiles and Mean for  Frieds Index\n")
	q = quantile(samples_frieds, quantiles)
	cat("\n")
	cat("Percentile \t \t Estimate \n")
	for(i in 1:length(quantiles))
	{
		cat(quantiles[i]*100); cat(" \t \t \t"); cat(q[i]); cat("\n")
	}
	cat("\n")
	cat("Mean: "); cat(mean(samples_frieds)); cat("\n")
	cat("-----------------------------------\n")
	return(NULL)
}
