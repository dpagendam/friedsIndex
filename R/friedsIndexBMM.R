#' @title Perform a binomial mixture model (BMM) analysis of mating competitiveness experiments to estimate Frieds Index and egg hatch probabilities under sterile and wildtype matings.
#' 
#' @description \code{friedsIndexBMM} uses a two component binomial mixture model (BMM) to analyse the data from insect mating competitiveness experiments conducted in cages.  All cages should contain the same numbers of females, wildtype males and sterilised males.  The method uses only mixed mating cages and does not use the compatible and incompatible control cages that are used in traditional estimates of Frieds Index.
#' @param \code{dataset} is a matrix containing columns named "NumEggs", "NumViable" and "Cage".  Each row in \code{dataset} should correspond to the number of eggs laid ("NumEggs"), number of viable/hatched eggs ("NumViable") and the replicate cage number ("Cage") for each female.  All values for "NumEgg", "NumViable" and "Cage" should be integers.  The values used for "Cage" should be integers starting with 1 for the first replicate cage and increasing up to the maximum number of replicate cages.
#' @param \code{alpha_sterile} the parameter alpha of the beta distribution to be used for the prior on the hatch probability of eggs produced from matings between wildtype females and sterilised males (alpha and beta default to 1.0 which is a uniform prior).
#' @param \code{beta_sterile} the parameter beta of the beta distribution to be used for the prior on the hatch probability of eggs produced from matings between wildtype females and sterilised males (alpha and beta default to 1.0 which is a uniform prior).
#' @param \code{alpha_wildtype} the parameter alpha of the beta distribution to be used for the prior on the hatch probability of eggs produced from matings between wildtype females and wildtype males (alpha and beta default to 1.0 which is a uniform prior).
#' @param \code{beta_wildtype} the parameter beta of the beta distribution to be used for the prior on the hatch probability of eggs produced from matings between wildtype females and wildtype males (alpha and beta default to 1.0 which is a uniform prior).
#' @param \code{numChains} the number of chains to use when sampling from the posterior distribution (defaults to 1).
#' @param \code{control} a list of control parameters that is passed to the \code{stan} function in the package \code{rstan}.  See the \code{rstan} package documentation for details.  The default control parameters used in \code{friedsIndexBMM} are \code{control = list(adapt_delta = 0.99, max_treedepth = 20)}.
#' @param \code{iter} the number of samples to draw from the posterior distribution (defaults to 2000).
#' @param \code{warmup} the number of initial samples to discard from the analysis to allow the chain(s) to warms-up/burn-in (defaults to 1000).
#' @return The function returns a list containing the posterior samples from the BMM analysis (which can be passed to \code{credibleIntevals} for summarisation). The list item named \code{p} is a two column matrix, with the first column containing posterior samples of the sterile-mating egg hatch probability and the second column the posterior samples of the wildtype egg hatch probability.  The list item named \code{pi_global} contains the posterior samples for the proportion of matings that were between a wildtype female and a sterilised male.  Samples of \code{pi_global} can be used to obtain posterior samples of Fried's index as \code{pi_global*wildtypeSterileRatio/(1 - pi_global)}, where \code{wildtypeSterileRatio} is the ratio of wildtype to sterile males that was used in the mixed mating cages.  This calculation of Fried's index is performed for the user in the function \code{credibleIntervals}.
#' @examples 
#' data(dataset_multiRep)
#' samples <- friedsIndexBMM(dataset_multiRep)
#' credibleIntervals(samples, wildToSterileRatio = 1) 
#' 
#' data(dataset_singleRep)
#' samples <- friedsIndexBMM(dataset_singleRep)
#' credibleIntervals(samples, wildToSterileRatio = 1) 
#' @export

friedsIndexBMM = function(dataset, alpha_sterile = 1.0, beta_sterile = 1.0, alpha_wildtype = 1.0, beta_wildtype = 1.0, numChains = 1, control = list(adapt_delta = 0.99, max_treedepth = 20), iter = 2000, warmup = 1000)
{
	require(rstan)
	# You need the suggested package for this function    
	if (!requireNamespace("rstan", quietly = TRUE))
	{
		stop("You need to install the R package rstan to use this function.", call. = FALSE)
	}

	
	numReplicates = length(unique(dataset[, "Cage"]))
	fpath_single = system.file("extdata", "FriedsC_singleRep.stan", package="friedsIndex")
	fpath_multi = system.file("extdata", "FriedsC_multipleReps.stan", package="friedsIndex")
	if(numReplicates == 1)
	{
		code = paste(readLines(fpath_single), collapse = '\n')
	}
	else
	{
		code = paste(readLines(fpath_multi), collapse = '\n')
	}

	#Do a simple k-means clustering to determine what the hatch probabilities are in the two populations
	km <- stats::kmeans(dataset[, "NumViable"]/dataset[, "NumEggs"], 2)
	centers = sort(km$centers)
	if(all(centers == km$centers))
	{
		ind1 = which(km$cluster == 1)
		ind2 = which(km$cluster == 2)
		
	}
	else
	{
		ind1 = which(km$cluster == 2)
		ind2 = which(km$cluster == 1)
	}

	friedsInit = (length(ind1) + 0.001)/(length(ind2) + 0.001)
	
	#p is the vector of hatch rates from the two clusters.
	#pi_s is the probability of sterile mating
	initList = list(p = centers, pi_s = rep(friedsInit, length(unique(dataset[, "Cage"]))), alpha = 1.0, pi_global = 0.5)
	init = list()
	for(i in 1:numChains)
	{
		init[[i]] = initList
	}
	stanData <- list(eggs = dataset[, "NumEggs"], hatched = dataset[, "NumViable"], nRows = nrow(dataset), nCages = length(unique(dataset[, "Cage"])), cage = dataset[, "Cage"], p1_prior_alpha = alpha_sterile, p1_prior_beta = beta_sterile, p2_prior_alpha = alpha_wildtype, p2_prior_beta = beta_wildtype)
	fit <- rstan::stan(model_code = code, data = stanData, iter = iter, warmup = warmup, chains = numChains, control = control, init = init)
	samples <- rstan::extract(fit, permuted = TRUE, inc_warmup = FALSE)
	return(samples)
}
