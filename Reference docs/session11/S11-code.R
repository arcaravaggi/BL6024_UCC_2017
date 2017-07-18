# Introduction to R

# Session 11

# Multivariate methods : ordination + kmeans

# R-Peer-Group

## RUTH PCA

## PCA's  
chemvalues <- read.table("Soilchem2.csv", 
                         sep = ",", header = TRUE)
str(chemvalues)
names(chemvalues)

# Install and load vegan pkg
install.packages("vegan")
library("vegan")

# Extract relevant variables
chem <- chemvalues[, 5:12]

summary(chem)


##################
pca_chem <- rda(chem, 
                scale = TRUE)

# note scale = TRUE, rescales our 
# variables by mean and standard 
# deviation prior to analysis

### demonstration of 3d plot.. 

sum1 <-  summary(pca_chem)

# Install and load rgl pkg
install.packages("rgl")
library("rgl")

plot3d(sum1$species[,1:3])
plot3d(sum1$sites[,1:3], 
       col = chemvalues$Burnt)


# biplot

biplot(pca_chem, choices = c(1:2), 
       scaling = 2, 
       main = "PCA soil chemistry", 
       xlab = "PCA1", ylab = "PCA2", 
       cex.lab = 1.5, cex.main = 1.8) 
text(pca_chem, scaling = 2, 
     dis = "species")

##############

# Scaling - their are two ways 
# to visualise a pca plot. 

# when scaling = 1 - distances 
# between sites are approximations 
# of their euclidian distance in 
# multidimensional space,
# BUT angles between descriptor 
# variables are meaningless. 

# when scaling = 2 - the reverse is true.. 
# Now distances between sites are 
# meaningless BUT angles between 
# descriptor variables are meaningful.

# scaling = 2 is what we want in the 
# above example because we are interested 
# in the relationship between the 
# chemistry variables (not the sites per se)

summary(pca_chem, scaling = 2)

# Eigenvalues - measures of importance 
# of the axes, can be expressed as the 
# proportion of variation explained by a 
# particular axis


# Species scores are the position of the 
# variable on that axis (a measure of the 
# strength of the association between that 
# variable and that axis) 

# site scores are the same as species 
# scores but with sites

###############

# Choosing the optimal number of axes.

# There is no definite rule about how 
# many axes to use but there are a few 
# rules of thumb, some people use the 
# number of axes which will explain 
# >75% of the variation. This can be 
# read from the summary table.

# Alternatively we can first extract 
# the eigenvalues from the pca object

ev <- pca_chem$CA$eig

# visually assess how many axes are 
# useful


barplot(ev, main = "Eigenvalues", 
        col = "grey", las = 2)

# One rule of thumb is to use axes 
# that have an eigenvalue greater than 
# the mean eigenvalue (called the 
# Kaiser-Guttman criterion).

# Visualise by adding to the above plot 
# like this:

abline(h = mean(ev), col = "red")
legend("topright", "Average eigenvalue", 
       lwd = 1, col = "red", bty = "n")

# Here we would use the first three axes 
# also obtained by:

ev[ev > mean(ev)]

# Finally we could use what is known as the 
# broken stick model:

# This is included because I thought Kevin 
# might like it.

# This is based on randomly dividing a 
# stick into the same number of axes as 
# there are pca axes in our analyses.  
# Then we plot the the percentage of 
# variance explianed by our axes against 
# that explained by the random breaking of 
# the stick into the same number of parts.

# (The theoretical equation for this 
# breaking of sticks randomly is known 
# and that's what I have below but you 
# could make some kind of random model 
# of stick breaking if you wanted to!) 
# (from Bocard et al.,2011)  

n <- length(ev)
bsm <- data.frame(j = seq(1:n), 
                  p = 0)
bsm$p[1] <- 1/n 

for (i in 2:n) {
  bsm$p[i] <- bsm$p[i-1] + (1/(n + 1 - i))
} 

bsm$p <- 100*bsm$p/n
bsm

barplot(t(cbind(100*ev/sum(ev), 
                bsm$p[n:1])), 
        beside = TRUE, main = "% variance", 
        las = 2)

# Here we would choose only the first axis.

# The thing you are most likely to need to 
# keep is the PCA scores for each axis this 
# is what you might use in further analysis 
# (e.g. GLM's etc.)


sum1 <- summary(pca_chem)

str(sum1)


# Your new variables (the axes) are 
# stored in sum1$sites


pca_axes <- sum1$sites

pca_axes[,1]

# write the results
write.table(pca_axes, "axes.csv", 
            sep = ",") 


# Having choosen our optimal number 
# of axes we may want to know how these 
# correlate with our original variables 
# so that we can describe them in our methods.  
# (Alternatively you could use the raw 
# species scores for each axis, but for 
# some reason people like to describe 
# the correlations)

# This is done by using the function 
# "cor" to look at the correlation
# between the site values on each axis 
# and the chemical varibles (i.e. the 
# site score represents the value of 
# that axis at each site, therefore we 
# can use these values to estimate the 
# correlation with the chemistry variables 
# for which we also have values at each site)

cor_pca <- cor(sum1$sites[,1:3], 
               chem)
cor_pca

# and we might export this as a table..
write.table(cor_pca, "cor_values.csv", 
            sep = ",") 



# Correspondence analysis
# from Bocard et al. 2011

fish <- read.csv("DoubsSpe.csv")
summary(fish)

spe.ca <- cca(fish)

summary(spe.ca) # default 
                # scaling = 2

# Eigenvalues are interpreted in 
# the same way as for PCA. 

# Scaling = 1 - distances between 
# sites are preserved

# Scaling = 2 - angles between 
# species are preserved


ev2 <- spe.ca$CA$eig
plot(ev2)

# plot eigenvalues same as plot of PCA
barplot(ev2, main = "Eigenvalues", 
        col = "grey", las = 2)
abline(h = mean(ev2), col = "red")
legend("topright", "Average eigenvalue", 
       lwd = 1, col = "red", bty = "n")

# note strong first axis...

plot(spe.ca, choices = c(1:2), 
     scaling = 1, display = "sites")
plot(spe.ca, choices = c(1:2), 
     scaling = 2, display = "species")

plot(spe.ca)

# Using CA to answer a question.. 

# Now we want CCA - Canonical 
# Correspondence Analysis

# The key difference between 
# CA an CCA is that CCA explains 
# variation in species communities 
# relative to environmental variables. 

rm(list=ls(all=TRUE)) # WARNING!!!!!!

library("vegan")

pca_chem <- read.table("axes.csv", 
                       sep = ",", 
                       header = TRUE)
summary(pca_chem)


pca_fin <- pca_chem[,1:3]


p1 <- read.table("bryos_final3.csv", 
                 sep = ",", 
                 header = TRUE)
p2 <- cbind(p1,pca_fin)
names(p2)

#####################################

spe <- p2[,7:36]
names(spe)
ncol(spe)
length(spe)

#
summary(rowSums(spe))

# row sums must be greater than 
# 0 to run a CCA.  
# Add a small constant to each row.

nrow(spe)
spe$x <- rep(0.1,122)
 

cca1 <- cca(spe ~ Habitat*Burnt + 
              date2 + altitude 
            + PC1 + PC2 + PC3, 
            data = p2)

summary(cca1)
plot(cca1)
summary(cca1)

# Assessing significance of 
# fitted model

# Here the function anova is 
# actually doing a permutation 
# based test.  

# Here is it swopping species 
# abundances between rows of the 
# dataframe (quadrats), to see 
# how likely it is to get a random 
# combination of quadrats that are 
# this different from each other.


anova(cca1, perm = 9999)

# Sometimes it is more appropriate 
# to constrain the permutations
# within a level of the data.  
# We use the arguement "strata" to 
# do this.

# Here species combinations should 
# only really be permuted within site.

anova(cca1, perm = 9999, 
      strata = p1$Site)

# Note  you will note always get exactly 
# the same p value.  

# The higher you set the permutations 
# the more reproducable the p value
# will be.

# To find the significance of individual 
# model terms we can use the argument 
# by = "margin.

anova(cca1, by = "margin",
      perm = 9999, 
      strata = p1$Site)

# This takes a little longer as 
# these are Type III errors 
# (i.e. calculated repeatedly with 
# each term last in the model)

# Conceptually the cca is similar 
# to a GLM in that we can fit many 
# explanatory variables of different 
# types.  

# But what if we want to fit the 
# equivalent of a GLMM with a random
# factor? This is called a partial CCA.

# Here we fit the random factor using 
# the "condition" argument of the CCA.

cca2 <- cca(spe ~ Habitat*Burnt + date2 + 
              altitude + PC1 + PC2 + PC3, 
            condition = Site, data = p2)


# Model selection...  

# In the above model we can see that 
# some of our explanatory factors are 
# not significant.  
# We can use the ordistep function to 
# do forward stepwise selection of 
# variables.  

anova(cca2, by = "margin", 
      perm = 9999, 
      strata = p1$Site)

modx <- ordistep(cca(spe~1, 
                     condition = Site, 
                     data = p2),
                 scope = formula(cca2), 
                 direction = "forward")

formula(modx)
drop1(modx)

formula(modx)

summary(modx)

anova(modx, perm = 9999, 
      by = "margin", 
      strata = p2$Site)

##################################################################

# Kevin K-means

#  plot1
# make up data
x <- c(rnorm(500, mean = 2, sd = 3), 
       rnorm(500, mean = 20, sd = 3))
y <- x + (10 + rnorm(1000, sd = 10))

mydata2d <- data.frame(x = x, y = y)

# plot the data
plot(mydata2d, type = "p", col = "green", pch = 16)

# add random points

points(x = c(0, 20), y = c(50, -10), col = c("black", "red"),
       pch = 3, cex = 5)

# colour code points
firstx <- lapply(c(0, 20), function(x){
  (x - mydata2d[,1])^2
})

firsty <- lapply(c(55, -10), function(x){
  (x - mydata2d[,2])^2
})

firstx <- do.call("cbind", firstx)
firsty <- do.call("cbind", firsty)
clust1 <- firstx[,1] + firsty[,1]
clust2 <- firstx[,2] + firsty[,2]
ref <- cbind(clust1, clust2)
clustAssigns <- apply(ref, 1, function(x){
  return(which(x == min(x)))
})

### plot 2

plot(mydata2d, type = "n")

# add random points

points(x = c(0, 20), y = c(50, -10), col = c("black", "red"),
       pch = 3, cex = 5)

points(mydata2d, col = clustAssigns,
       pch = 16, cex = 1)

# plot 3
xpoints <- c(mean(mydata2d[which(clustAssigns == 1), 1]),
             mean(mydata2d[which(clustAssigns == 2), 1]))

ypoints <- c(mean(mydata2d[which(clustAssigns == 1), 2]),
             mean(mydata2d[which(clustAssigns == 2), 2]))

# new plots
plot(mydata2d, type = "n")

# add random points

points(x = xpoints, y = ypoints, col = c("black", "red"),
       pch = 3, cex = 5)

### Plot 4

# new plots
plot(mydata2d, type = "n")

# add random points

points(x = xpoints, y = ypoints, col = c("black", "red"),
       pch = 3, cex = 5)

# redefine groups
points(mydata2d, col = clustAssigns,
       pch = 16, cex = 1)

# colour code points
firstx <- lapply(xpoints, function(x){
  (x - mydata2d[,1])^2
})

firsty <- lapply(ypoints, function(x){
  (x - mydata2d[,2])^2
})

firstx <- do.call("cbind", firstx)
firsty <- do.call("cbind", firsty)
clust1 <- firstx[,1] + firsty[,1]
clust2 <- firstx[,2] + firsty[,2]
ref <- cbind(clust1, clust2)
clustAssigns <- apply(ref, 1, function(x){
  return(which(x == min(x)))
})

xpoints <- c(mean(mydata2d[which(clustAssigns == 1), 1]),
             mean(mydata2d[which(clustAssigns == 2), 1]))

ypoints <- c(mean(mydata2d[which(clustAssigns == 1), 2]),
             mean(mydata2d[which(clustAssigns == 2), 2]))

# new plots
plot(mydata2d, type = "n")

# add random points

points(x = xpoints, y = ypoints, col = c("black", "red"),
       pch = 3, cex = 5)

# redefine groups
# colour code points
firstx <- lapply(xpoints, function(x){
  (x - mydata2d[,1])^2
})

firsty <- lapply(ypoints, function(x){
  (x - mydata2d[,2])^2
})

firstx <- do.call("cbind", firstx)
firsty <- do.call("cbind", firsty)
clust1 <- firstx[,1] + firsty[,1]
clust2 <- firstx[,2] + firsty[,2]
ref <- cbind(clust1, clust2)
clustAssigns <- apply(ref, 1, function(x){
  return(which(x == min(x)))
})

# new plots
plot(mydata2d, type = "n")

# add random points

points(x = xpoints, y = ypoints, col = c("black", "red"),
       pch = 3, cex = 3)

points(mydata2d, col = clustAssigns,
       pch = 16, cex = 1)

xpoints <- c(mean(mydata2d[which(clustAssigns == 1), 1]),
             mean(mydata2d[which(clustAssigns == 2), 1]))

ypoints <- c(mean(mydata2d[which(clustAssigns == 1), 2]),
             mean(mydata2d[which(clustAssigns == 2), 2]))

# new plots
plot(mydata2d, type = "n")

# add random points

points(x = xpoints, y = ypoints, col = c("black", "red"),
       pch = 3, cex = 5)

# redefine groups
# colour code points
firstx <- lapply(xpoints, function(x){
  (x - mydata2d[,1])^2
})

firsty <- lapply(ypoints, function(x){
  (x - mydata2d[,2])^2
})

firstx <- do.call("cbind", firstx)
firsty <- do.call("cbind", firsty)
clust1 <- firstx[,1] + firsty[,1]
clust2 <- firstx[,2] + firsty[,2]
ref <- cbind(clust1, clust2)
clustAssigns <- apply(ref, 1, function(x){
  return(which(x == min(x)))
})

# new plots
plot(mydata2d, type = "n")

# add random points

points(x = xpoints, y = ypoints, col = c("black", "red"),
       pch = 3, cex = 5)

points(mydata2d, col = clustAssigns,
       pch = 16, cex = 1)

### END

# 3d plotting
install.packages("scatterplot3d")
library("scatterplot3d")

var1 <- lapply(1:5, function(i){
  if (i == 1){
    i <- 10
  }
  rnorm(20, mean = i/(0.5), sd = 1)
})

var2 <- lapply(var1, function(x){
  x + (rnorm(length(x), mean = sum(x), sd = 10))
})

var3 <- lapply(var1, function(x){
  x - (rnorm(length(x), mean = sum(x), sd = 1))
})

# turn the vars into a dataframe
mydata <- data.frame(var1 = unlist(var1), var2 = unlist(var2),
                     var3 = unlist(var3))

# plot centroids
xmeans <- sapply(var1, mean)
ymeans <- sapply(var2, mean)
zmeans <- sapply(var3, mean)

scatterplot3d(x = xmeans, y = ymeans, z = zmeans, pch = 16,
              cex.symbols = 2)

plot3d <- scatterplot3d(x = xmeans, y = ymeans, z = zmeans, pch = 16,
                        cex.symbols = 2)

plot3d$points3d(x = mydata$var1, y = mydata$var2, z = mydata$var3, 
                col = "red")

# mydata is a dataframe
# test for k = 1:15
set.seed(10)
wsskk <- sapply(1:15, function(i){
  return(sum(kmeans(mydata, centers = i,
                    iter.max = 10000)$withinss))
})

plot(1:15, wsskk, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

abline(v = 5, col = "red")

### END

# US Map plotting

# Read galaxy data
us_data <- read.delim("us_data.txt", header = TRUE)
set.seed(962520851)
usSS <- sapply(1:20, function(i){
  return(sum(kmeans(us_data[,-1], centers = i,
                    iter.max = 10000)$withinss))
})

plot(1:20, usSS, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

usK <- kmeans(us_data[,-1], centers = 5, iter.max = 10000)


# Try plotting a map
install.packages(c("maps", "ggplot2"))
library("maps")
library("ggplot2")

# create a vector for colours
clust <- usK$cluster
names(clust) <- toupper(us_data[,1])

# load US state data
states <- map_data("state")

clust_assign <- apply(states, 1, function(x){
  return(clust[toupper(x[5])])
})


# plot the states
#plot all states with ggplot
p <- ggplot()
p <- p + geom_polygon(data = states, aes(x = long, y = lat, group = group),
                      colour = "white", 
                      fill = gray(1/clust_assign))
p