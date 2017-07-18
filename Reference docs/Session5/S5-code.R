##########################
#   Chi-square testing   #
#       Session 5        #
#        05/03/13        #
##########################


##############################
##                          ##
##  Goodness of Fit Tests   ##
##                          ##
##############################

# The goodness of fit test uses
# the chi-square distribution to
# test the null hypothesis that 
# observed data fit a particular
# theoretical model distribution.


#########################
# Binomial test example #
#########################

# A group of researchers at a university put 
# together a short course to introduce 
# other researchers to the R programming 
# environment. Due to an oversight, the 
# researchers forgot to ask users what level 
# their ability in R was before the course began. 
# Following the course participants were asked 
# to state whether their ability was the same 
# as before or improved. Since the researchers 
# cannot measure the difference but they know 
# there has been one, they can use a binomial 
# test
# Of 35 participants, 34 rated their ability 
# as improved. Is such a result possible by chance?

binom.test(34, 35)

# Clearly this R course was a significant benefit 
# to the participants!!

######################
# Proportional test  #
######################

# In recent years, increasing efforts are 
# being made to increase gender representation
# in higher education. You want to test whether 
# the proportions of male and female postgraduate
# students is equal in the UK. To do so, you can 
# use a simple proportional test

# In 2011/12 there were 160,735 female  and 148,690 
# male postgraduates

#First we input the data to the R environment

female <- 160735
male <- 148690

# Of course, in order to calculate the proportion, 
# we also need the total number of students

total <- sum(female, male)

# Running the proportional test, the function 
# will calculate whether the proportions are 
# significantly different
# Furthermore it will also calculate the 
# proportions for you

prop.test(c(female, male), c(total, total))

#######################################
# Chi sq test on a contingency tables #
#######################################

# When rolling a dice, are the probabilities of 
# getting any number between 1 and 6 equal? 
# In this case, the Chi-squared test is testing 
# for uneven probabilities - i.e. that the observed
# counts are significantly greater than 1/6

die <- ceiling(runif(100, 0, 6))

# Before you can run the test, you need to 
# make sure the data are collated as a 
# contingency table of counts

# Luckily, the table function does this for you
?table
table(die)
# Note then that when we run the test, the data 
# is passed to the function as a table.
chisq.test(table(die))

# Also, you can specify the probabilities R 
# uses to calculate the Chi-sq test 
# (i.e. you can change the null hypothesis). 
# Let's say you have many different die and 
# you know one of them is heavily weighted to 
# land on a 6 more regularly

# First, create a vector with the probability 
# of each side specified
uneven_prob <- c(0.1, 0.1, 0.1, 0.1, 0.1, 0.5)

# Then run the test again but this time pass 
# the probabilities as an argument
chisq.test(table(die), p = uneven_prob)

###############################################
# Is a population Hardy-Wienberg Equilibrium? #
###############################################

# Hardy-Wienberg Equilibrium is a standard model 
# in population genetics. It makes some basic 
# assumptions such as all individuals in a population 
# mate randomly, all individuals have an equal 
# chance of mating and that population size is 
# infinite. Under HWE, genotypes in a population 
# have expected frequencies. So a population
# geneticist might perform a Chi-squared test to 
# test whether observed frequencies are different 
# from those expected under HWE. If they are 
# different, this tells us something about the 
# markers used and the population sampled.

# We have a simple population with a locus with 
# alleles A and a. The expected frequencies of 
# these alleles are equal such that p(A) = p = 0.5 
# and p(a) = 0.5 = q. We have the genotype frequencies:

genotype <- data.frame(AA = 287, Aa = 535, aa = 243)

# First we need to calculate the expected genotype 
# frequencies. This can easily be done from allelic 
# frequencies. 

# p represents frequency of A and q represents the 
# frequency of a. They must sum to 1.

p <- 0.5
q <- 0.5
p + q == 1

# The expected frequency of a homozygous 
# genotype is simple the probability of 
# choosing two identical alleles
# at random from the population - or p^2 or q^2
p^2
q^2

# For a given heterozygote such as Aa, the 
# probability of first choosing A and then a, 
# or p x q. BUT, there are actually two ways 
# to get a heterozygote - Aa and aA. So the 
# probability of heterozygotes is simply:
2*p*q

# So now we now the expected probabilities under 
# HWE, we can rerun our chi-squared test to see
# whether our population is different
HWE<- c(p^2, 2*p*q, q^2)
chisq.test(genotype, p = HWE)

# Just as an aside, what would have happened if we 
# had run our chi-squared WITHOUT specifying probabilities?
# Try it and see:

incorrect<- chisq.test(genotype)
incorrect

# Well we get a completely different answer 
# for a start. By defining the results as an 
# object though, we can have a look at the mechanics 
# of the test

objects(incorrect)

# This gives a list of extractable objects from the 
# test results. Use the $ extraction operator to have 
# a look at the expected frequencies

incorrect$expected/sum(incorrect$expected)

# If we don't specify the expected probability, 
# the test will assume they are all equal which 
# is not valid in our case.


#########################
# Binomial test example #
#########################

# A group of researchers at a university put 
# together a short course to introduce 
# other researchers to the R programming 
# environment. Due to an oversight, the 
# researchers forgot to ask users what level 
# their ability in R was before the course began. 
# Following the course participants were asked 
# to state whether their ability was the same 
# as before or improved. Since the researchers 
# cannot measure the difference but they know 
# there has been one, they can use a binomial 
# test
# Of 35 participants, 34 rated their ability 
# as improved. Is such a result possible by chance?

binom.test(34, 35)
# Clearly this R course was a significant benefit 
# to the participants!!

######################################################
# End
######################################################

##########################
#                        #
#  Sample Homogeneity    #
#                        #
##########################

# The chi-sq distribution can be
# used to test the null hypothesis
# of 'no difference' between samples.
# The test of sample independence is
# commonly used to assess the null 
# hypothesis of panmixia in population
# genetics.

# Consider two samples collected from
# two putative trout populations from 
# different geographical locations. It is 
# often important to know if these samples 
# are from the same population for conservation
# and management purposes.

# Using the chi-sq test for sample independence
# this can be easily done in R.

# Read the data set "trout1.txt"
trout_data <- read.table("trout1.txt", 
                         header = TRUE)

# To do a simple chi test we should convert
# our data frame to a contingency table.

# reformat the data into a factored variable

# create the population factor
popFac <- rep(c("pop1", "pop2"), 
              each = nrow(trout_data))

# combine the genotype data
genotypes <- c(trout_data$pop1, 
               trout_data$pop2)

# Combine popFac and genotypes into a 
# dataframe
new_trout <- data.frame(pop = popFac, 
                        geno = as.factor(genotypes))

# Using the excellent function 'table'  
# we can coerce new_table into a contingency
# table

contin_trout <- table(new_trout)

# We can visualise the table using plot

plot(contin_trout, 
     col = heat.colors(ncol(contin_trout)), 
     las = 1)

# Because we have so many classes it is
# hard to see genotype accurately, but
# we can see that the occurrence of classes
# in each population are certainly different.

# Now we can do a simple chi-sq test on the 
# contingency table

chisq.test(contin_trout)

# We get a warning because some of our
# classes (genotypes) are observed less 
# than 5 times (a minimum recommended
# threshold for class observation when
# using chi-sq tests).

# We can rerun the test without these classes
# to see if this helps

# We need to identify which classes do not have
# at least 5 observations per population

dudData <-apply(contin_trout, 2, function(x){
  any(x < 5)
})

dudData

# create a new data set without these columns
contin_fix <- as.table(contin_trout[ , -(which(dudData == TRUE))])

# now rerun the chi-sq test
chisq.test(contin_fix)

# Obviously by removing all but one of out
# genotype classes we massively reduce the
# statistical power of our experiment.

# The bottom line for this experiment is
# we did not collect enough samples to 
# justify the use of a chi-sq test.

# We have two options:
# 1) calculate out p.value using simulation 
# 2) go back to the field and collect more samples

################
#   option 1   #
################

chisq.test(contin_trout, 
           simulate.p.value = TRUE,
           B = 10000)

################
#   option 2   #
################

# Let's compare this to collecting (making up)
# more data. 

# Let's go back to the field and collect
# some more samples.

# read the new data set into R ('trout2.txt')
trout2 <- read.table("trout2.txt", 
                     header = TRUE)

# Now we have collected 500 samples per
# population.

# Convert the data into a factored variable df

new_popFac <- rep(c("pop1", "pop2"),
                  each = nrow(trout2))

pops2 <- c(trout2$pop1, trout2$pop2)

trout_data2 <- data.frame(pop = new_popFac, 
                          geno = pops2)

# convert the trout_data2 df into a table
contin_trout2 <- table(trout_data2)

# visualise

plot(contin_trout2, 
     col = heat.colors(ncol(contin_trout2)), 
     las = 1)

# rerun the chisq test

chisq.test(contin_trout2)

# both p.values demonstrate that these samples
# are unlikely to have some from a single 
# population.

##############################
#                            #
#      Manual chi-sq         #
#                            #
##############################

# Basic formula = (o - e)^2/e

# We can define a function to
# calculate this formula for a 
# vector of numbers

chiCalc <- function(x){
  e <- sum(x) * 1/length(x)
  chi <- (x - e)^2/e
  return(chi)
}

# apply the function to each class of
# 'contin_trout'

chi <- apply(contin_trout, 2, chiCalc)

# calculate the chi sum

chi_total <- sum(chi)

# Calculate the degrees of freedom
# Basic formula = n-1 (n = number of classes)

df = ncol(contin_trout) - 1

# now we can test the significance of our
# chi-sq difference using 'pchisq'

?pchisq

pchisq(q = chi_total, df = df, lower.tail = FALSE)

###########################
#                         #
#  Test of independence   #
#                         #
###########################

# The chi-sq distribution can also
# be use to test for independence of
# categorical variables

# Consider an example where we are interested
# if there is a relationship between gender and
# university course preference.

# We have data from the 1970s and from this year.
# let's look at both to see if things have changes
# over time.

# read 'university1973.txt'
uni1973 <- read.table("uni1973.txt", 
                  header = TRUE)

# convert it to a table

uni1973table <- table(uni1973)

# visualise

plot(uni1973table, col = rainbow(ncol(uni1973table)), 
     las = 1)

# chi-sq test

chisq.test(uni1973table)

# There is an association between gender and
# course enrolment in the 1973 data.

# The university has, over the last 10 years
# promoted a gender neutral approach to
# course promotion in an attempt to break
# this association. Let's see if it has worked

# read the 2013 data
uni2013 <- read.table("uni2013.txt", 
                      header = TRUE) 

# convert to contingency table

uni2013table <- table(uni2013)

# visualise

plot(uni2013table, col = rainbow(ncol(uni2013table)), 
     las = 1)

# chi-sq test

chisq.test(uni2013table)

# Success there is no loner a gender bias in
# university course enrolment.

