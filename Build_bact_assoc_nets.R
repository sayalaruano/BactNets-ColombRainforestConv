# Import libraries
library(NetCoMi)
library(phyloseq)
library(microbiome)

# Set seed to make results reproducible
set.seed(123)

# Load data
Col_forest_metag_filt_phy <- readRDS("Data/Colomb_forest_metag_phy_filtered.rds")

# Create phyloseq file at the family level
phy_family = tax_glom(Col_forest_metag_filt_phy, taxrank="Family")

# Rename taxonomic table and make Family unique
phy_familyrenamed <- renameTaxa(phy_family, 
                               pat = "<name>", 
                               substPat = "<name>_<subst_name>(<subst_R>)",
                               numDupli = "Family")

# Convert taxonomic information into a data frame and save it
tax_bact_familyrenamed <- data.frame(tax_table(phy_familyrenamed))
write.csv(tax_bact_familyrenamed, "Data/tax_bact_familyrenamed.csv",
          row.names = FALSE)

# Split the samples by condition
forest <- phyloseq::subset_samples(phy_familyrenamed, sample_environment.feature == "ENVO:00001998")
pasture  <- phyloseq::subset_samples(phy_familyrenamed, sample_environment.feature == "ENVO:00005773")

# SPRING networks
nets_spring <- netConstruct(forest,
                            pasture,
                            taxRank = "Family",
                            measure = "spring",
                            measurePar = list(nlambda = 10, 
                                              rep.num = 10,
                                              thresh = 0.02),
                            normMethod = "none", 
                            zeroMethod = "none",
                            sparsMethod = "none",
                            dissFunc = "signed",
                            verbose = 3,
                            seed = 123)

# Save an object to a file
saveRDS(nets_spring, file = "Results/Networks/nets_spring_ColombRainforest.rds")

# Export the networks as edge lists
forest_spring_fam_net_df <- as.data.frame(do.call(cbind, nets_spring$edgelist1))
write.csv(forest_spring_fam_net_df, "Results/Networks/Forest_spring_fam_net_edgelist.csv")

pasture_spring_fam_net_df <- as.data.frame(do.call(cbind, nets_spring$edgelist2))
write.csv(pasture_spring_fam_net_df, "Results/Networks/Pasture_spring_fam_net_edgelist.csv")

# CCLasso networks
nets_cclasso <- netConstruct(forest, 
                             pasture,
                             taxRank = "Family",
                             measure = "cclasso",
                             normMethod = "none", 
                             zeroMethod = "pseudoZO",
                             sparsMethod = "threshold",
                             thresh = 0.2,
                             dissFunc = "signed",
                             verbose = 3,
                             seed = 123)

# Save an object to a file
saveRDS(nets_cclasso, file = "Results/Networks/nets_cclasso_ColombRainforest.rds")

# Export the networks as edge lists
forest_cclasso_fam_net_df <- as.data.frame(do.call(cbind, nets_cclasso$edgelist1))
write.csv(forest_cclasso_fam_net_df, "Results/Networks/Forest_cclasso_fam_net_edgelist.csv")

pasture_cclasso_fam_net_df <- as.data.frame(do.call(cbind, nets_cclasso$edgelist2))
write.csv(pasture_cclasso_fam_net_df, "Results/Networks/Pasture_cclasso_fam_net_edgelist.csv")