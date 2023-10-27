# **Evaluating differences in bacterial association networks from rainforest and converted pasturelands in the Colombian Amazon region**

## **Table of contents:**

- [About the project](#about-the-webapp)
- [Dataset](#dataset)
- [Structure of the repository](#structure-of-the-repository)
- [Credits](#credits)
- [Further details](#details)
- [Contact](#contact)

## **About the project**

Microbial association networks (MANs) provide insights into potential ecological interactions among microbes, including mutualism, competition, and more. Furthermore, these networks can reveal communities that share ecological functions or keystone taxa playing crucial roles in the system. In MANs, nodes correspond to Operational Taxonomical Units (OTUs) at a given taxonomic rank, and edges between nodes denote significant co-presence (positive relationships) or mutual exclusion (negative relationships) patterns in OTU abundances across samples. Multiple association metrics are available for inferring MANs, mainly founded on correlation, proportionality, and conditional dependence approaches.

In this project, the CCLasso (correlation-based) and SPRING (conditional dependence-based) methods were used to explore differences in microbiomes found in the rainforest and converted pasturelands of the northwest Colombian Amazon region.

The [NetCoMi R package](https://github.com/stefpeschel/NetCoMi) v1.1 was the central framework to perform the network inference, analysis, visualization, and comparison. It provides a computational workflow that involves calculating associations among OTUs using a specified metric, applying sparsification if necessary, and converting these associations into dissimilarities and subsequently into similarities, resulting in the adjacency matrix for the inferred networks.

## **Dataset**
The raw sequencing data used for this project is available at the [PRJEB44163](https://www.ebi.ac.uk/ena/browser/view/PRJEB44163) project from the European Nucleotide Archive (ENA) database. This research collected 52 soil samples from the Colombian Amazon region: 36 from rainforest areas and 16 from converted pasturelands. The rainforest samples were the reference with minimal intervention, while the pastureland represented the land use systems.

[MGnify](https://www.ebi.ac.uk/metagenomics) is a platform that automates the analysis of metagenomics datasets from ENA and other databases. The abundance table and taxonomic profiles to infer the MANs in this project were obtained from the [MGYS00005779](https://www.ebi.ac.uk/metagenomics/studies/MGYS00005779) study, which applied the MGnify's pipeline v5. The first step was downloading the data and metadata using the MGnifyR package v0.1, enabling the utilization of the MGnify API in R scripts. Then, the data was preprocessed and manipulated using the Phyloseq v1.44 and Microbiome v1.22 R packages. The dataset was filtered to retrieve only bacterial OTUs, excluding taxa from other life kingdoms. In addition, the data was aggregated at the family taxonomic level, obtaining 200 OTUs.

## **Structure of the repository**

The main files and directories of this repository are:

|File|Description|
|:-:|---|
|[Fetch_analyses_Mgnify.ipynb](Fetch_analyses_Mgnify.ipynb)|Jupyter notebook to retrieve data from MGnify using MGnifyR|
|[Preprocessing_metag_data.R](Preprocessing_metag_data.R)|Script to preprocess the metagenomics dataset|
|[Build_bact_assoc_nets.R](Build_bact_assoc_nets.R)|Script to infer bacterial association networks|
|[Network_analysis_and_cond_compar.R](Network_analysis_and_cond_compar.R)|Script to analyze, visualize, and compare networks|
|[Networks_fam_and_phylum.R](Networks_fam_and_phylum.R)|Script to make visualization of networks colored by Phylum|
|[Compare_pred_edges_inf_methods.R](Compare_pred_edges_inf_methods.R)|Script to calculate coincidence percentage of associations among networks|
|[Data/](Data/)|Folder with the metagenomics data stored in a phyloseq object|
|[Results/](/Results/)|Folder with edge lists of inferred networks, figures, and txt with comparison results|

## **Credits**
- Developed by [Sebastián Ayala Ruano](https://sayalaruano.github.io/).  This was my capstone project of the Network Biology course from the [Master's degree in Systems Biology](https://www.maastrichtuniversity.nl/education/master/systems-biology) at [Maastricht University](https://www.maastrichtuniversity.nl/).

## **Further details**
More details about the biological background of the project, the interpretation of the results, and ideas for further work are available in this [pdf report](Bact_nets_Colomb_rainforest.pdf).

## **Contact**
If you have comments or suggestions about this project, you can [open an issue](https://github.com/sayalaruano/Bact_nets_Colomb_rainforest_conv/issues/new) in this repository, or email me at sebasar1245@gamil.com.
