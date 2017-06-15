## friedsIndex

## Statistical Analysis of Insect Mating Competitiveness Experiments
**Authors**: Dan Pagendam, Wen-Hsi Yang

friedsIndex is an R package providing an improved method of calculating Fried's index from insect mating competitiveness experiments.

The new approach is based on a two-component binomial mixture model in the Bayesian framework and uses only mixed mating cages containing wildtype females, wildtype males and sterilised males.  Our approach departs from the traditional experimental design used for calculating Fried's index where, in addition to mixed mating cages, incompatible mating and compatible mating control cages are necessary.  The new approach is statistically efficient, meaning that precise estimates of Frieds index can be obtained with fewer replicate cages than under the traditional approach.  This makes the new approach cost-effective in terms of the experimental time and cost.

In addition to estimating posterior distributions for Fried's index, the method also provides the posterior distributions for the hatch rates from wildtype and sterile matings.  The outputs of the method can be used to construct Bayesian credible intervals for these parameters, which provides a degree of confidence or certainty about these estimated parameters.

### Package installation

To install the package from GitHub, you will first need to install the devtools package in R using the command:

```install.packages("devtools")```

Once installed, you will need to load the devtools R package and install the friedsIndex R package using:

```
library(devtools)
install_github("dpagendam/friedsIndex")
```

### Using this package

To use friedsIndex with some of the packaged example data, try:

```
library(friedsIndex)
data(dataset_multiRep)
samples <- friedsIndexBMM(dataset_multiRep)
credibleIntervals(samples, wildToSterileRatio = 1) 
```

If you examine the dataset <code>dataset_multiRep</code> in the above, you will see that that experiment consisted of a number of replicate cages.  The method also works for experiments where one larger cage experiment is run (for example in large semi-field cages).  To see this try the example:

```
library(friedsIndex)
data(dataset_singleRep)
samples <- friedsIndexBMM(dataset_singleRep)
credibleIntervals(samples, wildToSterileRatio = 1) 
```

