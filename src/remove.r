remove.packages("rliger")
# devtools::install_github("welch-lab/liger", ref = "v1.0.1")
install.packages("RcppPlanc", repos = "https://welch-lab.r-universe.dev")

library(rliger)
library(Matrix)
options(ligerDotSize = 0.5)
osmFISH <- readRDS("../data/test/OSMFISH.vin.RDS")
osmFISH <- as(osmFISH, "CsparseMatrix")
rna <- readRDS("../data/test/DROPVIZ.vin.RDS")
lig <- createLiger(list(osmFISH = osmFISH, rna = rna))

rna[1:5, 1:2]
osmFISH[1:5, 1:2]
lig
lig <- normalize(lig)
lig <- selectGenes(lig, useUnsharedDatasets = "rna", unsharedThresh = 0.4)
varFeatures(lig)
lig <- scaleNotCenter(lig)
lig <- runIntegration(lig, k = 10, method = "UINMF")



