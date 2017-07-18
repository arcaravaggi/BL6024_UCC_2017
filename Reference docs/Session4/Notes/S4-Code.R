##############################
##                          ##
## introduction to R course ##
##      R-peer-group        ##
##       Session 4          ##
##                          ##
##############################


##############################
##                          ##
##   Pearson Correlation    ##
##                          ##
##############################

# Insulin sensitivity
# From Borkman et al. 1993

# Insulin sensitivity (i.e. the rate of glucose uptake to muscles
# as a direct result of blood insulin levels) is extremely variable
# in healthy individuals. To understand this, Borkman et al., (1993) 
# hypothesised that insulin sensitivity was affected by fatty acid
# content of the cell membrane of skeletal muscle. This hypothesis
# was based on the fact that insulin promotes the uptake of glucose
# by these cell through the membrane. We will look at some of the data
# collected.

# read the data
insData <- read.table("insulin.txt", header = TRUE)

# check the data
str(insData)

# summarise the data
summary(insData)

# adjust the variable names
names(insData) <- c("subs", "ins", "fa")

# plot the data
plot(insData$fa, insData$ins)

# Some simple plot customisations
?par
?plot

# 1) Add axis labels

plot(insData$fa, insData$ins, ylab = "Insulin sensitivity",
     xlab = "Cell membrane fatty acid content")

# 2) Change the label axis style

plot(insData$fa, insData$ins, ylab = "Insulin sensitivity",
     xlab = "Cell membrane fatty acid content", las = 1)

# 3) Add a plot title

plot(insData$fa, insData$ins, ylab = "Insulin sensitivity",
     xlab = "Cell membrane fatty acid content", las = 1,
     main = "Insulin sensitivity vs cell \n membrane fatty acid content")

# 4) Change the scale of the axes

plot(insData$fa, insData$ins, ylab = "Insulin sensitivity",
     xlab = "Cell membrane fatty acid content", las = 1,
     main = "Insulin sensitivity vs cell \n membrane fatty acid content",
     xlim = c(0, max(insData$fa)), ylim = c(0, max(insData$ins)))

# 5) Change it back

plot(insData$fa, insData$ins, ylab = "Insulin sensitivity",
     xlab = "Cell membrane fatty acid content", las = 1,
     main = "Insulin sensitivity vs cell \n membrane fatty acid content")

# 6) Change the point appearance

plot(insData$fa, insData$ins, ylab = "Insulin sensitivity",
     xlab = "Cell membrane fatty acid content", las = 1,
     main = "Insulin sensitivity vs cell \n membrane fatty acid content",
     pch = 16, col = "blue")

# 7) Change the title text colour

plot(insData$fa, insData$ins, ylab = "Insulin sensitivity",
     xlab = "Cell membrane fatty acid content", las = 1,
     main = "Insulin sensitivity vs cell \n membrane fatty acid content",
     pch = 16, col = "blue", col.main = "brown")

# 8) Change some fonts

plot(insData$fa, insData$ins, ylab = "Insulin sensitivity",
     xlab = "Cell membrane fatty acid content", las = 1,
     main = "Insulin sensitivity vs cell \n membrane fatty acid content",
     pch = 16, col = "blue", col.main = "brown", font.main = 2, 
     font.lab = 3)

# 9) Add a legend

plot(insData$fa, insData$ins, ylab = "Insulin sensitivity",
     xlab = "Cell membrane fatty acid content", las = 1,
     main = "Insulin sensitivity vs cell \n membrane fatty acid content",
     pch = 16, col = rainbow(length(insData$ins)), col.main = "brown", 
     font.main = 2, font.lab = 3)
legend(locator(1), levels(insData$subs), pch = 16, 
       col = rainbow(length(insData$ins)), bty = "n")

# 10) Adding a formula to the axis labels

par(mar = c(5,5,4,4))
plot(insData$fa, insData$ins, xlab = "Cell membrane fatty acid content", 
     las = 1, ylab = expression("Insulin sensitivity (MG / M"^2*" / MIN)"),
     main = "Insulin sensitivity vs cell \n membrane fatty acid content",
     pch = 16, col = rainbow(length(insData$ins)), col.main = "brown", 
     font.main = 2, font.lab = 3)
text(x = insData$fa, y = insData$ins, labels = levels(insData$subs),
     pos = 1, cex = 0.7)


# Some correlation functions
# normality test
shapiro.test(insData$ins)
shapiro.test(insData$fa)

#Pearson correlation
cor(insData$ins, insData$fa, method = "pearson")

# significance test
# assumes normality

# correlation test
corTest <- cor.test(insData$ins, insData$fa, method = "pearson")

# results
print(corTest)

# add cor.test results to plot
plot(insData$fa, insData$ins, ylab = "Insulin sensitivity",
     xlab = "Cell membrane fatty acid content", las = 1,
     main = "Insulin sensitivity vs cell \n membrane fatty acid content",
     pch = 16, col = "blue", col.main = "brown", font.main = 2, 
     font.lab = 3)
text(locator(1), paste("r = ", round(corTest$estimate, 4), ":  p.value = ", 
                       round(corTest$p.value, 4), sep = ""))


##############################
##                          ##
##   Rank Correlation       ##
##                          ##
##############################

### A new government investment scheme has been suggested 
### which includes increased investment in amenity forestry.  
### This scheme will cost the tax payer approximately 
### £80,000,000 per annum.
### The scheme will improve access and facilities as forest parks 
### (e.g. parking, toilets, security, signage etc.) 
### and provide new jobs in rural areas 
### 
### We want to know how popular this investment would be and whether
### the response is correlated with whether people come from urban or 
### rural areas.  We have measured support for the scheme using a 7 point
### Likert scale  (i.e. Strongly disagree, disagree, somewhat disagree, 
### neither agree nor disagree, somewhat agree, agree, strongly agree)

fores <- read.table("forestry.txt", header = T)
str(fores)

fores$willing <- factor(fores$willing)
str(fores)
summary(fores)
# change names
levels(fores$willing) <-c("Stongly Disagree", 
                          "Disagree", 
                          "Somewhat Disagree",
                          "Ambivolent", 
                          "Somewhat Agree", 
                          "Agree", 
                          "Stongly Agree")  

#plot
par(mar = c(9,5,4,4))
plot(fores$willing, fores$dist_km, 
     col = rainbow(7), 
     main = "Support for investment", 
     ylab = "Distance of home from city", 
     xlab = "", las = 2)

hist(as.numeric(fores$willing))
median(as.numeric(fores$willing))
#### most people surveyed agree with the policy

######  test for corellation
cor(as.numeric(fores$willing), fores$dist_km, method = "spearman")

### there is a small positive correllation between distance
### from city and willingness to invest in amenity forestry

cor.test(as.numeric(fores$willing), fores$dist_km, method = "spearman")


### However, this correllation is not significant, therefore we must 
### conclude that there is no real correlation between distance from city 
### and support for this policy


##############################
##                          ##
##   Linear Regression      ##
##                          ##
##############################

# How old is the universe???

# The big bang model of the origin of the universe states that it expands 
# uniformly, and locally, according to Hubble's law: y = Bx
# y = the velocity of any two galaxies
# x = their distance of seperation
# B = Hubble's constant

# B^-1 gives the approximate age of the universe, but is unknown. Thus, it 
# must be estimated from known observations of y and x.

# This can be done using a linear regression

# read the data
uniData <- read.table("ageofuniverse.txt", header = TRUE)

# inspect the data
str(uniData)
summary(uniData)
 
# plot the data
# y is the response variable, while x is a predictor/explanitory variable
par(mar = c(5,5,4,4))
plot(uniData$y ~ uniData$x, 
     ylab = expression("velocity (kms"^{-1}*")"),
     xlab = "Mpc", las = 1, pch = 11, col = "gold")

# Using the function 'lm' we can fit a linear model to the data (least square)

uni.mod <- lm(y ~ x-1, data = uniData) # -1 indicates that the model has no
                                       # intercept term

# We can summarise the model results using the summary function

summary(uni.mod)

# we can access the estimated B term form the model as follows

uni.mod$coefficient

# Before using the estimated terms, it is important to check some assumptions

# Are the error terms of the model independent and of equal 
# variance (residuals)

# we can visualise the residuals of the model against the fitted values
plot(uni.mod)
plot(uni.mod$fitted, uni.mod$residuals, xlab = "fitted",
     ylab = "residuals", las = 1, main = "uni.mod")

abline(h = 0, lwd = 3, lty = 2, col = "red")

 
# shapiro
shapiro.test(uni.mod$residuals)

# The highlighted residual have quite high resuiduals relative to the others

points(uni.mod$fitted[c(3,15)], uni.mod$residuals[c(3,15)], col = "green", 
       pch = 16, cex = 2) 

# It is wise to check that they no not affect our results by removing them and
# re-running the regression

uni.mod1 <- lm(y ~ x-1, data = uniData[-c(3, 15), ])

# We can look at the new model summary
summary(uni.mod1)

# How has the B coefficient estimation changed
uni.mod$coefficient
uni.mod1$coefficient

# recheck the residuals of the new model

par(mfrow = c(1,2))
plot(uni.mod$fitted, uni.mod$residuals, xlab = "fitted",
     ylab = "residuals", las = 1, main = "uni.mod", ylim = c(-600,600))
abline(h = 0, lwd = 3, lty = 2, col = "red")
plot(fitted(uni.mod1), residuals(uni.mod1), xlab = "fitted",
     ylab = "residuals", las = 1, main = "uni.mod1", ylim = c(-600,600))
abline(h = 0, lwd = 3, lty = 2, col = "red")
# By removing the outliers the residuals have improved and B has changed
# This is probably the best model

# We can now proceed to calculate the age of the universe with some adjustments
# for units

# Hubble's constant = (km)s^-1 (Mps)^-1
# One Mps = 3.09x10^19 km

# To calculate Hubble's constant in seconds^-1 we must divide our estimates by
# Mps in km.

hub.const <- c(uni.mod$coefficient, uni.mod1$coefficient)/3.09e19

# the age of the universe in seconds is the inverse of these values

age.sec <- 1/hub.const

print(age.sec)

# to find the age in years we need to divide by the number of seconds in a year

age.year <- (age.sec / (60*60*24*365.25))                                                       * 4.7e-7

#And the age of the universe is ............

paste(round(age.year, 0), " years old", sep = "")

age.year <- (age.sec / (60*60*24*365.25))

paste(round(age.year/1e9, 2), " billion years old", sep = "")

# plot data with a fitted line
par(mar = c(5,5,4,4),
    mfrow = c(1,1))
plot(uniData$y ~ uniData$x, 
     ylab = expression("velocity (kms"^{-1}*")"),
     xlab = "Mpc", las = 1, pch = 11, col = "gold",
     xlim = c(0, 25))
abline(lm(y~x, data = uniData), col = "red", lwd = 2)
text(locator(1), expression("r"^2*" = 0.939: pvalue = 0.000"))

# we can use the predict function to estimate the error associated with
# out model (e.g. 95% confidence intervals)

predicted <- predict(uni.mod, se.fit = TRUE)

fit <- 1:24 * uni.mod$coefficient

se <- predicted$se.fit

# calculate the lower ci
lci <- spline(fit - (1.96*se))  # smooth lines
uci <- spline(fit + (1.96*se))

#plot confidence intervals
par(mar = c(5,5,4,4))
plot(uniData$y ~ uniData$x, 
     ylab = expression("velocity (kms"^{-1}*")"),
     xlab = "Mpc", las = 1, pch = 11, col = "gold",
     xlim = c(0, 25), type = "n")
polygon(x = c(uci[[1]], rev(lci[[1]])), y = c(uci[[2]], rev(lci[[2]])), col = "lightgrey",
        border = NA) 
abline(lm(y~x, data = uniData), col = "red", lwd = 2)
points(uniData$x, uniData$y, pch = 11, col = "gold")