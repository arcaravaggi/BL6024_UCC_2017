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
- Bayesian vs. frequentist
<br>
- The machinery of Bayesian statistics
<br>
- Bayesian statistics in R
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

<div style='text-align: center'>
    <img src="assets/img/chains.jpg" style="height:300px"></img>
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


## Example: estimating the mean
<br>

---  .class #id 


## Example: is the coin fair?
<br>

---  .class #id 


## Example: simple linear regression
<br>

---  .class #id 


## Practical - Objectives
<br>

- Estimate the mean, probability of obtaining heads and the parameters of a simple linear regression (using the example from Session XX)

- Familiarise yourself with BUGS language and `R2OpenBUGS` and `coda` packages in `R`

- Compare the results obtain in a frequentist vs. Bayesian setting

---  .class #id 

<br>
<br>
<br>
## Any questions?


---
