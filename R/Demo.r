
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
# Get the Results
# print("Calculating Results..")
SvdResults <- Factory(RescaledVoteMatrix, Scales = ScaleData)
# 
# print("Original")
# print(SvdResults$Original)
# print(" ")
# print("Agents")
print("Results: ")

cat("\n\n\n\n")
cat(" * Agent Payoffs * \n")
cat(" Change in proportional ownership ('reputation' or 'Rep') as a result of this VoteMatrix: \n\n")

# Cut things back for a simpler demo.
Agents <- SvdResults$Agents
Agents <- cbind(Agents, "NewRep"=Agents[,"RowBonus"], "Change"=Agents[,"RowBonus"]-Agents[,"OldRep"])
Agents
AgentsDisplay <- Agents[,c("OldRep","NewRep","Change")]
colnames(AgentsDisplay) <- c("OriginalReputation", "NewReputation", "NetChange")

print( round(AgentsDisplay, 4) )

cat("\n\n\n\n")
cat(" * Decisions-Resolution * \n")
cat(" Software's interpretation of what truly happened ('DecisionOutcome.Final'): \n\n")

# print("Decisions")
# Cut things back for a simpler demo.
DecisDisplay <- SvdResults$Decisions[c(1,2,4,8),]
print( round(DecisDisplay, 4) )
# print(" ")

ScaledOutcomes <- DecisDisplay[4,] # They'll be scaled soon
for(i in 1:ncol(ScaleMatrix)) {

  ThisName <- colnames(ScaleMatrix)[i]
  ThisMin <- ScaleMatrix["Min",ThisName]
  ThisMax <- ScaleMatrix["Max",ThisName]
  
  ScaledOutcomes[ThisName] <- ( ScaledOutcomes[ThisName] * (ThisMax-ThisMin) ) + ThisMin
}

cat("\n\n")
print(ScaledOutcomes)


cat("\n\n\n")
print(PlotJ(RescaledVoteMatrix, Scales = ScaleData))

invisible()
}
