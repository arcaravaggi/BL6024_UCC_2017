#######################
#                     #
# Power analysis in R #
#                     #
#######################

# Session 10 #

# R-peer-group

#######################
#                     #
# DIY power analysis  #
#                     #
#######################

# T-test example

# To understand the principals
# of power analysis, let's look
# at a DIY t-test example.

# define a range of sample sizes
n <- seq(2, 100, 2)

# simulate two groups with a 
# difference in means of 5%,
# and equal sd of 3

group1 <- rnorm(n = 1000, mean = 40, 
                sd = 3)

group2 <- rnorm(n = 1000, mean = 42, 
                sd = 3)

# for each element of n carry out a
# bunch of t-test for two samples of 
# n size

# number of replicates
nsim <- 1000

# define a function to resample groups
rsGroups <- function(g1, g2, n){
  new_g1 <- sample(g1, n, replace = TRUE)
  new_g2 <- sample(g2, n, replace = TRUE)
  list(new_g1 = new_g1, new_g2 = new_g2)
}

# example of using the function
rsGroups(group1, group2, 5)

power_res <- lapply(n, function(x){
  p_vals <- sapply(1:nsim, function(...){
    samps <- rsGroups(group1, group2, x)
    t.test(samps$new_g1, samps$new_g2)$p.value
  })
  return(p_vals)
})


# let's look at a density plot
# for n = 10
plot(density(power_res[[which(n == 10)]]))

# add alpha line
abline(v = 0.05, col = "red")

# Power is the proportion of simulations
# to the left of the red line

# let's find out

pwrs <- sapply(power_res, function(x){
  return(length(x[x < 0.05])/nsim)
})

# let's plot pwrs against n
plot(pwrs ~ n, type = "l", las = 1, lwd = 2,
     xlab = "Sample size", ylab = "power")

# what is the minimum sample size
# required for 80% power?
abline(v = min(n[which(pwrs >= 0.8)]), 
       col = "red", lwd = 2)

min(n[which(pwrs >= 0.8)])

# Using these principals you can
# do power analysis for any test
# of interest. The difficult part
# Is data simulation!!!

#########################
#                       #
# END of Power analysis #
#                       #
#########################
#########################
#########################
#                       #
#  Clustering analysis  #
#                       #
#########################

# clusters for data exploration 
# purposes 

# install vegan package
install.packages("vegan")

# Load vegan package
library("vegan")

# read data set
gen1 <- read.table("biovolume_genus2.csv", 
                   row.names = "X", sep = ",", 
                   header = TRUE)

##############################
# single linkage (gradients) #
##############################
summary(gen1)

genpres <- vegdist(gen1, method = "jaccard")

clust_genpres <- hclust(genpres, 
                        method = "single")

plot(clust_genpres, 
     main = "Presence/Absence Genera", 
     xlab = "Single linkage", 
     ylab = "Height (Jaccard)")


genbio1 <- vegdist(sqrt(gen1), 
                   method = "bray")

clust_genbio <- hclust(genbio1, 
                       method = "single")

plot(clust_genbio, 
     main = "Biomass of Genera", 
     xlab = "Single linkage", 
     ylab = "Height(Bray Curtis)")

############################################
# complete linkage (disparities or breaks) #
############################################

clust_genbio_comp <- hclust(genbio1, 
                            method = "complete")

plot(clust_genbio_comp, 
     main = "Biomass of Genera", 
     xlab = "Complete linkage", 
     ylab = "Height(Bray Curtis)")


clust_genbio_ave <- hclust(genbio1, 
                           method = "average")

plot(clust_genbio_ave, 
     main = "Biomass of Genera", 
     xlab = "Complete linkage", 
     ylab = "Height(Bray Curtis)")

##############################################
# creating subsets by cutting the dendrogram #
##############################################

# specify number of groups
x1 <- cutree(clust_genbio_comp, 
             k = 4) 
x1

# specify level of disimmilarity 
x2 <- cutree(clust_genbio_comp, 
             h = 0.6)
x2

# mark clusters with rectangles in diagram 

plot(clust_genbio_comp, 
     hang = -1, 
     main = "Biomass of Genera", 
     xlab = "Complete linkage", 
     ylab = "Height(Bray Curtis)")

rect.hclust(clust_genbio_comp, 4)

#END

