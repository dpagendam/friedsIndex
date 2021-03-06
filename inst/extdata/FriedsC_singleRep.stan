data {
        int<lower = 1> nRows; //the number of observations
  		int<lower = 0> eggs[nRows]; //the response
  		int<lower = 0> hatched[nRows]; //the response
  		real<lower = 0.0> p1_prior_alpha;
  		real<lower = 0.0> p1_prior_beta;
  		real<lower = 0.0> p2_prior_alpha;
  		real<lower = 0.0> p2_prior_beta;
    }

    parameters {
    	real<lower = 0.0, upper = 1.0> p[2]; // probability of hatching for two groups
	real<lower = 0.0, upper = 1.0> pi_global; // probability of membership for the two groups
    }


    model {
        real log_den[2]; // temp for log component densities
    
      	p[1] ~ beta(p1_prior_alpha, p1_prior_beta);
      	p[2] ~ beta(p2_prior_alpha, p2_prior_beta);
		pi_global ~ beta(1,1);

    	for (ii in 1:nRows) {
    		log_den[1] = log(pi_global) + binomial_lpmf(hatched[ii]| eggs[ii], p[1]);
    		log_den[2] = log(1 - pi_global) + binomial_lpmf(hatched[ii]| eggs[ii], p[2]);
    		target += log_sum_exp(log_den);
    	}
    }
