
ToMatrix <- function(DF) {
  RowNames <- row.names(DF)
  DFn <- data.frame ( lapply( DF, as.numeric) ) # make all observations numbers
  Matrix <- as.matrix(DFn,ncol = ncol(DF)) # save in matrix format
  row.names(Matrix) <- RowNames  # restore row names (lost during as.numeric)
  return(Matrix)
}


truthcoindemo <- function(csvdata) {

# print("Loading data..")
con <- textConnection(csvdata)
Data <- read.csv(con, stringsAsFactors= FALSE, row.names=1)
close(con)
# print("Load Complete.")
# print(" ")

## Get VoteMatrix ##
# print("Getting Votes..")

# Remove header info
VoteData <- Data[-1:-4,]
VoteMatrix <- ToMatrix(VoteData)

# print(VoteMatrix)
# print(" ")


## Rescale ##
# print("Rescaling the Scaled Decisions..")

# Scaled claims must become range(0,1)

Scaled <- Data["Qtype",] == "S" # which of these are scaled at all?

# Rescale
ScaleData <- Data[c("Min", "Max"),Scaled] # get the scales from the 'Qtype' row, and nothing else
ScaleMatrix <- ToMatrix(ScaleData)


RescaledVoteMatrix <- VoteMatrix # declare destination data
for(i in 1:ncol(ScaleMatrix)) { # for each scaled decision
  
  ThisQ <- colnames(ScaleMatrix)[i]
  ThisColumn <- RescaledVoteMatrix[ , colnames(RescaledVoteMatrix)==ThisQ ] # match the right column
  RescaledColumn <- (ThisColumn - ScaleMatrix["Min",i]) / (ScaleMatrix["Max",i] - ScaleMatrix["Min",i])  # "rescale"
  
  RescaledVoteMatrix[ , colnames(RescaledVoteMatrix)==ThisQ ] <- RescaledColumn # Overwrite
}

# print("Rescale Complete.")
# print(" ")


## Do Computations ##

# I've already rescaled, but we still need to pass the boolean - must fix this.
ScaleData <- matrix( c( rep(FALSE,ncol(RescaledVoteMatrix)),
              rep(0,ncol(RescaledVoteMatrix)),
              rep(1,ncol(RescaledVoteMatrix))), 3, byrow=TRUE, dimnames=list(c("Scaled","Min","Max"),colnames(RescaledVoteMatrix)) )

ScaleData[1,] <- Scaled

# Get the Resuls
# print("Calculating Results..")
SvdResults <- Factory(RescaledVoteMatrix, Scales = ScaleData)
# 
# print("Original")
# print(SvdResults$Original)
# print(" ")
# print("Agents")
print(SvdResults$Agents)
print(" ")
print(" ")
print(" ")
print(" ")
# print("Decisions")
print(SvdResults$Decisions)
# print(" ")

print(PlotJ(RescaledVoteMatrix, Scales = ScaleData))

invisible()
}
