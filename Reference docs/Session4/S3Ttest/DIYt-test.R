# A function to automatically run parametric or non-parametric t-test depending
# on the data.

# define the data structure using data.structure. 
# The argument can have the values;
# 'factor' for a single variable recorded in a single column or,
# 'columns' for a single variable recorded in seperate cols per groups

# data.structure <- "columns" # or "factor"

# define groups within data
#groups <- c("yr1", "yr3") # only valid if data.structure == columns

# define the type of t-test. Arguments can have the value; 
# "paired", "1sample" or "2sample".
# e.g.
# type <- "paired"

# define the hypothesis to test. The argument can have the value;
# "2side", "less", "greater"
# e.g.
# alternative <- "less"

# mu define the reference group mean for a 1 sample test

################################################################################
DIYt.test <- function(Data, groups = NULL, alternative = "two.sided", mu = NULL, 
                      data.structure = "columns", test.type = NULL){
  
dStruct = data.structure
type = test.type
  # for paired or 2sample tests only
  if(type == "paired" || type == "2sample"){
    
    # find the groups within the data and standardise the structure
    if(dStruct == "columns"){
      # create a new dataframe
      nData <- data.frame(var = c(Data[,groups[1]], Data[,groups[2]]),
                          fac = as.factor(rep(groups, each = nrow(Data))))
    } else if(dStruct == "factor"){
      # rename the data to a standard format
      
      #find the factor in the data
      classTest <- sapply(1:ncol(Data), function(i){
        var <- Data[,i]
        return(class(var))
      })
      if(sum(classTest == "factor") == 2){
        stop("Check your data for missing value characters")
      }
      # organise the data to factor and numeric
      nData <- data.frame(var = Data[,which(classTest == "numeric")],
                          fac = as.factor(Data[,which(classTest != "numeric")]))
    }
    
    # do a normality test
    norm1 <- shapiro.test(nData$var[nData$fac == levels(nData$fac)[1]])
    norm2 <- shapiro.test(nData$var[nData$fac == levels(nData$fac)[2]])
    
    # do variance test
    suppressWarnings(vars <- bartlett.test(var ~ fac, data = nData))
    
    # check everything befor proceeding with ttest
    if(norm1$p.value > 0.05 && norm2$p.value > 0.05 && vars$p.value > 0.05){
      if(type == "paired"){
        testRes <- t.test(var ~ fac, 
                          data = nData,
                          paired = TRUE, 
                          alternative = alternative)
      } else {
        testRes <- t.test(var ~ fac, 
                          data = nData,
                          paired = TRUE, 
                          alternative = alternative)
      }
    } else {
      if(type == "paired"){
        testRes <- wilcox.test(var ~ fac, 
                               data = nData,
                               paired = TRUE,
                               alternative = alternative)
      } else {
        testRes <- wilcox.test(var ~ fac,
                               data = nData,
                               alternative = alternative)
      }
    }
  } else if(type == "1sample"){
    # do a normailty test
    norm1 <- shapiro.test(Data)
    # if the data is normal run a ttest
    if(norm1$p.value > 0.05){
      testRes <- t.test(Data, mu = mu,
                        alternative = "two.sided")
    } else {
      testRes <- wilcox.test(Data, mu = mu,
                             alternative = "two.sided")
    }
  }
  
  return(testRes)
}
