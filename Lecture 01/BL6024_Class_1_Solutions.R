tDat <- read.csv("tDat.csv", header = TRUE, stringsAsFactors=FALSE)

### How many species are detailed in these data?

# I would have used the code, below. Here, we are: (i) creating a virtual vector (i.e. data not assigned
# to an object) where we extract unique values from one of the species columns (i.e. the names of 
# individual species); (ii) counting the lenth of the virtual vector.
length(unique(tDat$Sp_C))

# We could do the same thing with individual vectors
n_sp <- unique(tDat$Sp_C)
n_sp

length(n_sp)




### What is the name of the third column?

# I would have used:
names(tDat)[3]

# As noted in the class, `names(x)` returns the name of all columns in a dataframe. By adding the [3],
# we are telling it which column we're interested in. We don't need to worry about commas or rows
# because `names` just deals with column names.


### What is the value of the data in the 2nd column, 57th row?
tDat[57,2]




### What data are on the 12th,  87th and 197th rows?

# Here we use the `combine` command to let R know that we're interested in several different rows
tDat[c(12, 87, 197), ]





### What is the median wing length across all species?

# Could have used:
summary(tDat)

# I would have used:
median(tDat$Wing)




### What is the square root of the value in the 8th column, 70th row?

# Remember that you must specify your focal dataframe and then tell R which cell you're looking for
sqrt(tDat[70,8])


### What are the sex, age, wing length and weight of the Blackcap?

# I asked for metrics from `the` Blackcap, but how many Blackcaps are there?
length(which(tDat$Sp_C == "Blackcap"))

# Oh good, there's 1. That makes it easier. So let's extract that row.
tDat[tDat$Sp_C == "Blackcap", ]




### How many Blackbirds of age 6 have a wing length of over 130 cm?

# You may have used the following code and counted your birds manually.
b_wi <- tDat[ which(tDat$Sp_C=='Blackbird' & tDat$Wing > 130), ]
b_wi

# The 'length' function counts the number of rows in a specific vector.
length(b_wi)
