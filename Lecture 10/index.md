---
title       : BL6024 - Quantitative Skills for Biologists using R
subtitle    : "Lecture 10: An Introduction to Bayesian Statistics"
framework   : io2012        # {revealjs, io2012, html5slides, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax, quiz, bootstrap]           # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
logo        : logo_ucc.png
biglogo     : BEES_logo.jpg
---


## Contents
<br>

- A bit of history
<br>
- Priors and posteriors
<br>
- Bayesian vs. Frequentist
<br>
- The machinery of Bayesian statistics
<br>
- Bayesian statistics in `R`
<br>
- Practical examples

---  .class #id &twocol


## History of Bayesian statistics
<br>

*** =left

- **Bayes**' rule

$$ p(x,y) = p(x|y) \times p(y) $$
$$ p(x,y) = p(y,x) $$


*** =right

<div style='text-align: center'>
    <img src="assets/img/Bayes.gif" style="height:370px"></img>
</div>

---  .class #id &twocol


## History of Bayesian statistics
<br>

*** =left

- **Bayes**' rule

$$ p(x,y) = p(x|y) \times p(y) $$
$$ p(x,y) = p(y,x) $$
$$ p(y|x) = \frac {p(x|y) \times p(y)}{p(x)}$$
<br>


*** =right

<div style='text-align: center'>
    <img src="assets/img/Bayes.gif" style="height:370px"></img>
</div>

---  .class #id &twocol


## History of Bayesian statistics
<br>

*** =left

- **Bayes**' rule

$$ p(x,y) = p(x|y) \times p(y) $$
$$ p(x,y) = p(y,x) $$
$$ p(y|x) = \frac {p(x|y) \times p(y)}{p(x)}$$
<br>

- Use in statistical inference

*** =right

<div style='text-align: center'>
    <img src="assets/img/Bayes.gif" style="height:370px"></img>
</div>

---  .class #id 


## Priors and posteriors
<br>

$$ \color{darkgreen}{p(\theta|x)} = \frac { \color{darkred}{p(x|\theta)} \times \color{darkorange}{p(\theta)}}{\color{darkblue}{p(x)}}$$
<br>



---  .class #id 


## Priors and posteriors
<br>

$$ \color{darkgreen}{p(\theta|x)} = \frac { \color{darkred}{p(x|\theta)} \times \color{darkorange}{p(\theta)}}{\color{darkblue}{p(x)}}$$
<br>

Simplified to: \(\color{darkgreen}{Posterior\ distribution} \sim \color{darkred}{Likelihood} \times \color{darkorange}{Prior\ distribution}\)

i.e. we update our prior belief in light of the data to get a posterior distribution for the parameters
<br>

\(\color{darkblue}{p(x)}\) &rightarrow; Evidence (normalization)


---  .class #id 


## We think Bayesian!
<br>

<div style='text-align: center'>
    <img src="assets/img/ThinkBayes.jpg" style="height:470px"></img>
</div>

---  .class #id 


## Bayesian vs. Frequentist
<br>

**- Both**: data are observed realizations of stochastic systems containing random processes

**- Classical (frequentist) stats:** the quantities used to describe these random processes (parameters) are fixed and unknown constants

**- Bayesian stats:** the parameters are viewed as unobserved realizations of random processes

---  .class #id 

## Bayesian vs. Frequentist
<br>

**- Both**: data are observed realizations of stochastic systems containing random processes

**- Classical (frequentist) stats:** the quantities used to describe these random processes (parameters) are fixed and unknown constants

**- Bayesian stats:** the parameters are viewed as unobserved realizations of random processes

<br>

<p style="text-align: center;"> <span style="color:darkred;">Estimating a single point vs. a distribution </span> </p>

---  .class #id 


## Bayesian vs. Frequentist
<br>

**Uncertainty**:

- **Classical (frequentist) stats**: *frequency of hypothetical replicates*

- **Bayesian stats**: *posterior distribution of a parameter, given the data, the model and the priors*

---  .class #id 


## Bayesian vs. Frequentist
<br>

**Uncertainty**:

- **Classical (frequentist) stats**: *frequency of hypothetical replicates*

- **Bayesian stats**: *posterior distribution of a parameter, given the data, the model and the priors*

<br>

<p style="text-align: center;"> <span style="color:darkred;"> Parameters $\theta$ are random variables &rightarrow; we can make probabilistic statements </span> </p>


---  .class #id &twocol

## Pros & cons of the Bayesian approach

*** =left
<br>

- Flexibility and tractability
<br>
- No asymptotics
<br>
- Incorporate existing information
<br>
- Error propagation
<br>
- Intuitive interpretation

*** =right
<br>

- Prior choice
<br>
- Controversies on model selection
<br>
- Computing times


---  .class #id &twocol

*** =left

<br>
<br>
<br>
<br>

> &nbsp;
> *The argument in the academic community is mostly esoteric tail wagging anyway*. 

> &nbsp;                                    

> &nbsp;
> *In truth most analysts out of the ivory tower don't care that much, if at all, about Bayesian vs. Frequentist*.

(Rob Balon)

*** =right
<br>
<br>
<br>

<div style='text-align: right'>
    <img src="assets/img/Balon.jpg" style="height:320px"></img>
</div>

---  .class #id 


## Bayesian machinery
<br>

- Problem is the estimation of \(p(x)\):
$$ p(x) = \int p(x,\theta)\  d\theta $$

- *Solution*: approximate inference

---  .class #id 


## Bayesian machinery
<br>

- Markov Chain Monte Carlo (MCMC) algorithms
- Not the only solution (e.g. INLA)
- *Software*: WinBUGS (OpenBUGS), JAGS, Stan, Nimble, MCMCglmm, ...

<br>
<div style='text-align: center'>
<img src="assets/img/BUGS.jpg" alt="" style="height:250px"></img>
<img src="assets/img/Stan.png" alt="" style="height:200px"></img>
<img src="assets/img/NIMBLE.png" alt="" style="height:250px"></img>
</div>

---  .class #id 


## Example: Gibbs sampler

<br>

- \(x= \)data, \(\theta= \)vector of *k* unknowns \((\theta_1,\theta_2,...,\theta_k)\)  

---  .class #id 


## Example: Gibbs sampler

<br>

- \(x= \)data, \(\theta= \)vector of *k* unknowns \((\theta_1,\theta_2,...,\theta_k)\)  
- Choose starting values \(\theta_1^{(0)},\theta_2^{(0)},...,\theta_k^{(0)}\)

---  .class #id 


## Example: Gibbs sampler

<br>

- \(x= \)data, \(\theta= \)vector of *k* unknowns \((\theta_1,\theta_2,...,\theta_k)\)  
- Choose starting values \(\theta_1^{(0)},\theta_2^{(0)},...,\theta_k^{(0)}\)
- Sample \(\theta_1^{(1)}\) from \(p(\theta_1|\theta_2^{(0)},\theta_3^{(0)},...,\theta_k^{(0)},x)\)
 <br />
 Sample \(\theta_2^{(1)}\) from \(p(\theta_2|\theta_1^{(1)},\theta_3^{(0)},...,\theta_k^{(0)},x)\)
 <br />
......................
 <br />
 Sample \(\theta_k^{(1)}\) from \(p(\theta_k|\theta_1^{(1)},\theta_2^{(1)},...,\theta_{k-1}^{(1)},x)\)


---  .class #id 


## Example: Gibbs sampler

<br>

- \(x= \)data, \(\theta= \)vector of *k* unknowns \((\theta_1,\theta_2,...,\theta_k)\)  
- Choose starting values \(\theta_1^{(0)},\theta_2^{(0)},...,\theta_k^{(0)}\)
- Sample \(\theta_1^{(1)}\) from \(p(\theta_1|\theta_2^{(0)},\theta_3^{(0)},...,\theta_k^{(0)},x)\)
 <br />
 Sample \(\theta_2^{(1)}\) from \(p(\theta_2|\theta_1^{(1)},\theta_3^{(0)},...,\theta_k^{(0)},x)\)
 <br />
......................
 <br />
 Sample \(\theta_k^{(1)}\) from \(p(\theta_k|\theta_1^{(1)},\theta_2^{(1)},...,\theta_{k-1}^{(1)},x)\)
- Repeat previous step many times to get a good approximation of \(p(\theta|x)\)


---  .class #id 


## Example: Gibbs sampler

<br>

- \(x= \)data, \(\theta= \)vector of *k* unknowns \((\theta_1,\theta_2,...,\theta_k)\)  
- Choose starting values \(\theta_1^{(0)},\theta_2^{(0)},...,\theta_k^{(0)}\)
- Sample \(\theta_1^{(1)}\) from \(p(\theta_1|\theta_2^{(0)},\theta_3^{(0)},...,\theta_k^{(0)},x)\)
 <br />
 Sample \(\theta_2^{(1)}\) from \(p(\theta_2|\theta_1^{(1)},\theta_3^{(0)},...,\theta_k^{(0)},x)\)
 <br />
......................
 <br />
 Sample \(\theta_k^{(1)}\) from \(p(\theta_k|\theta_1^{(1)},\theta_2^{(1)},...,\theta_{k-1}^{(1)},x)\)
- Repeat previous step many times to get a good approximation of \(p(\theta|x)\)
- The sequence of random draws for each parameter *k* forms a Markov chain


---  .class #id 


## BUGS/JAGS in practice
<br>

- Define model
- Set priors and constraints
- Compile model based on data
- Initialise chains
- Iterate chains until convergence
- Obtain posterior sample
- Monitor convergence and prior sensitivity
- Model validation and selection

---  .class #id &twocol


## Choosing your priors

*** =left
<br>

- <p style='text-align: left'>What is a reasonable prior?</p>
<br>
- <p style='text-align: left'>Uninformative vs. informative</p>
<br>
- <p style='text-align: left'> Can have subtle effects in multidimensional cases </p>
<br>
- <p style='text-align: left'>Assess prior sensitivity</p>

*** =right
<div style='text-align: right'>
    <img src="assets/img/Prior.gif" style="height:250px"></img>
</div>
<div style='text-align: right'>
    <img src="assets/img/Choice.jpg" style="height:250px"></img>
</div>

---  .class #id 


## Convergence monitoring

- *Trace plots and burn-in*

<br>
 
<div style='text-align: center'>
    <img src="assets/img/trace.png" style="height:350px"></img>
</div>

---  .class #id 

## Convergence monitoring

- Trace plots and burn-in
- *Use multiple parallel chains*
 
<br>
 
<div style='text-align: center'>
    <img src="assets/img/chains.jpg" style="height:350px"></img>
</div>

---  .class #id 

## Convergence monitoring

- Trace plots and burn-in
- Use multiple parallel chains
- *Brooks-Gelman-Rubin (BGR) diagnostic* 

<div style='text-align: center'>
    <img src="assets/img/BGR.gif" style="height:350px"></img>
</div>

---  .class #id 

## Convergence monitoring

- Trace plots and burn-in
- Use multiple parallel chains
- Brooks-Gelman-Rubin (BGR) diagnostic 
- *Density plots*

<div style='text-align: center'>
    <img src="assets/img/density.png" style="height:350px"></img>
</div>

---  .class #id 

## Convergence monitoring

- Trace plots and burn-in
- Use multiple parallel chains
- Brooks-Gelman-Rubin (BGR) diagnostic 
- Density plots
- *Monte Carlo error*

---  .class #id 


## Convergence monitoring

- Trace plots and burn-in
- Use multiple parallel chains
- Brooks-Gelman-Rubin (BGR) diagnostic 
- Density plots
- Monte Carlo error
- *Autocorrelation and thinning*

<div style='text-align: center'>
    <img src="assets/img/autoc.jpg" style="height:250px"></img>
</div>

---  .class #id 

## Convergence monitoring

- Trace plots and burn-in
- Use multiple parallel chains
- Brooks-Gelman-Rubin (BGR) diagnostic 
- Density plots
- Monte Carlo error
- Autocorrelation and thinning
- *Effective sample size and posterior summary*

---  .class #id 



## Model validation and selection
<br>

- Challenging (as in frequentist!)
- Residual diagnostics (for non-hierarchical models)

<div style='text-align: center'>
    <img src="assets/img/residuals.png" style="height:350px"></img>
</div>

---  .class #id 

## Model validation and selection
<br>

- Challenging (as in frequentist!)
- Residual diagnostics (for non-hierarchical models)
- Hierarchical models: cross-validation, validation with test data, posterior predictive checks.
- 95% credible intervals and overlap with 0
- Deviance Information Criterion (DIC)
- RJ-MCMC

---  .class #id 


## Examples
<br>

- I will show you a couple of example in **OpenBUGS**
 
<br>
 
- A bit clunky, but it clarifies the process

<br>
 
- It can be run from **R** (`R2OpenBUGS` package)

<br>
 

- We'll do the last example in **JAGS** (very similar syntax but fully in `R`) 

---  .class #id 


## Example: estimating the mean
<br>
- In **OpenBUGS**
 
<br>
 
- Two datasets: 10 and 1,000 observations 

---  .class #id 


## Example: is the coin fair?

<br>
- Also in **OpenBUGS**

<br>
- The data includes a string of heads (1s) and tails (0s)
 
<br>
 
- These have different (non-Gaussian) distribution

---  .class #id 


## Example: simple linear regression
<br>
- Data:



```r
dat<-read.csv("Data_LinRegExample.csv",header=T)
head(dat)
```

```
##   Weight Temperature
## 1   3.37        11.0
## 2   3.06        10.3
## 3   3.76        14.9
## 4   3.26        12.8
## 5   1.79        10.2
## 6   2.94        14.5
```

---  .class #id 


## Example: simple linear regression

- Model:

```r
model
{
 #Priors
 beta[1] ~ dunif(-500,2000)
 beta[2] ~ dnorm(0,0.0001)
 std ~ dunif(0,1000)
 precision <- 1/std/std

 #Likelihood
 for (i in 1:nobs){
  lin.pred[i] <- beta[1] + beta[2]*Temperature[i]
  Weight[i] ~ dnorm(lin.pred[i], precision)
  }
}
```

---  .class #id 


## Example: simple linear regression


```r
library(runjags)

#data
dim(dat)
```

```
## [1] 1000    2
```

```r
dataList<- list(nobs=1000, Weight=dat$Weight, Temperature=dat$Temperature)

#initial values
initsList1<- list(beta=c(0,0), std=1)
initsList2<- list(beta=c(1,1), std=10)
initsList3<- list(beta=c(-1,-1), std=5)

#model file name
model.file <- "JAGS_LinRegExample_model.R"
```

---  .class #id 


## Example: simple linear regression


```r
#set parameters to monitor
par.monitor <- c("beta","std")

#run MCMC
psamples<-run.jags(model = model.file, monitor = par.monitor, 
                   data = dataList, n.chains = 3, inits = list(initsList1, initsList2, initsList3),
                   burnin = 1000, adapt=200, thin=10, sample = 10000)
```

---  .class #id 

## Example: simple linear regression





```r
library(coda)

mcmc <-as.mcmc.list(psamples$mcmc)

#effective size
effectiveSize(mcmc)
```

```
##   beta[1]   beta[2]       std 
##  1603.786  1606.760 30000.000
```

---  .class #id 

## Example: simple linear regression


```r
#trace plots
par(mfrow=c(1,3), cex.main=3, cex.lab=3)
traceplot(mcmc)
```

![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-4-1.png)

---  .class #id 

## Example: simple linear regression


```r
#BGR diagnostic
gelman.diag(mcmc)
```

```
## Potential scale reduction factors:
## 
##         Point est. Upper C.I.
## beta[1]       1.01       1.02
## beta[2]       1.01       1.02
## std           1.00       1.00
## 
## Multivariate psrf
## 
## 1
```

---  .class #id 

## Example: simple linear regression


```r
#MC error vs SD (%)
summa<-summary(mcmc)
summa[[1]][,4]/summa[[1]][,2]*100
```

```
##   beta[1]   beta[2]       std 
## 2.5029190 2.5081865 0.5773279
```

---  .class #id 

## Example: simple linear regression


```r
#autocorrelation plots
par(mfrow=c(1,3),cex.main=2,cex.lab=2)
autocorr.plot(mcmc[[1]], auto.layout = F)
```

![plot of chunk unnamed-chunk-7](assets/fig/unnamed-chunk-7-1.png)

---  .class #id 

## Example: simple linear regression


```r
#density plots
par(mfrow=c(1,3),cex.main=2,cex.lab=2)
densplot(mcmc)
```

![plot of chunk unnamed-chunk-8](assets/fig/unnamed-chunk-8-1.png)

---  .class #id 

## Example: simple linear regression

```r
#Summary of the posterior distribution
summary(mcmc)
```


```
##              Mean         SD     Naive SE Time-series SE
## beta[1] 0.9209643 0.26667889 0.0015396713   0.0066747567
## beta[2] 0.2014023 0.02120046 0.0001224009   0.0005317472
## std     0.9886692 0.02217291 0.0001280154   0.0001280104
```


```
##              2.5%       25%       50%       75%     97.5%
## beta[1] 0.3958284 0.7431943 0.9229834 1.1019540 1.4364026
## beta[2] 0.1605388 0.1870467 0.2012812 0.2155177 0.2432101
## std     0.9464767 0.9734196 0.9880827 1.0033114 1.0331482
```

---  .class #id 

## Practical - Objectives
<br>

- Estimate the mean and standard deviation of a set of numbers, and the parameters of a simple linear regression (using the example from Session 4)

- Familiarise yourself with BUGS language and `R2OpenBUGS` and `coda` packages in `R`

- Compare the results obtain in a frequentist vs. Bayesian setting

---  .class #id 

<br>
<br>
<br>
## Any questions?
<br>
<br>
<br>
<br>
<br>
<br>
<br>
*Acknowledgements*:  
Introduction to WinBUGS for Ecologists - M. K&#233;ry  
Adam Kane

---
