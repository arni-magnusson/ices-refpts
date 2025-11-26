# config.R - Repository configuration, packages and options
# mse_referencepoints/config.R

# Copyright (c) WMR, 2025.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(TAF)
library(mse)

# PARALLEL setup via doFuture

cores <- 10

if(os.linux()) {
  plan(multicore, workers=cores)
} else {
  plan(multisession, workers=cores)
}

options(doFuture.rng.onMisuse="ignore")

# SET arguments

# INITIAL year
iy <- 2022

# DATA year
dy <- iy - 1

# FINAL year
fy <- 2055

# NUMBER of iterations
it <- 500

set.seed(987)
