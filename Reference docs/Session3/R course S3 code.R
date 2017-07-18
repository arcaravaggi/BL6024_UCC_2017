## Session 3 ---- main


## read morph data
morph <- read.table("Morph.txt", header = TRUE, 
                    na.string = "?")

names(morph)<- c("G", "Col", "H", "L_H", "L_F")

## Check everything is as it should be:
str(morph)
summary(morph)

##

## 1-sample t test ----

## The average height of women 
## in the UK is about 64" (Yahoo Answers!)
## Is the height of the women on the course 
## significantly different?

## Firstly, what is the mean height of the 
## women on this course?
summary(morph$H[morph$G == "F"])

## A t-test relies on the assumption of 
## normal distribution of data under the 
## normal hypothesis.

## Visual inspection if normality
## Normal Q-Q plot
qqnorm(morph$H[morph$G == "F"])
qqline(morph$H[morph$G == "F"])


## Now we can conduct a formal normality 
## test (using the Shapiro-Wilk test)
shapiro.test(morph$H[morph$G == "F"])

t.test(morph$H[morph$G =="F"], mu = 64, 
        alternative = "two.sided")



# Males
shapiro.test(morph$H[morph$G == "M"])

####################################

# Visual insection of sample variance
plot(morph$H ~ morph$G)

# ?boxplot

# F test to compare two variances
bartlett.test(morph$H, morph$G)
# bartlett.test(H ~ G, data = morph)
?var.test

## (Guess what the name of the appropriate 
## function is...)

?t.test

# Welch Two Sample t-test (Independent sample)
t.test(morph$H[morph$G == "F"], 
       morph$H[morph$G == "M"], 
       alternative = "two.sided")

t.test(H~G, data = morph, 
       alternative = "two.sided")


# One sample t-test
t.test(morph$H[morph$G == "F"],  mu = 64, 
       alternative = "two.sided")


## Paired t test ----

## Use lakedata.txt for this example
## This is a eutrophic lake system with 
## 40 sampling points. 
## The lake was very polluted with run-off 
## from adjacent pasture land, and there was 
## a problem with high amounts of algae 
## clouding the water.  
##
## New legislation controls fertiliser 
## application near the lake shore.
## Data was collected to test if this new
## legislation affected algal biovolume 
## between year1 and year3 (before and after)



lakedata <- read.table("lakedata.txt", 
                       header = TRUE)

## Check data format
str(lakedata)


## TransectID appears as an integer but should 
## be a factor so..

## fix
lakedata$TransectID <- factor(lakedata$TransectID)

# inspect data
str(lakedata)


## normality tests

# visual
par(mfrow = c(1, 2))  # adjust plotting env
qqnorm(lakedata$yr1, main = "yr1-QQ-plot")
qqline(lakedata$yr1)

qqnorm(lakedata$yr3, main = "yr3-QQ-plot")
qqline(lakedata$yr3)

# formal test
shapiro.test(lakedata$yr1)
shapiro.test(lakedata$yr3)

# variance test
year <-as.factor(rep(c("yr1","yr3"), 
                     each = nrow(lakedata)))

alg <- c(lakedata$yr1, lakedata$yr3)

bartlett.test(alg ~ year)

# the easy way (for two samples only)
var.test(lakedata$yr1, lakedata$yr3)

# Paired t-test
t.test(lakedata$yr1, lakedata$yr3, 
       paired = TRUE, 
       alternative = "greater")

# Conclusion: there is a reduction in 
# algal biovolume (Yay! policy worked)

# set par(mfrow) back to 1 by 1
par(mfrow = c(1,1))

########################
## 2-sample t test ----

## How can we test whether the height of the 
## males is greater than that of the females? 
## (i.e. a 'one-tailed' test, in which we're 
## hypothesising about the direction of the 
## effect, whereas in our first, 'two-tailed' 
## test, we were just testing if there was a 
## difference and not interested in its 
## direction.)

## You might want to explore data with a 
## boxplot first (we did this last week!). 
## Is the pattern as expected? 
## (we don't mean the dress!!)

boxplot(morph$H ~ morph$G, notch = TRUE, 
        col = c("blue", "pink"))

## We can get values for the mean and sd 
## of height, by gender:

# Mean
tapply(morph$H, morph$G, mean)

# SD
tapply(morph$H, morph$G, sd)


# We can plot these values very easily
gendMean <- tapply(morph$H, morph$G, mean)
gendSD <- tapply(morph$H, morph$G, sd)

# draw the plot
bp <- barplot(gendMean, 
              ylim = c(0, (max(gendMean) + 20)), 
              xlab = "gender", ylab = "Height", 
              col = c("blue", "pink"), 
              main = "Gender differences \n 
                      in height")

# draw a box around the plot
box()

# Draw the error bars
arrows(x0 = bp, y0 = (gendMean - gendSD), 
       x1 = bp, y1 = (gendMean + gendSD),
       angle = 90, lwd = 2, code = 3, 
       length = 0.15)



## Again, we should check the normality 
## of our two samples (we did it already 
## for females, so just for the males this time).

## Normal Q-Q plot (visual)
qqnorm(morph$H[morph$G == "M"])
qqline(morph$H[morph$G == "M"])

## Shapiro-Wilk test (formal)
shapiro.test(morph$H[morph$G == "M"])

# t-test (ask if F height is 'less' than M height)
t.test(morph$H[morph$G == "F"], 
       morph$H[morph$G == "M"], 
       alternative = "less")

## OR formula interface (less typing):
t.test(H ~ G, data = morph, 
       alternative = "less")

## If we weren't hypothesising about the 
## direction of the difference in height 
## between males and females, and just wanted 
## to test whether there was a difference, 
## we would use:
t.test(H ~ G, data = morph, 
       alternative = "two.sided")



## 1-way ANOVA ----

# DISCLAIMER: Almost none of the following 
# is true 

## Following the recent horsemeatmageddon in 
## many well known supermarkets, researchers 
## at the Institute of Libelous Research (ILR), 
## were interested in the relationship between 
## putative horsemeat consumption and IQ. 
## The researchers developed the hypothesis 
## that 'IQ is negatively associated with 
## horsemeat consumption', on the premis that 
## horsemeat is known to contain high levels of 
## the neuro-toxic metal lead (lead 
## content in horses is interestingly 
## negatively associted with likelyhood to win 
## the Grand National)
## The authors of this research have kindly 
## provided us with a preview of their data. 
## (The names of parties involved have been 
## changed to protect the quilty).

# read the data
shopData <- read.table("shopIQ.txt", 
                       header = TRUE) 

# visual inspection
plot(shopData$IQ ~ shopData$shop,
     las = 2, xlab = "", 
     col = c("green", "brown", "darkorange",
             "darkgreen", "blue"))

# ANOVA

mod1 <- aov(IQ ~ shop, data = shopData)


## Checking the test assumptions:

par(mfrow=c(2,3))
plot(mod1)
hist(mod1$residuals) # adds a histogram of 
                     # residuals...

## To assess the normality of our residuals 
## more formally, we can use the Shapiro-Wilk 
## test (as we did above):

# normality
shapiro.test(mod1$residuals)

# variance (can't use var.test)
bartlett.test(IQ ~ shop, data = shopData)

## After examining the plots and the results 
## of the tests, we can conclude that there is 
## no significant departure from normality or 
## homogeneous distribution of variance, 
## and so we may proceed to examine the 
## results of the ANOVA:

anova(mod1)

## How should we interpret these results?

## If there is a significant difference, 
## then we can go on to examine where the 
## differences among categories lie, using 
## post-hoc tests (e.g. Tukey's HSD test)

# Honest significance test (adjusted p-vals)
TukeyHSD(mod1)

############## END #######################

