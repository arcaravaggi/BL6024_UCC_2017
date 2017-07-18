# GLM with continous response 
# varible

# load dataset

chem <- read.csv("chem_example.csv")

# This dataset contains data on soil 
# chemistry for quadrats within 6 sites. 
# The variable of interest is burning, 
# in particular it's effect on soil 
# chemistry


names(chem)
str(chem)
summary(chem)

# Let's look at P - Phosphorus

summary(chem$P)

# Note all positive and continous
hist(chem$P)

# an optimist fits a normal model first.. 

mod_norm <- glm(P ~ Burnt * Habitat + Site, 
                data = chem)

# plot residuals
hist(residuals(mod_norm))

# formal normality test
shapiro.test(residuals(mod_norm))


# p-value < 0.05 therefore not normal...

plot(mod_norm)

# Try a gamma distribution with a 
# log link

mod_log <- glm(P ~ Burnt * Habitat + Site, 
               data = chem, 
               family = "Gamma"(link = "log"))

# plot

plot(mod_log)

res1 <- residuals(mod_log, 
                  type = "deviance")

# plot residuals
hist(res1)

# test residuals
shapiro.test(res1)

summary(mod_log)

# load car package to use Anova
library("car")
Anova(mod_log, type = "III")

# GLM with count data ----

# First example: Australian amphibian 
# roadkill, (ARR) from Zuur et al. 2009

AAR <- read.table("RoadKills.txt", 
                  header = TRUE)

# Standard data exploration
names(AAR)
str(AAR)
summary(AAR)

hist(AAR$TOT.N)
class(AAR$TOT.N)
summary(AAR$TOT.N)
plot(AAR$TOT.N)

# Poisson model as a starting point 
# for count data (integers/positive)

mod_ARR <- glm(TOT.N ~ D.PARK, 
               data = AAR, 
               family = "poisson"(link = "log"))

summary(mod_ARR)

theta <- mod_ARR$deviance/mod_ARR$df.residual
theta

# check number of zeros in dataset

length(which(AAR$TOT.N == 0))

# rule of thumb for this is: 
# we want theta = 1, 
# theta < 2 is okay,  
# theta >2 and <15 try 
# quassipoisson, 
# theta > 15 try 
# negative binomial
# or if you prefer (as I do) 
# go straight to negative 
# binomial at theta > 2

hist(AAR$TOT.N, breaks = 20)

# function for negative binomial is glm.nb 

?glm.nb

# note: there is no family specification
mod_nbin <- glm.nb(TOT.N ~ D.PARK, 
                   data = AAR) 

theta <- mod_nbin$deviance/mod_nbin$df.residual
theta

# negative binomial solves 
# our overdispersion problem...
plot(mod_nbin)

res2 <- residuals(mod_nbin, 
                  type = "deviance")
hist(res2)
shapiro.test(res2)

# residuals are okay...

summary(mod_nbin)

# a little plotting

pred_amph <- predict(mod_nbin, 
                     type = "response", 
                     se.fit = TRUE)
str(pred_amph)

# plot with standard error
plot(AAR$TOT.N~AAR$D.PARK, 
     ylab = "No. of roadkill", 
     xlab = "Distance from park")

# predicted line
lines(pred_ambh$fit~AAR$D.PARK, 
      type = "l", col = "red", lwd = 1.5)

# upper standard error
lines(pred_ambh$fit + 
        pred_ambh$se.fit ~ AAR$D.PARK, 
      type = "l", col = "blue", lwd = 1, 
      lty = 2)

# lower standard error
lines(pred_ambh$fit - 
        pred_ambh$se.fit ~ AAR$D.PARK, 
      type = "l", col = "blue", lwd = 1, 
      lty = 2)


# with 95% confidence
# upper confidence interval
lines(pred_ambh$fit + pred_ambh$se.fit * 1.96 ~ 
        AAR$D.PARK, type = "l", col = "black", 
      lwd = 1, lty = 3)

# lower confidence interval
lines(pred_ambh$fit - pred_ambh$se.fit * 1.96 ~ 
        AAR$D.PARK, type = "l", col = "black", 
      lwd = 1, lty = 3)

# Another count example (zero-inflation) -----

birds<- read.csv("birds.csv")

str(birds)
names(birds)
summary(birds)

hist(birds$MP, breaks = 10)
summary(birds$MP)

# Check for zeros
length(birds$MP)
length(which(birds$MP==0))


mp_mod <- glm(MP ~ Burnt * Habitat + Site, 
              data = birds, 
              family = "poisson"(link = "log"))

# check for overdispersion

theta <- mp_mod$deviance/mp_mod$df.residual
theta

# let's look at zero-inflation

hist(birds$MP)

summary(birds$MP)

# calculate the proportion
# of the data which are '0'
length(which(birds$MP==0))/length(birds$MP)


# try the model with no 0 data ....

mp_mod_2 <- glm(MP ~ Burnt * Habitat + Site, 
                data = birds[birds$MP != 0,], 
                family = "poisson"(link = "log"))


# overdispersion test

theta <- mp_mod_2$deviance/mp_mod_2$df.residual
theta

# zero inflation causes a large amount of 
# the over-dispersion, hence fit 
# Zeroinflated model

# load pscl
install.packages("pscl")
library("pscl")

ZAPmod <- hurdle(MP ~ Burnt * Habitat + 
                   Site|Burnt*Habitat + Site, 
                 data = birds, dist = "poisson", 
                 link = "logit")


# compare AIC with non-zeroaltered
AIC(ZAPmod)
AIC(mp_mod)

summary(ZAPmod)


# a presence absence example

# convert data from number of observations
# to presence (1) absence (0) format

birds$MP_PA <- birds$MP
birds$MP_PA[birds$MP_PA > 0] <- 1


# a presence absence model.. 


mp_mod_pa <- glm(MP_PA ~ Burnt * 
                   Habitat + Site, 
                 data = birds, 
                 family = "binomial"(link = "logit"))

mp_mod_pa

theta <- mp_mod_pa$deviance/mp_mod_pa$df.residual
theta

# rule of thumb is if theta > 1.5 
# try quassi-binomial

pred_PA <- predict(mp_mod_pa, 
                   type = "response", 
                   se.fit = TRUE)
plot(pred_PA$fit~birds$Habitat)

# END