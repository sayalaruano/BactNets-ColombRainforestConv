# Import libraries
library(phyloseq)
library(microbiome)

# Load data
Col_phy <- readRDS("./Data/Colomb_forest_metag_phy.rds")

# Filter non-bacterial OTUs
nonbact_taxa <- subset_taxa(Col_phy, (Kingdom == "Viridiplantae" | Kingdom == "Fungi"| 
                                        Kingdom == "Metazoa" | Species == "sEukaryota" | 
                                        Species == "sArchaea") | Phylum == "Apicomplexa" |
                              Phylum == "Tubulinea" | Phylum == "Cercozoa" |
                              Phylum == "Thaumarchaeota" | Phylum == "Imbricatea")

bact_Col_phy <- remove_taxa(taxa_names(nonbact_taxa), Col_phy)

# Filter OTUs with NAN or putative Phylum
putat_tax <- subset_taxa(bact_Col_phy, (is.na(Phylum) | 
                                          grepl("Candidatus", Phylum, fixed = TRUE) | 
                                          grepl("candidate", Phylum, fixed = TRUE)))

bact_nonput_Col_phy <- remove_taxa(taxa_names(putat_tax), bact_Col_phy)

# Export filtered dataset
saveRDS(bact_nonput_Col_phy, file = "Data/Colomb_forest_metag_phy_filtered.rds")
