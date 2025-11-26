# data.R - condition OM(s)
# WKREBUILD_toolset/data.R

# Copyright (c) WUR, 2023.
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2

library(TAF)
library(mse)
source("config.R")
source("utilities.R")

mkdir("data")

# LOAD AAP SA results, 2022 ICES WGNSSK sol.27.4
load("boot/data/sol274.rda")

# - Stock-recruitment relationship(s) **

# FIT models
fits <- srrTMB(as.FLSRs(run, models=c("segreg")),
  spr0=mean(spr0y(run)[, ac(2018:2022)]))
fit2 <- fmle(as.FLSR(run, model=c("segreg")))

# PLOT
plotsrs(fits)

# BOOTSTRAP and SELECT model by largest logLik **
srpars <- bootstrapSR(run, iters=it, spr0=mean(spr0y(run)[, ac(2018:2022)]),
  models=c("segreg"), method="best")

# SAVE
save(fits, srpars, file="data/bootstrap.rda", compress="xz")

# - CONSTRUCT OM

# GENERATE future deviances: lognormal autocorrelated **
srdevs <- rlnormar1(sdlog=srpars$sigmaR, rho=srpars$rho, years=seq(dy, fy),
  bias.correct=FALSE)

plot(srdevs)

# BUILD FLom
om <- FLom(stock=propagate(run, it), refpts=refpts, model='mixedsrr',
  params=srpars, deviances=srdevs, name="sol274-ss3")

# SETUP om future: average of last 3 years **
om <- fwdWindow(om, end=fy, nsq=5)

# F and SSB deviances
sdevs <- shortcut_devs(om, Fcv=0.212, Fphi=0.423, SSBcv=0.10)

# - CONSTRUCT iem, implementation error module w/10% noise **

iem <- FLiem(method=noise.iem,
  args=list(noise=rlnorm(500, rec(om) %=% 0, 0.1)))

# - SAVE

save(om, iem, sdevs, file="data/data.rda", compress="xz")

plan(sequential)
