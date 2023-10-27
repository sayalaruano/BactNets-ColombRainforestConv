# Import libraries
library(NetCoMi)
library(dplyr)
library(paletteer)

# Set seed to make results reproducible
set.seed(123)

# Load networks
nets_spring <- readRDS("Results/Networks/nets_spring_ColombRainforest.rds")
nets_cclasso <- readRDS("Results/Networks/nets_cclasso_ColombRainforest.rds")

# Load taxonomy df
tax_bact_familyrenamed <- read.csv("Data/tax_bact_familyrenamed.csv")
phyla <- as.factor(tax_bact_familyrenamed[, "Phylum"])
names(phyla) <- tax_bact_familyrenamed[, "Family"]
table(phyla)

# Define phylum colors
phylcol <- paletteer_d("ggsci::default_igv", 18)
phylcol[11] <- paletteer_d("ggsci::category20b_d3", 18)[15]
phylcol[16] <- paletteer_d("ggsci::category20b_d3", 18)[3]
phylcol[6] <- paletteer_d("ggsci::default_jco")[1]
phylcol[7] <- paletteer_d("ggsci::default_jco")[3]
phylcol[13] <- paletteer_d("ggsci::default_aaas")[2]
phylcol[2] <- paletteer_d("dichromat::SteppedSequential_5")[21]

# Colors used in the legend should be equally transparent as in the plot
# phylcol_transp <- colToTransp(phylcol, 20)
  
###############################################################################
########################### Analyze networks ##################################
###############################################################################
props_spring_nets <- netAnalyze(nets_spring, 
                                   centrLCC = FALSE,
                                   avDissIgnoreInf = TRUE,
                                   sPathNorm = TRUE,
                                   clustMethod = "cluster_fast_greedy",
                                   hubPar = "betweenness", #change it to define hub def
                                   hubQuant = 0.9,
                                   lnormFit = TRUE)

props_cclasso_nets <- netAnalyze(nets_cclasso, 
                                centrLCC = FALSE,
                                avDissIgnoreInf = TRUE,
                                sPathNorm = TRUE,
                                clustMethod = "cluster_fast_greedy",
                                hubPar = "betweenness", #change it to define hub def
                                hubQuant = 0.9,
                                lnormFit = TRUE)

###############################################################################
########################### Visual comparison #################################
###############################################################################
# SPRING
# Degree as node size and hub definition
svg("Results/Figures/Family_and_Phylum_nets/svg/spring_nets_family_phyl_deg.svg", width=20, height=10)
# png("Results/Figures/Family_and_Phylum_nets/png/spring_nets_family_deg.png", width=1500, height=750)
spring_nets_plot <- plot(props_spring_nets,
                         layout = "spring",
                         sameLayout = FALSE,
                         layoutGroup = "union",
                         repulsion = 0.8,
                         nodeColor = "feature", 
                         featVecCol = phyla,
                         colorVec =  phylcol,
                         edgeTranspLow = 0,
                         edgeTranspHigh = 40,
                         nodeSize = "degree",
                         posCol = "#ac1214", 
                         negCol = "#0d1fad",
                         shortenLabels = "intelligent",
                         labelLength = 7,
                         labelScale = FALSE,
                         rmSingles = TRUE,
                         cexNodes = 1.8, 
                         cexLabels = 0.9,
                         nodeSizeSpread = 2.5,
                         cexHubLabels = 1,
                         hubBorderCol = "snow4",
                         cexTitle = 2.5,
                         groupNames = c("", ""))

legend(-0.10, 1, cex = 1, pt.cex = 1.5, title = 'Phylum:', title.adj = 0,
       legend=levels(phyla), col = phylcol, bty = "n", pch = 16,
       y.intersp = 0.7) 

legend(-0.20, -0.72, title = "Estimated associations:", legend = c("+","-"), 
       col = c("#ac1214","#0d1fad"), inset = 0.02, cex = 1.5, lty = 1, lwd = 3, 
       bty = "n", horiz = TRUE, y.intersp = 0.5)

# Close device
dev.off()

# Betweenness as node size and hub definition
svg("Results/Figures/Family_and_Phylum_nets/svg/spring_nets_family_phyl_betw.svg", width=20, height=10)
# png("Results/Figures/Family_and_Phylum_nets/png/spring_nets_family_phyl_betw.png", width=1500, height=750)
spring_nets_plot <- plot(props_spring_nets,
                         layout = "spring",
                         sameLayout = FALSE,
                         layoutGroup = "union",
                         repulsion = 0.8,
                         nodeColor = "feature", 
                         featVecCol = phyla,
                         colorVec =  phylcol,
                         edgeTranspLow = 0,
                         edgeTranspHigh = 40,
                         nodeSize = "betweenness",
                         posCol = "#ac1214", 
                         negCol = "#0d1fad",
                         shortenLabels = "intelligent",
                         labelLength = 7,
                         labelScale = FALSE,
                         rmSingles = TRUE,
                         cexNodes = 1.5, 
                         cexLabels = 0.9,
                         nodeSizeSpread = 3,
                         cexHubLabels = 1,
                         hubBorderCol = "snow4",
                         cexTitle = 2.5,
                         groupNames = c("", ""))

legend(-0.10, 1, cex = 1, pt.cex = 1.5, title = 'Phylum:', title.adj = 0,
       legend=levels(phyla), col = phylcol, bty = "n", pch = 16,
       y.intersp = 0.7) 

legend(-0.20, -0.72, title = "Estimated associations:", legend = c("+","-"), 
       col = c("#ac1214","#0d1fad"), inset = 0.02, cex = 1.5, lty = 1, lwd = 3, 
       bty = "n", horiz = TRUE, y.intersp = 0.5)

# Close device
dev.off()

# CCLASSO - Both nets
# Degree as node size and hub definition
svg("Results/Figures/Family_and_Phylum_nets/svg/cclasso_nets_family_phyl_deg.svg", width=20, height=10)
# png("Results/Figures/Family_and_Phylum_nets/png/cclasso_nets_family_phyl_deg.png", width=1500, height=750)
cclasso_nets_plot <- plot(props_cclasso_nets,
                         layout = "spring",
                         sameLayout = FALSE,
                         layoutGroup = "union",
                         repulsion = 0.9,
                         nodeColor = "feature", 
                         featVecCol = phyla,
                         colorVec =  phylcol,
                         edgeTranspLow = 0,
                         edgeTranspHigh = 40,
                         nodeSize = "degree",
                         posCol = "#ac1214", 
                         negCol = "#0d1fad",
                         shortenLabels = "intelligent",
                         labelLength = 7,
                         labelScale = FALSE,
                         rmSingles = TRUE,
                         cexNodes = 2, 
                         cexLabels = 0.9,
                         nodeSizeSpread = 3,
                         cexHubLabels = 1,
                         hubBorderCol = "snow4",
                         cexTitle = 2.5,
                         groupNames = c("", ""))

legend(-0.10, 1, cex = 1, pt.cex = 1.5, title = 'Phylum:', title.adj = 0,
       legend=levels(phyla), col = phylcol, bty = "n", pch = 16,
       y.intersp = 0.7) 

legend(-0.20, -0.72, title = "Estimated associations:", legend = c("+","-"), 
       col = c("#ac1214","#0d1fad"), inset = 0.02, cex = 1.5, lty = 1, lwd = 3, 
       bty = "n", horiz = TRUE, y.intersp = 0.5)

# Close device
dev.off()

# Betweenness as node size and hub definition
# svg("Results/Figures/Family_and_Phylum_nets/svg/cclasso_nets_family_phyl_betw.svg", width=20, height=10)
png("Results/Figures/Family_and_Phylum_nets/png/cclasso_nets_family_phyl_betw.png", width=1500, height=750)
cclasso_nets_plot <- plot(props_cclasso_nets,
                          layout = "spring",
                          sameLayout = FALSE,
                          layoutGroup = "union",
                          repulsion = 0.9,
                          nodeColor = "feature", 
                          featVecCol = phyla,
                          colorVec =  phylcol,
                          edgeTranspLow = 0,
                          edgeTranspHigh = 40,
                          nodeSize = "betweenness",
                          posCol = "#ac1214", 
                          negCol = "#0d1fad",
                          shortenLabels = "intelligent",
                          labelLength = 7,
                          labelScale = FALSE,
                          rmSingles = TRUE,
                          cexNodes = 2, 
                          cexLabels = 0.9,
                          nodeSizeSpread = 4,
                          cexHubLabels = 1,
                          hubBorderCol = "snow4",
                          cexTitle = 2.5,
                          groupNames = c("Forest", "Pasture"))

legend(-0.10, 1, cex = 1, pt.cex = 1.5, title = 'Phylum:', title.adj = 0,
       legend=levels(phyla), col = phylcol, bty = "n", pch = 16,
       y.intersp = 0.7) 

legend(-0.20, -0.72, title = "Estimated associations:", legend = c("+","-"), 
       col = c("#ac1214","#0d1fad"), inset = 0.02, cex = 1.5, lty = 1, lwd = 3, 
       bty = "n", horiz = TRUE, y.intersp = 0.5)

# Close device
dev.off()
