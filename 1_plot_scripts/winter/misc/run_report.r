## 
## Notes:
## The Docker PostreSQL database needs to be up for the SKT file to run successfully. 
## For the moment, the DJFMP data are being retrieved from winter_report/data.
## 
#########################################################################################

library(gridExtra)
library(knitr)
library(tidyverse)

## The variable 'root' must be defined.
root <- file.path("winter_report")

fig_root <- file.path(root,"latex","figures")
secchi_fig_root <- file.path(fig_root,"secchi")
smelt_fig_root <- file.path(fig_root,"smelt")
salmon_fig_root <- file.path(fig_root,"salmon")
otherfish_fig_root <- file.path(fig_root,"otherfish")


## Makes life easier to have the report directory as the working directory:
setwd(root)
source("IEP_Status&Trends_util.R")
#source("IEP_Status&Trends_Fishes_DJFMP.R")
#source("IEP_Status&Trends_Fishes_SKT.R")
source("IEP_Status&Trends_Redbluff.R")


## knitr pdf version of the report.
## knitr likes having the working directory set to where the Rnw and tex files will be:
setwd(file.path(root,"latex"))
base <- "status_and_trends_report_winter_landscape"
knitr::knit(input=paste0(base,".Rnw"))
tools::texi2dvi(paste0(base,".tex"), pdf=TRUE, clean=TRUE)
