###############################
#                             #
#      The Joys of GLMs       #
#                             #
###############################

# Session 7

# The R-peer-group

###############################

# GLM: doing an anova ----

#### todays data

mythic <- read.csv("Mythical.csv")
str(mythic)

# load required package
library("car")

# run glm function

mod1 <- glm(bodymass ~ Species, 
            data = mythic)
summary(mod1)

# plot the model
plot(mod1)


plot(bodymass ~ Species,
     data = mythic)


# calculate group means
spMeans  <- tapply(mythic$bodymass,
                   mythic$Species, 
                   mean)

# print results
spMeans

# Apply 'Anova' function
# from 'car' package to mod1

Anova(mod1, test = "F", 
      type = "III")

# Post-hoc tests

x1 <- TukeyHSD(aov(bodymass ~ Species, 
                   data = mythic))
x1


plot(mod1)

plot(bodymass ~ Species,
     data = mythic)

# model 2 - an anova 
# with two factors  ----
names(mythic)
str(mythic)

plot(bodymass ~ type, 
     data = mythic)
plot(bodymass ~ method, 
     data = mythic)

# calculate means across
# measurement methods
mtdMeans <- tapply(mythic$bodymass, 
                   mythic$method,
                   mean)

# print results
mtdMeans

# run glm for 2nd model
mod2 <- glm(bodymass ~ Species + method, 
            data = mythic)


summary(mod2)

Anova(mod2, test = "F", 
      type = "III")


# adjust graphical device
par(mfrow = c(3,1))


plot(bodymass ~ method, 
     data = mythic)
plot(bodymass ~ Species, 
     data = mythic)
plot(bodymass ~ type, 
     data = mythic)

# reset graphical device
par(mfrow = c(1,1))

multi <- TukeyHSD(aov(bodymass ~ Species
                      + method, 
                      data = mythic))
#####################################

# Two factors with an 
# interaction ----

# run glm for 3rd model
mod3 <- glm(bodymass ~ Species
            * method, 
            data = mythic)

summary(mod3)

Anova(mod3, test = "F", 
      type = "III")

plot(bodymass ~ type, 
     data = mythic)

multi <- TukeyHSD(aov(bodymass ~ Species
                      * method, 
                      data = mythic))
#########################################

# Model selection ----

AIC(mod1, mod2, mod3)


anova(mod1, mod2, mod3, 
      test = "F")
#################################


# regression... ----   

mod4 <- glm(speed ~ bodymass, 
            data = mythic)
plot(mod4)

# check normality of residuals
shapiro.test(residuals(mod4))

plot(speed ~ bodymass, 
     data = mythic)
summary(mod4)

Anova(mod4, test = "F", 
      type = "III")

# ancova - does speed differ 
# between species accounting 
# for species differences ----

mod5 <- glm(speed ~ bodymass
            + Species, 
            data = mythic)
plot(mod5)

shapiro.test(residuals(mod5))

# create an empty plot
plot(speed ~ bodymass, 
     data = mythic, 
     type = "n")

# add pints to plots

# unicorns
points(speed ~ bodymass, 
       data = mythic[mythic$Species == "Unicorn",], 
       col = "pink", pch = 16 )

# yeti
points(speed ~ bodymass, 
       data = mythic[mythic$Species == "Yeti",], 
       col = "dark grey", pch = 16)

# chupacabra
points(speed ~ bodymass, 
       data = mythic[mythic$Species == "Chupacabra",], 
       col = "blue")

summary(mod5)

Anova(mod5, test = "F", 
      type = "III")

# is there an interaction between 
# the speed bodymass relationship 
# and species.  
# (i.e. do the regression slopes differ)

mod6 <- glm(speed ~ bodymass
            * Species, 
            data = mythic)
plot(mod6)

# empty plot
plot(speed ~ bodymass, 
     data = mythic, type = "n")

# unicorn
points(speed ~ bodymass, 
       data = mythic[mythic$Species == "Unicorn",], 
       col = "pink", pch = 16 )

# yeti
points(speed ~ bodymass, 
       data = mythic[mythic$Species == "Yeti",], 
       col = "dark grey", pch = 16)

# chupacabra
points(speed ~ bodymass, 
       data = mythic[mythic$Species == "Chupacabra",], 
       col = "blue")

summary(mod6)

Anova(mod6, test = "F", type = "III")

###########

AIC(mod4, mod5, mod6)
anova(mod4, mod5, mod6, 
      test = "F")


######################### 

# END