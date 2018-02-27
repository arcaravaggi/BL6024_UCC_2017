### Solutions for BL6024 Lessons 1-2 CA 
#
# Note that I have only used the functions and packages described in Lessons 1 & 2. There are
# a number of different ways of completing these tasks

# Set working directory appropriately
setwd("C:/Users/Anthony Caravaggi/Dropbox/GitHub/BL6024_UCC_2017/Lecture 02/assets/img") 

# Load data and view head
mDat<- read.csv("mDat.csv") 
head(mDat)

### Task 1
# Extract the 5th - 9th columns for the following genera and derive the mean, median and 
# standard deviation for each column in the resultant dataframe: 
# *Antilocapra*, *Budorcas*, *Connochaetes*, *Panthera*, *Macaca*, *Ursus*
#
# First, subset the data by the required genera. There are any ways to subset; here I'm using
# a method which I didn't go into in detail but which was included in Lesson 2
genDat <- subset(mDat, mDat$genus %in% c("Antilocapra", "Budorcas", "Connochaetes",
                                        "Panthera", "Macaca", "Ursus"))

# Check the head and structure of the resulting dataframe
head(genDat)
str(genDat)

# You will have noticed that there are a number of NAs in the dataset. While you can use
# summary() to derive a number of the required statistics as it ignores fields with NA, the function
# does not include standard deviation. For that, you would need to do a bit of troubleshooting and work
# your way around the NA issue. Some of you didn't do this, and removed all rows with NA before deriving
# the statistics. This meant that when you removed an NA in column C, you may have removed useful data in 
# columns A, B, and D. You have to be careful that your manipulations for one estimate do not affect
# your other analyses. 
# 
# I have provided a solution for one of the columns, below. The same approach would be repeated for each.
# A little troubleshooting shows that NAs can be ignored for mean, median and sd functions
# using the argument na.rm = T.
mean_fmat <- mean(genDat$f_maturity, na.rm=T) 
median_fmat <- median(genDat$f_maturity, na.rm=T) 
sd_fmat <- sd(gen.Dat$f_maturity, na.rm=T) 

# You can also store these results in a dataframe. For example:
# Initialise a dataframe with empty vectors
df <- data.frame(mean = numeric(),
                 median = numeric(), 
                 sd = numeric(),
                 stringsAsFactors=FALSE) 

# Pass results to cells within dataframe
df[1,1] <- mean(genDat$f_maturity, na.rm=T) 
df[1,2] <- median(genDat$f_maturity, na.rm=T) 
df[1,3] <- sd(genDat$f_maturity, na.rm=T) 

head(df)


#### Task 2
# What is the mean `gestation` length for each Order?
#
# Here I use code lifted from Lesson 1, adding the na.rm argument.
mean_gest <- by(mDat, mDat$order, function(x) {mean.w <- mean(x$gestation, na.rm=T)}) 


#### Task 3
#
# - Test the following taxa for normality and outliers: Cercopithecidae 
# (columns = `gestation`, `b_weight`);  Bovidae (`longevity_yr`, `a_weight`)
#
# Subset for a Family
cerco <- subset(mDat, mDat$family %in% c("Cercopithecidae"))

# Draw Q-Q plots to visually assess normality/outliers
qqnorm(cerco$gestation); qqline(cerco$gestation, col=2) 

# Use a Shapiro-Wilk test to numerically assess normality: very very normal
shapiro.test(cerco$gestation) 

# Draw a histogram with a density curve
hist(cerco$gestation, prob=T) 
lines(density(cerco$gestation, adjust=2, na.rm=T), col="blue", lwd=2)
plot(cerco$gestation, cDat$b_weight) 

# No extensive skew evident and data are normal - nothing to be removed.

# And the same for Bovidae

bovid <- subset(mDat, mDat$family %in% c("Bovidae"))
qqnorm(bovid$b_weight); qqline(bovid$b_weight, col=2)
shapiro.test(bovid$b_weight)
hist(bovid$b_weight, prob=T) 
lines(density(bovid$b_weight, adjust=2, na.rm=T), col="blue", lwd=2)
plot(bovid$b_weight, bovid$gestation)

# Data are highly skewed, with a number of outliers with high weights  

#### Task 4
#
# Produce a histogram with density curve based on the Carnivora
#
# subset Carnivora
carniv <- mDat[mDat$order=="Carnivora",]
hist(carniv$longevity_yr, prob=T)
lines(density(carniv$longevity_yr, adjust = 2, na.rm = T), col="green", lwd=3)

#### Task 5
#
# Produce a scatterplot with a line of fit of `a_weight` by 
# `longevity_yr` for the Mustelidae and Viverridae, combined
#
# Subset focal families
mustviv<- subset(mDat, mDat$family %in% c("Mustelidae", "Viverridae"))

# Create a linear model for the line of fit  
mv.lm <- lm(mustviv$longevity_yr ~ mustviv$a_weight) 

# Draw the scatterplot with the line of best fit
plot(mustviv$a_weight, mustviv$longevity_yr, xlab="Weight", ylab="Longevity")
abline(mv.lm, lty=1, lwd=2, col="lightgreen")

#### Task 6
#
# Produce one plot using ggplot, including manipulating labels and aesthetics
# 
# Load the ggplot2 package
library(ggplot2)

# You could, of course, use any data here. I used the mustviv dataframe generated, earlier
ggplot(mustviv, aes(gestation, litter_size, colour=family)) +
  geom_point() + 
  labs(x="Gestation period (days)", y="Litter size", colour="Order") +
  theme_classic() + 
  theme(legend.position = c(0.9,0.75)) #put legend inside graph

# We're getting NA warnings. I'm not overly worried - I know ggplot ignores NAs
# and generates errors. But maybe I don't want to worry about errors. Adding na.exclude
# wrappers into ggplot can be a bit fiddly, so I just remove all NAs from the dataframe
# and use the thinned data to draw the plot
mustviv_thin <- na.omit(mustviv)

ggplot(mustviv_thin, aes(gestation, litter_size, colour=family)) +
  geom_point() + 
  labs(x="Gestation period (days)", y="Litter size", colour="Order") +
  theme_classic() + 
  theme(legend.position = c(0.9,0.75)) 
