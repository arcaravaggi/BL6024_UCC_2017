install.packages("lme4")
install.packages("car")
install.packages("multcomp")
install.packages("MuMIn")


library(lme4)

# Nested designs Hedgerows----

# This example dataset represents 
# a study into the effects of hedge 
# management on beetle abundance. 

# Three types of hedgerow management 
# were examined, namely: no management, 
# winter cutting only and intensive 
# management.
# Pitfall trapping was conducted to collect 
# beetles at five farms, and each farm 
# contained 6 hedges, 2 for each of the three 
# management types.  25 pitfall traps 
# were set within each hedge.

# Reason for nested GLMM 1 - Accounting for 
# pseudoreplication while examining an 
# explanatory factor/treatment

hedges <- read.csv("Hedges2.csv")
names(hedges)
summary(hedges)

par(mfrow =c(2,3))
hist(hedges$Beetles[hedges$Farm == "Bovys"], 
     main = "Bovys' farm")
hist(hedges$Beetles[hedges$Farm == "Kellys"], 
     main = "Kelly's farm")
hist(hedges$Beetles[hedges$Farm == "Keenans"], 
     main = "Keenan's farm")
hist(hedges$Beetles[hedges$Farm == "Ravinets"], 
     main = "Ravinet's farm")
hist(hedges$Beetles[hedges$Farm == "Emmersons"], 
     main = "Emmerson's farm")



model1 <- lmer(Beetles ~ Management + 
                 (1|Farm/Management/Hedge), 
               family = "poisson", data = hedges)
summary(model1)
model1

# unfortunately there is no simple 
# way to calculate degrees of freedom 
# for a GLMM this is currently still 
# being debated amongst statisticians.  
# Therefore, estimating overdispersion 
# by our usual method doesn't work here. 
# However, we can can a rough estimate of 
# the dispersion parameter by using the 
# ratio of residual deviance to n - k - 1 
# where n is the sample size and k is the 
# parameters of the fixed effects.

deviance(model1)
nrow(hedges)

ratio_od <- 799.004/747
ratio_od

# model checking... note normality of 
# residuals is no longer essential

# plot residuals against fitted values... 

# create fitted values and deviance 
# residual values

### reset plotting parameters

par(mfrow = c(1,1))

fit1 <- fitted(model1)
resid <- residuals(model1, 
                   type = "deviance")

plot(fitted1)

# plot residuals, residuals against 
# fitted values and against each 
# explanatory variable here the graphs 
# show three groups representing each 
# management level 
plot(resid)
plot(resid~fitted1)
plot(resid~hedges$Management)

par(mfrow = c(1,2))
plot(hedges$Beetles~hedges$Management)
plot(fitted1~hedges$Management)

#####

library("car")
Anova(model1, type = "III")


R <- r.squaredLR(model1)
R
# Note that Anova command will 
# automatically use a Wald-Chisq 
# test rather than an F-test because 
# we have a poisson response family


# comparing factor levels using Tukey

library("multcomp")

comps <- glht(model1, linfct = mcp(Management = "Tukey"))
summary(comps)

##


# reason for nested GLMM 2 - examining 
# what scale most variation is occurring ----
# compare model 1 above with model 2 below

model1 <- lmer(Beetles ~ Management + (1|Farm/Management/Hedge), 
               family = "poisson", data = hedges)
model2 <- lmer(Beetles ~  (1|Farm/Management/Hedge), 
               family = "poisson", data = hedges)

summary(model1)
summary(model2)

# Note changes in variance explaned 
# by the random effects.  
# When management is included as a 
# fixed effect it masked the variation 
# of managment as a random effect.  
# Therefore, in order to properly examine 
# differences in random variation between 
# scales we should not have any fixed 
# factors in the analysis.

#################

# a more complicated example...

# back to meadow pipits and burning 
# in uplands.. 

birds <- read.csv("birds2.csv")
str(birds)
names(birds)
summary(birds)



mod1 <- lmer(Meadow_pipit ~ Burnt*Habitat + date2 + Time + altitude + Wind + (1|Full_code), data = birds, family = "poisson")

Anova(mod1, type = "III")


deviance(mod1)
## 278.4774
# n-k-1 =
nrow(birds)

# n-k-1 = 122-10-1 = 109

theta <- 278.4774/109
theta
## 2.5548

# Possible overdispersion.  The function 
# lmer in lme4 can't fit negative binomial 
# functions but glmmADMB can.


install.packages("glmmADMB")
library("glmmADMB")

### mod a - poisson response 
moda <- glmmadmb(Meadow_pipit ~ Burnt*Habitat + date2 + Time + altitude + 
                   Wind + (1|Full_code), data = birds, family = "poisson", 
                    zeroInflation = FALSE, verbose = TRUE)
AIC(moda)
##[1] 443.462


### mod b - negative binomial response

modb <- glmmadmb(Meadow_pipit ~ Burnt*Habitat + date2 + Time + altitude + 
                 Wind + (1|Full_code), data = birds, family = "nbinom", 
                 zeroInflation = FALSE, verbose = TRUE)
AIC(modb)
## [1] 373.186

####### we may compare aic of moda and modb directly because 
# poisson distribution is nested within negative binomial

anova(moda, modb)


## mod c - negative binomial response with Zero inflation

modc <- glmmadmb(Meadow_pipit ~ Burnt*Habitat + date2 + Time + altitude + Wind+ (1|Full_code), data = birds, family = "nbinom", zeroInflation = T, verbose = T)
AIC(modc)
## [1] 374.016

# can compare negative binomial to with zero inflated negative binomial as these are nested

anova(moda, modb, modc)

### use modb (negative binomial) as there is no improvement when using modc (with Zero inflation)


#### select best combination of fixed factors by AIC
## an illustration of a step-wise method.. 
Anova(modb, type = "III")

### a reminder of what modb was
modb <- glmmadmb(Meadow_pipit ~ Burnt*Habitat + date2 + Time + altitude + 
                   Wind + (1|Full_code), data = birds, 
                 family = "nbinom", zeroInflation = FALSE, verbose = T)
AIC(modb)

Anova(modb, type = "III")

##### wind is least significant so remove wind

modb1 <- glmmadmb(Meadow_pipit ~ Burnt*Habitat + date2 + Time + altitude + 
                 (1|Full_code), data = birds, 
                 family = "nbinom", zeroInflation = FALSE, verbose = T)

AIC(modb1)

anova(modb1, modb)


Anova(modb1, type = "III")
## now remove altitude

modb2 <- glmmadmb(Meadow_pipit ~ Burnt*Habitat + date2 + Time +  
                    (1|Full_code), data = birds, 
                  family = "nbinom", zeroInflation = FALSE, verbose = T)

AIC(modb2)

anova(modb2, modb1, modb)

Anova(modb2, type = "III")

#### now remove interaction term

modb3 <- glmmadmb(Meadow_pipit ~ Burnt + Habitat + date2 + Time +  
                    (1|Full_code), data = birds, 
                  family = "nbinom", zeroInflation = FALSE, verbose = T)

AIC(modb3)

anova(modb3, modb2, modb1, modb)

Anova(modb3)

# remove habitat

modb4 <- glmmadmb(Meadow_pipit ~ Burnt + date2 + Time +  
                    (1|Full_code), data = birds, 
                  family = "nbinom", zeroInflation = FALSE, verbose = T)

AIC(modb4)

anova(modb4,modb3, modb2, modb1, modb)

Anova(modb4, type = "III")

# remove date2

modb5 <- glmmadmb(Meadow_pipit ~ Burnt + Time +  
                    (1|Full_code), data = birds, 
                  family = "nbinom", zeroInflation = FALSE, verbose = T)

AIC(modb5)

anova(modb5, modb4,modb3, modb2, modb1, modb)

Anova(modb5, type = "III")

## remove burnt

modb6 <- glmmadmb(Meadow_pipit ~ Time +  
                    (1|Full_code), data = birds, 
                  family = "nbinom", zeroInflation = FALSE, verbose = T)

anova(modb6, modb5, modb4,modb3, modb2, modb1, modb)
## model fitting failed.. no convergence.. therefore keep burnt in the 
## final model... or change the model interations via control argument


summary(modb)
summary(modb5)

coef(modb)
coef(modb5)
coef(modb6)
### However, I prefer to do all-subsets regression, it's neater (less prone 
### to me making mistakes) and it means that all combinations are tried 
AIC(modb5)

library("MuMIn")

?dredge

x1 <- dredge(modb, rank = "AIC")
x1 <- as.data.frame(x1)
x1

write.table(x1, "AICSMP.csv", sep = ",", col.names = T, row.names = F)



######  Double check to make sure your final model is better 
## than the null model!

bestmod <- glmmadmb(Meadow_pipit ~ Burnt + Time + (1|Full_code), data = birds, family = "nbinom", zeroInflation = F)
nullmod <- glmmadmb(Meadow_pipit ~ 1 + (1|Full_code), data = birds, family = "nbinom", zeroInflation = F)

anova(nullmod, bestmod)

# Model 1: Meadow_pipit ~ 1
# Model 2: Meadow_pipit ~ Burnt + Time
# NoPar  LogLik Df Deviance Pr(>Chi)  
# 1     3 -180.70                       
# 2     5 -177.07  2    7.264  0.02646 *
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 



# it is significantly better

### to calculate R squared
R <- r.squaredLR(bestmod, null = nullmod)
R

#[1] 0.05780308
#attr(,"adj.r.squared")
#[1] 0.06095422

# look at your results
summary(bestmod)

Anova(bestmod, type = "III")

# to obtain predicted values
fit2 <- predict(bestmod, type = "response")
### add them to the dataframe
birds$fitted_MP <- fit2 

res2 <- bestmod$resid  ### these are pearson residuals by default

######## model checking plots

plot(fit2)
plot(res2~fit2)
plot(res2~ birds$Time)
plot(res2~ birds$Burnt)

summary(birds$fitted_MP)

#

par(mfrow = c(1,1))
png(file = "MP_fitted.png", width = 100, height = 120, units = "mm", res = 200)


barx<-boxplot(birds$fitted_MP~birds$Burnt, ylab="No. of meadow pipits (fitted)", ylim = c(0,4),
              tck = 0, las = 1,col = c("light grey", "dark grey"), xaxt = "n",  
              main = "Meadow pipits", cex.main = 2, boxwex = 0.4, outline = F, cex.lab = 1.2, yaxt = "n") 
axis(1, at = 1:2, labels = c("Unburnt", "Burnt"), cex.axis = 1.5, tck = 0)
axis(2, at = c(0,1,2, 3,4), las = 1,labels = c("0", "1","2","3", "4"), tck = -0.02, cex = 1.3)


dev.off()


#############
