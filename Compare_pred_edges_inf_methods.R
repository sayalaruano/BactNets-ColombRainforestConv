# Imports 
library(dplyr)

# Create a function to calculate the comparison for one set of data frames
compare_relationships <- function(df1, df2) {
  # Combine the data frames
  combined_df <- bind_rows(df1, df2)
  
  # Group by the pair of strings (ignoring order) and calculate the sum of "asso" values
  result <- combined_df %>%
    group_by(v1, v2) %>%
    summarize(
      combined_association = sum(asso)
    )
  
  # Count the number of relationships
  same_relationships <- sum(result$combined_association == 2 | result$combined_association == -2)
  both_positive <- sum(result$combined_association == 2)
  both_negative <- sum(result$combined_association == -2)
  one_positive_one_negative <- sum(result$combined_association == 0)
  not_coincide <- nrow(result) - same_relationships
  
  # Calculate the percentages
  total_relationships <- nrow(result)
  percentage_same <- (same_relationships / total_relationships) * 100
  percentage_both_positive <- (both_positive / total_relationships) * 100
  percentage_both_negative <- (both_negative / total_relationships) * 100
  percentage_one_positive_one_negative <- (one_positive_one_negative / total_relationships) * 100
  percentage_not_coincide <- (not_coincide / total_relationships) * 100
  
  # Store everything in a df
  df = data.frame(
    "No_coincidence" = percentage_not_coincide,
    "Same_relationships" = percentage_same,
    "Positive" = percentage_both_positive,
    "Negative" = percentage_both_negative,
    "Positive_Negative" = percentage_one_positive_one_negative
  )
  return(t(df))
}

# Load data
past_cclasso_adj = read.csv("Results/Networks/Pasture_cclasso_fam_net_edgelist.csv")
forest_cclasso_adj = read.csv("Results/Networks/Forest_cclasso_fam_net_edgelist.csv")
past_spring_adj = read.csv("Results/Networks/Pasture_spring_fam_net_edgelist.csv")
forest_spring_adj = read.csv("Results/Networks/Forest_spring_fam_net_edgelist.csv")

# Filter just associations
past_cclasso_adj <- past_cclasso_adj %>%
  select(v1, v2, asso) %>%
  mutate(asso = ifelse(asso > 0, 1, -1))

past_spring_adj <- past_spring_adj %>%
  select(v1, v2, asso) %>%
  mutate(asso = ifelse(asso > 0, 1, -1))

forest_cclasso_adj <- forest_cclasso_adj %>%
  select(v1, v2, asso) %>%
  mutate(asso = ifelse(asso > 0, 1, -1))

forest_spring_adj <- forest_spring_adj %>%
  select(v1, v2, asso) %>%
  mutate(asso = ifelse(asso > 0, 1, -1))

# Compare relationships for "Forest" conditions
forest_comparison <- compare_relationships(forest_cclasso_adj, forest_spring_adj)

# Compare relationships for "Pasture" conditions
pasture_comparison <- compare_relationships(past_cclasso_adj, past_spring_adj)

# Compare relationships for "Pasture" conditions
pasture_forest_cclasso <- compare_relationships(past_cclasso_adj, forest_cclasso_adj)

# Compare relationships for "Pasture" conditions
pasture_forest_spring <- compare_relationships(past_spring_adj, forest_spring_adj)

# Create the resulting data frame
result_df <- data.frame(forest_comparison, pasture_comparison, pasture_forest_cclasso, pasture_forest_spring)

# Display the resulting data frame
colnames(result_df) <- c("Forest", "Pasture", "CCLasso", "SPRING")

options(digits = 2)

result_df
