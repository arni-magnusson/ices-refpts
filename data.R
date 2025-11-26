# Prepare data, write CSV data tables

# Before: sol274.rda (boot/data)
# After: refpts (data), summary.csv (data)

library(TAF)
library(FLCore)

mkdir("data")

load("boot/data/sol274.rda")  # run (FLStock), refpts (FLPar), tac (FLQuant)

# Extract reference points
refpts <- as.data.frame(t(unclass(refpts)))

# Extract annual summary statistics
Year <- seq(range(run)[["minyear"]], range(run)[["maxyear"]])
Rec <- flr2taf(rec(run))$Value
SSB <- flr2taf(ssb(run))$Value
Landings <- flr2taf(landings(run))$Value
Discards <- flr2taf(discards(run))$Value
Fbar <- flr2taf(fbar(run))$Value
summary <- data.frame(Year, Rec, SSB, Landings, Discards, Fbar)

# Write CSV tables
write.taf(refpts, dir="data")
write.taf(summary, dir="data")
