################################
#     An Introduction to R     #
# Session 6: plotting and data #
#         visualisation        #
#                              #
#        R Peer Group          #
################################

# An indroduction to data visualisation

################################################################################
# RUTH #
################################################################################

# back to the morph dataset 
# of hand lenghts hair colour etc...

morph <- read.table("Morpho.txt", 
                    header = TRUE)

str(morph)

names(morph) <- c("G", "Colour", 
                  "hgt", "LRH", 
                  "LLF")

summary(morph)

# basic scatter plot of height 
# and length of right hand

plot(morph$LRH~morph$hgt)

# add a simple smooth line (lowess)

lines(lowess(morph$LRH~morph$hgt), 
      col = "red")

# vary the smoothness using the 
# argument f

lines(lowess(morph$LRH~morph$hgt, f=1), 
      col = "blue")

lines(lowess(morph$LRH~morph$hgt, f=0.1), 
      col = "green")
##########################################

# histograms - useful for looking at 
# data distributions

hist(morph$hgt)

# within group may be more meaningful

par(mfrow = c(1,2))

hist(morph$hgt[morph$G=="F"])
hist(morph$hgt[morph$G=="M"])

# note with of bars has changed. 
# With of bars in a histogram by 
# default is based on the size 
# of the dataset.  
# Can be be changed with the argument 
# "breaks".

hist(morph$hgt[morph$G=="F"], breaks = 2)
hist(morph$hgt[morph$G=="M"], breaks = 10)


# now we can see that the women are towards 
# the short side (left) and men towards 
# the tall (right)

# suppose we wanted to think abbout 
# transformation of data here's raw 
# hist of length of hand

par(mfrow = c(1,1))

hist(morph$LRH)

hist(sqrt(morph$LRH))

# note: log()  = natural log

hist(log(morph$LRH))

hist(log10(morph$LRH))

# with a formal test...
shapiro.test(log(morph$LRH))

# basic boxplots

boxplot(morph$hgt~ morph$G)

# 95% confidence interval on medians... 

boxplot(morph$hgt~ morph$G, notch = T)

# confidence intervals and means 
# (with package "gplots")

# install package
install.packages("gplots")

# Load the package
library(gplots)

# Plotting confidence interval bars

# We need a vector of means, and a vector of 
# standard errors.
# Imagine we have birds in three different 
# habitats, e.g. woodland, pasture and wetland


par(mfrow = c(1,1))
# Let the mean weight of birds in these be 1.2kg, 
# 1.5kg and 0.9kg ie..

meanwgt <- c(1.2, 1.5, 0.9)

# and say the standard errors are as follows: 

sterr <- c(0.1, 0.2, 0.1)


# Plot 

plotCI(meanwgt, uiw = sterr, 
       barcol = "blue")

# uiw = upper limit, this must have the 
# same number of values as the number of means


# Suppose we want to do this with a dataframe. 
# Here's one way..

# If your data is organised like morph, 
# (rather than a separate column for 
# each habitat etc.) 
# First split the column of interest by 
# the factor you're interested in e.g.

spl_hgt <- split(morph$hgt,morph$Colour)
str(spl_hgt)

# It's now a list of values for each 
# hair colour

# We can then use the sapply function to 
# apply a function to each individual list 
# (hair colour)

# Here I show how to calculate three common 
# measures of error/variance which are frequently 
# plotted in ecology (namely: standard deviation, 
# standard error and 95% confidence intervals)

# To calculate means

hair_means <-  sapply(spl_hgt, mean)

# to calculate standard devation

stdev <-  sapply(spl_hgt, sd)

# Standard error is usually calculated as 
# sd / sqrt(n). Where n = sample size

# Obtain sample size of each hair colour
n <- sapply(spl_hgt, length)

# calculate standard error of each group
sterr <-  stdev/sqrt(n)

# Confidence intervals at 95 %. 
# Note that the 0.975 quantile of the t 
# distribution is used, as this is one side 
# of the error bar (i.e. we lose 0.025 either 
# side when we plot it).

conf <- qt(0.975, n) * sterr

# side by side
par(mfrow = c(1,3))

# SD

plotCI(x = hair_means, uiw = stdev, 
       barcol = "blue", pch = 16, 
       ylab = "Height (Inches)", 
       main = "Standard dev")

# SE

plotCI(x = hair_means, uiw = sterr, 
       barcol = "blue", pch = 16, 
       ylab = "Height (Inches)", 
       main = "Standard error")

# CI

plotCI(x = hair_means, uiw = conf, 
       barcol = "blue", pch = 16, 
       ylab = "Height (Inches)", 
       main = "95% confidence")

# Note: there is no error plotted where the 
# sample size = 1 (i.e. error is unknown).
##########################################

# Looking at correlation between variables

# Use the lakes data

# This dataset shows nutrient content in 
# two lakes and plant species richness.

lakes <- read.table("wchem2.txt", 
                    header = TRUE)

str(lakes)

summary(lakes)

# looking at correllations between pairs 
# of variables

pairs(lakes[,-1])

# Something is going on with TSP and TP

# Add smoothing lines
pairs(lakes[,-1], 
      panel = panel.smooth)

# This is just a visual fit of 

cor(lakes[,-1])

# Coplots can be used for looking at the 
# pattern within factors. E.g. if we want
# to know whether this relationship between 
# TP and TSP exists in both lakes..

coplot(lakes$TSP~lakes$TP|lakes$Site)

# Also note difference in the range of values 
# between lakes

# What about the relationship between plant 
# species richness and nitrogen levels within
# lakes

coplot(lakes$TON~lakes$plant_richness|lakes$Site)

# richness appears to respond differently to 
# nutrient content in each lake


################################################################################
# Mark # 
################################################################################

# To make things a little simpler in these 
# examples, I am going to use some default 
# plots stored in R

# To view a list of these use
data()
# Here I will be mostly using:

pressure
cars


##################################
# Understanding graphical devices#
##################################

# The fundamentals of R graphics can 
# appear quite complicated, but in 
# principle, the way R graphics work 
# is quite simple. The easiest way to 
# think of how R deals with graphics is 
# to focus on devices - devices are 
# essentially either windows (like the 
# one to the right if you are using R studio) 
# or files. In other words, a device is 
# the OUTPUT from R. 

# See the current device
dev.cur() # should be null device

# Show all available devices
?Devices

# Display a list of devices (more later...)
dev.list()

# Your main interaction with devices 
# will be using them to output specific 
# file types. R is very flexible with 
# devices and as a result you can output
# a large number of different files for 
# use in presentations and publications. 
# What's more, the R devices have many 
# options which allow you to specify
# how you want the output to look.

# First of all, what happens if you don't 
# specify a device?

plot(cars)
dev.cur() 

# R simply sends the output to its 
# defaul graphical device

####################
# Managing devices # 
###################

# First lets turn on some devices 

pdf()
png()
dev.list()

# You can see there are a lot of devices 
# on now.

# The numbers allow us to control the 
# devices. 
# For example to set pdf() as the current 
# device:

dev.set(4)

# We can also switch them off easily

dev.off(4)

# Switch off all the devices for now

##################################
# Outputting different file types#
##################################

# All of these functions will save a file 
# to your working directory. Use getwd() 
# to see where that is.

# Make a png file for presentations

png(file = "pressure.png")
plot(pressure)
dev.off()

# Make a postscript file for 
# publications
postscript(file = "pressure.ps")
plot(pressure)
dev.off()

# Make a pdf file for sending to 
# colleagues
pdf(file = "pressure.pdf")
plot(pressure)
dev.off()

# You can see it can be a bit of 
# hassle managing multiple devices, 
# it is best practice to turn a device 
# off once you've used it. 

# That's what dev.off() is for!

########################
# A simple alternative #
########################

# Printing to devices can sometimes 
# be a little counterintuitive, especially 
# if you are editing a plot in R.  We can 
# use dev.print to print from your standard 
# R studio device to an output device of 
# your choice. dev.print will also turn
# off the device after it has called it.

dev.cur()
plot(cars)
dev.print(device = pdf, 
          "cars.pdf", 
          onefile = FALSE)

## Specifying some extra details - 
# sizes and fonts.

# Let's imagine your manuscript was 
# accepted in Nature, but the editor 
# emails you to tell you they want 
# a figure which is 500 x 500 pixels.

# How can you make sure this is the case?

plot(cars)
dev.print(device = png, 
          "cars.png",
          width = 500, 
          height = 500)

# Altering these options has a large 
# effect!

plot(cars)
dev.print(device = png, 
          "cars_wide.png",
          width = 2000, 
          height = 500)

# Be careful to note that the values 
# of options change between devices. 
# So for example, while PNG and postscript 
# take pixels for height and width arguments, 
# the PDF device takes inches - so for A4...

plot(cars, pch = 21, bg = "blue")

dev.print(device = pdf, "cars.pdf",
          width = 8.3, height = 11.7)

# Make sure you check ?pdf, ?postscript 
# and ?png to see the arguments you can 
# pass to dev.print.

# Some quick tips for good looking graphics 
# use PNG for presentations
# use PDF if you need to print or send
# use postscript for publications
# specify the height and width in R

################################
# Setting graphical parameters #
################################

# There are many many graphical parameters 
# and we don't have time to discuss them 
# all here. However I will run through the 
# most immediately useful - for setting 
# margins and layout.

# To set parameters, we use the par() 
# function

?par
par()

# Before we go further, it might be 
# useful to save 
# our default values

default_par <- par()

# The main parameter you will want to vary 
# is the margins of a plot. The default 
# values are...

par()$mar

# These correspond to the bottom, left, top 
# and right sides of the plot and represent 
# the number of lines from the device side

# Try plotting

plot(pressure)

# This plot includes the margin space 
# i.e. white space we can get rid of

par(mar = c(3, 3, 3, 3))
plot(pressure)

# You can see that was a little too drastic...
# Perhaps this is better?

par(mar = c(4.1, 4.1, 1.5, 1.5))
plot(pressure)

# To return things to how they were 
# before

par(default_par) #ignore the warnings
plot(pressure)

#################
#  PLOT LAYOUT  #
#################

# There are many, many ways to do this
# I will show you three simple ones

# First there are two ways using par

# first use mfrow - this will partition
# the graphic device by x rows and y columns
# and  fill by the rows.

# So this will produce 2 graphs, one on 
# top of the other

par(mfrow = c(2, 1))
boxplot(cars)
boxplot(pressure)

# This will produce 4 graphs, side by side

par(mfrow = c(2, 2))
plot(cars)
plot(pressure)
boxplot(cars)
boxplot(pressure)

# mfcol is identical but fills by columns
# How does this differ?

par(mfcol = c(2, 2))
plot(cars)
plot(pressure)
boxplot(cars)
boxplot(pressure)

# Return to default for the next example

par(default_par)

## Layout ###
# The layout function allows advanced 
# customisation of the graphical device. 
# It takes a matrix as an argument, with 
# the numbers in the matrix corresponding 
# to sections of the device

# So to split the device in four

mat <- matrix(1:4, ncol = 2, 
              nrow = 2)
layout(mat)

# What if you want to see the layout? 
# Use layout.show with the total number 
# of sections as an argument.

layout.show(4)

# There are many many possibilities. 
# Here are a few useful examples

mat <- matrix (1:6, ncol = 2, 
               nrow = 3)
layout(mat)
layout.show(6)

mat <- matrix (1:6, ncol = 3, 
               nrow = 2)
layout(mat)
layout.show(6)

mat <- matrix (c(1:3, 3), 
               ncol = 2, 
               nrow = 2)
layout(mat)
layout.show(3)

# Now remember the ugly squished graphs 
# we got earlier? 
# Well we can combine these approaches to
# overcome that:

# Set up layout matrix

mat <- matrix (c(1, 1:3), 
               ncol = 2, 
               nrow = 2)

# Pass to device

layout(mat)

# adjust margins

par(mar = c(4.2, 4.2, 2, 2))

# plot 1
plot(cars, las = 1, pch = 21, 
     bg = "red", cex = 1.15, 
     xlab = "Distance", 
     ylab = "Speed")

# plot 2
hist(cars$dist, breaks = 20, 
     col = "light grey", 
     las = 1, main = NULL, 
     xlab = "Distance")

# plot 3
hist(cars$speed, breaks = 20, 
     col = "dark grey", 
     las = 1, main = NULL, 
     xlab = "Speed")

# print the plot to device

dev.print(device = pdf, "cars.pdf")

# Take a look at the PDF and think 
# about how long it would take to 
# make something like that in excel... ;)

################################################################################
# Kevin #
################################################################################

# reset par
par(mfrow = c(1,1))

#########################
# Some additional data  # 
# visualisation tools.  #
#########################

# DIY se/sd/ci bar plotting

# For non-normally distributed data
locData <- read.table("locusData.txt", 
                      header = TRUE)

str(locData)

# Plot the mean locus value
# with the upper and lower
# 95% ci's.

# create an empty plot

plot(locData$Mean, xaxt = "n", xlab = "",
     ylab = expression("D"["Jost"]), 
     las = 2, type = "n")

# add mean points to the empty plot
points(locData$Mean, pch = 15, 
       col = "blue")

# add error bars (Low)
arrows(x0 = 1:length(locData$Mean),
       y0 = locData$Mean, 
       x1 = 1:length(locData$Mean), 
       y1 = locData$Low, angle = 90,
       code = 2, lwd = 2)

# get rid of zero data to fix
# warnings

locData <- locData[locData$Mean != 0, ]

# replot new data

# create an empty plot

plot(locData$Mean, xaxt = "n", xlab = "",
     ylab = expression("D"["Jost"]), 
     las = 2, type = "n")


# add error bars (Low) (change length)
arrows(x0 = 1:length(locData$Mean),
       y0 = locData$Mean, 
       x1 = 1:length(locData$Mean), 
       y1 = locData$Low, angle = 90,
       code = 2, lwd = 2, 
       length = 0.05)

# add upper bars
arrows(x0 = 1:length(locData$Mean),
       y0 = locData$Mean, 
       x1 = 1:length(locData$Mean), 
       y1 = locData$Hi, angle = 90,
       code = 2, lwd = 2, 
       length = 0.05)

# add mean points to the empty plot
points(locData$Mean, pch = 15, 
       col = "blue", cex = 0.5)

# Add upper and lower at once
# create an empty plot

plot(locData$Mean, xaxt = "n", xlab = "",
     ylab = expression("D"["Jost"]), 
     las = 2, type = "n")


# add error bars (Low) (change length)
arrows(x0 = c(1:length(locData$Mean),
              1:length(locData$Mean)),
       y0 = c(locData$Mean,
              locData$Mean), 
       y1 = c(locData$Low,
              locData$Hi),
       angle = 90, code = 2, 
       lwd = 2, length = 0.05)

# add the points
points(locData$Mean, pch = 15, 
       col = "blue")

# Add labels to x axis
axis(1, at = 1:nrow(locData),
     labels = as.character(locData$Locus),
     las = 2)

# Adjust the space for labels
par(mar = c(5, 5, 4, 4))

# replot
plot(locData$Mean, xaxt = "n", xlab = "",
     ylab = expression("D"["Jost"]), 
     las = 2, type = "n")


# add error bars (Low) (change length)
arrows(x0 = c(1:length(locData$Mean),
              1:length(locData$Mean)),
       y0 = c(locData$Mean,
              locData$Mean), 
       y1 = c(locData$Low,
              locData$Hi),
       angle = 90, code = 2, 
       lwd = 2, length = 0.05)

# add the points
points(locData$Mean, pch = 15, 
       col = "blue", cex = 0.8)

# Add labels to x axis
axis(1, at = 1:nrow(locData),
     labels = as.character(locData$Locus),
     las = 2, cex.axis = 0.7)


############################
# Big matrix visualisation #
############################

# Creating colour gradients 
# using the plotrix package

# Sometimes it is difficult to
# make sense from your data
# without some plottrickery.

# When plotting large pairwise
# matrices it is often useful
# to use colour to visualise
# parameter magnitude.

# read in a matrix of pairwise
# genetic distances between 50
# population samples. (i.e. 1225 
# comparisons)

dist_mat <- read.table("big_matrix.txt", 
                       header = FALSE, 
                       na.strings = "-9")

# To plot out data we should use 
# the function 'image'. First,
# the data should be in matrix
# format.

dist_mat <- as.matrix(dist_mat)

# plot

image(dist_mat)

# terrain colours

image(dist_mat, 
      col = terrain.colors(10))

# topo colours

image(dist_mat, 
      col = topo.colors(10))

# rainbow colours 

image(dist_mat, 
      col = rainbow(10))


# We can make our own colour
# gradients using the 'plotrix'
# package.

# install the package from CRAN

install.packages("plotrix")

# load the package to the current
# session

library("plotrix")

# the function we want to use is

?colorRampPalette

myCols1 <- colorRampPalette(c("blue", 
                              "white"))

myCols2 <- colorRampPalette(c("brown", 
                              "yellow"))

myCols3 <- colorRampPalette(c("blue", 
                              "red"))

myCols4 <- colorRampPalette(c("grey", 
                              "blue", 
                              "white"))


myCols1(5) # outputs hex colours

# now we can use our gradient
# function to plot our data

image(dist_mat, col = myCols1(10))
image(dist_mat, col = myCols2(10))
image(dist_mat, col = myCols3(10))
image(dist_mat, col = myCols4(10))

# What about a legend to remind
# us of the colour representation

# The plotrix package has a function
?color.legend

image(dist_mat, col = myCols1(10))

labs <- c(round(min(dist_mat, 
                    na.rm = TRUE), 2),
          round(median(dist_mat, 
                       na.rm = TRUE), 2),
          round(max(dist_mat, 
                    na.rm = TRUE), 2))

color.legend(xl = 0.1, yb = 0.4, 
             xr = 0.2, 
             yt = 0.8, 
             legend = labs,
             rect.col = myCols1(10), 
             gradient = "y")

# What do the axes mean?
# nothing here.

# remove them and add pop names

pop_names <- paste("pop", 1:ncol(dist_mat), 
                   sep = "" )

image(dist_mat, col = myCols1(10),
      xaxt = "n", yaxt = "n")

color.legend(xl = 0.1, yb = 0.4, xr = 0.2, 
             yt = 0.8, legend = labs,
             rect.col = myCols1(10), 
             gradient = "y")


labPos <- seq(from = 0, to = 1, 
              by = 1/ncol(dist_mat))
axis(1, at = labPos[-1], 
     labels = pop_names, 
     las = 2)
axis(2, at = labPos[-98], 
     labels = pop_names, 
     las = 2)

# change the angle of axis labels

image(dist_mat, col = myCols1(10),
      xaxt = "n", yaxt = "n")

color.legend(xl = 0.1, yb = 0.4, 
             xr = 0.2, yt = 0.8, 
             legend = labs,
             rect.col = myCols1(10), 
             gradient = "y")

# set up the x axis
axis(1, at = labPos[-1], 
     labels =FALSE)
# add labels
text(labPos[-1],par("usr")[3] - 0.05, 
     srt = 45, adj = 1,
     labels = pop_names, 
     xpd = TRUE)

# No point in trying y axis.
# There is too much information.

# Alternative plot example.
