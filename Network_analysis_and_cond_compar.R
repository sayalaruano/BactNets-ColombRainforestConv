# Import libraries
library(NetCoMi)
library(dplyr)

# Set seed to make results reproducible
set.seed(123)

# Load networks
nets_spring <- readRDS("Results/Networks/nets_spring_ColombRainforest.rds")
nets_cclasso <- readRDS("Results/Networks/nets_cclasso_ColombRainforest.rds")

###############################################################################
########################### Analyze networks ##################################
###############################################################################
props_spring_nets <- netAnalyze(nets_spring, 
                                   centrLCC = FALSE,
                                   avDissIgnoreInf = TRUE,
                                   sPathNorm = TRUE,
                                   clustMethod = "cluster_fast_greedy",
                                   hubPar = "degree", #change it to define hub def
                                   hubQuant = 0.9,
                                   lnormFit = TRUE,
                                   normDeg = FALSE)

props_cclasso_nets <- netAnalyze(nets_cclasso, 
                                centrLCC = FALSE,
                                avDissIgnoreInf = TRUE,
                                sPathNorm = TRUE,
                                clustMethod = "cluster_fast_greedy",
                                hubPar = "degree", #change it to define hub def
                                hubQuant = 0.9,
                                lnormFit = TRUE,
                                normDeg = FALSE)


# Calculate network properties for the networks
summ_props_spring_fam <- capture.output(summary(props_spring_nets, 
                                                    groupNames = c("Forest", "Pasture"), 
                                                    numbNodes = 5L, digits = 3L))

cat(summ_props_spring_fam, file="Results/Net_prop_summary/summ_props_spring_fam_betw.txt",
    sep="\n",append=FALSE)

summ_props_cclasso_fam <- capture.output(summary(props_cclasso_nets, 
                                                    groupNames = c("Forest", "Pasture"), 
                                                    numbNodes = 5L, digits = 3L))

cat(summ_props_cclasso_fam, file="Results/Net_prop_summary/summ_props_cclasso_fam_betw.txt",
    sep="\n",append=FALSE)

###############################################################################
########################### Visual comparison #################################
###############################################################################
# SPRING
# Degree as node size and hub definition
svg("Results/Figures/Family_nets/svg/spring_nets_family_deg.svg", width=20, height=10)
# png("Results/Figures/Family_nets/png/spring_nets_family_deg.png", width=1500, height=750)
spring_nets_plot <- plot(props_spring_nets,
                         layout = "spring",
                         sameLayout = FALSE,
                         layoutGroup = "union",
                         repulsion = 0.8,
                         nodeColor = "cluster",
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
                         groupNames = c("A)", "B)"))

legend(-0.20, -0.68, title = "Estimated associations:", legend = c("+","-"), 
       col = c("#ac1214","#0d1fad"), inset = 0.02, cex = 1.5, lty = 1, lwd = 3.5, 
       bty = "n", horiz = TRUE, y.intersp = 0.7)

# Close device
dev.off()

# Betweenness as node size and hub definition
# svg("Results/Figures/Family_nets/svg/spring_nets_family_betw.svg", width=20, height=10)
png("Results/Figures/Family_nets/png/spring_nets_family_betw.png", width=1500, height=750)
spring_nets_plot <- plot(props_spring_nets,
                         layout = "spring",
                         sameLayout = FALSE,
                         layoutGroup = "union",
                         repulsion = 0.8,
                         nodeColor = "cluster",
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

legend(-0.20, -0.68, title = "Estimated associations:", legend = c("+","-"), 
       col = c("#ac1214","#0d1fad"), inset = 0.02, cex = 1.5, lty = 1, lwd = 3.5, 
       bty = "n", horiz = TRUE, y.intersp = 0.7)

# Close device
dev.off()

# Create a dataframe with the shortened and full node names
forest_spring_node_names <- data.frame(Short_name = spring_nets_plot$labels$labels1)
forest_spring_node_names$Full_name <- row.names(spring_nets_plot$layout$layout1)

pasture_spring_node_names <- data.frame(Short_name = spring_nets_plot$labels$labels2)
pasture_spring_node_names$Full_name <- row.names(spring_nets_plot$layout$layout2)

# Load taxonomy df
tax_bact_familyrenamed <- read.csv("Data/tax_bact_familyrenamed.csv")

# Add a column with the species data 
fam_sp_df <- tax_bact_familyrenamed %>% 
  select(Family, Species, Phylum) %>%
  mutate(Species = ifelse(Species == "sBacteria", NA, Species)) %>%
  rename(Full_name = Family)

forest_spring_node_names <- merge(forest_spring_node_names, fam_sp_df, by = "Full_name")
pasture_spring_node_names <- merge(pasture_spring_node_names, fam_sp_df, by = "Full_name")

# Export csv files
write.csv(forest_spring_node_names, 
          "Results/Figures/Family_nets/Node_names_in_nets/forest_spring_node_names.csv",
          row.names = FALSE)

write.csv(pasture_spring_node_names, 
          "Results/Figures/Family_nets/Node_names_in_nets/pasture_spring_node_names.csv",
          row.names = FALSE)

# CCLASSO - Both nets
# Degree as node size and hub definition
svg("Results/Figures/Family_nets/svg/cclasso_nets_family_deg.svg", width=20, height=10)
# png("Results/Figures/Family_nets/png/cclasso_nets_family_deg.png", width=1500, height=750)
cclasso_nets_plot <- plot(props_cclasso_nets,
                         layout = "spring",
                         sameLayout = FALSE,
                         layoutGroup = "union",
                         repulsion = 0.9,
                         nodeColor = "cluster",
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
                         groupNames = c("A)", "B)"))

legend(-0.20, -0.68, title = "Estimated associations:", legend = c("+","-"), 
       col = c("#ac1214","#0d1fad"), inset = 0.02, cex = 1.5, lty = 1, lwd = 3.5, 
       bty = "n", horiz = TRUE, y.intersp = 0.7)

# Close device
dev.off()

# Betweenness as node size and hub definition
svg("Results/Figures/Family_nets/svg/cclasso_nets_family_betw.svg", width=20, height=10)
# png("Results/Figures/Family_nets/png/cclasso_nets_family_betw.png", width=1500, height=750)
cclasso_nets_plot <- plot(props_cclasso_nets,
                          layout = "spring",
                          sameLayout = FALSE,
                          layoutGroup = "union",
                          repulsion = 0.9,
                          nodeColor = "cluster",
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
                          groupNames = c("", ""))

legend(-0.20, -0.68, title = "Estimated associations:", legend = c("+","-"), 
       col = c("#ac1214","#0d1fad"), inset = 0.02, cex = 1.5, lty = 1, lwd = 3.5, 
       bty = "n", horiz = TRUE, y.intersp = 0.7)

# Close device
dev.off()

# Create a dataframe with the shortened and full node names
forest_cclasso_node_names <- data.frame(Short_name = cclasso_nets_plot$labels$labels1)
forest_cclasso_node_names$Full_name <- row.names(cclasso_nets_plot$layout$layout1)

pasture_cclasso_node_names <- data.frame(Short_name = cclasso_nets_plot$labels$labels2)
pasture_cclasso_node_names$Full_name <- row.names(cclasso_nets_plot$layout$layout2)

# Add a column with the species data 
forest_cclasso_node_names <- merge(forest_cclasso_node_names, fam_sp_df, by = "Full_name")
pasture_cclasso_node_names <- merge(pasture_cclasso_node_names, fam_sp_df, by = "Full_name")

# Export csv files
write.csv(forest_cclasso_node_names, 
          "Results/Figures/Family_nets/Node_names_in_nets/forest_cclasso_node_names.csv",
          row.names = FALSE)

write.csv(pasture_cclasso_node_names, 
          "Results/Figures/Family_nets/Node_names_in_nets/pasture_cclasoo_node_names.csv",
          row.names = FALSE)

###############################################################################
########################### Quantitative comparison ###########################
###############################################################################
# Calculate differences
spring_nets_comp <- netCompare(props_spring_nets,
                               permTest = TRUE,
                               adjust = "adaptBH",
                               nPerm = 100L,
                               cores = 12L,
                               storeCountsPerm = TRUE,
                               fileStoreCountsPerm = c("Results/Quantit_net_comparison/Spring/AdaptBH_adj/countsPerm1_spring",
                                                       "Results/Quantit_net_comparison/Spring/AdaptBH_adj/countsPerm2_spring"),
                               storeAssoPerm = TRUE,
                               fileStoreAssoPerm = "Results/Quantit_net_comparison/Spring/AdaptBH_adj/assoPerm_spring",
                               seed = 123)

cclasso_nets_comp <- netCompare(props_cclasso_nets, 
                                permTest = TRUE,
                                adjust = "adaptBH",
                                nPerm = 100L,
                                cores = 12L,
                                storeCountsPerm = TRUE,
                                fileStoreCountsPerm = c("Results/Quantit_net_comparison/Cclasso/countsPerm1_cclasso",
                                                        "Results/Quantit_net_comparison/Cclasso/countsPerm2_cclasso"),
                                storeAssoPerm = TRUE,
                                fileStoreAssoPerm = "Results/Quantit_net_comparison/Cclasso/assoPerm_cclasso",
                                seed = 123)

# Save the results into txt files
summ_spring_nets_comp <- capture.output(summary(spring_nets_comp, 
                                                groupNames = c("Forest", "Pasture"), 
                                                numbNodes = 5L, digits = 3L))

cat(summ_spring_nets_comp, file="Results/Quantit_net_comparison/Spring/AdaptBH_adj/summ_spring_nets_comp_deg.txt",
    sep="\n",append=TRUE)

summ_cclasso_nets_comp <- capture.output(summary(cclasso_nets_comp, 
                                                 groupNames = c("Forest", "Pasture"), 
                                                 numbNodes = 5L, digits = 3L))

cat(summ_cclasso_nets_comp, file="Results/Quantit_net_comparison/Cclasso/summ_cclasso_nets_comp_deg.txt",
    sep="\n",append=TRUE)

###############################################################################
######################## Differential networks ################################
###############################################################################
# Differential network construction
diff_spring_nets <- diffnet(nets_spring,
                       diffMethod = "fisherTest", 
                       adjust = "lfdr")

diff_cclasso_nets <- diffnet(nets_cclasso,
                            diffMethod = "fisherTest", 
                            adjust = "lfdr")
