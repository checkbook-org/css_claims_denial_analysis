# This creates a Sankey diagram mapping flow of claims by initial denial, reworking, and final denial

# ==============================================================================
# 1. PACKAGE MANAGEMENT WITH RENV
# ==============================================================================
source('initialize_claims_flow_libraries_and_renv.r')

# Load libraries
library(dplyr)
library(ggplot2)
library(ggsankey)
library(networkD3)



# ==============================================================================
# 2. DATA SYNTHESIS FROM PERCENTAGES
# ==============================================================================

# Total simulated population size (1,000 rows gives accurate 0.1% resolution)
N <- 10000

# Calculate exact row counts for each path based on your proportions:
# - Paid on Initial Submission: 85% = 850 rows
# - Initial Rejection -> Reworked & Paid: 6.25% = 62.5 (rounded to 62/63)
# - Initial Rejection -> Abandoned: 6.25% = 62.5
# - Initial Rejection -> Final Denial: 2.5% = 25

df_wide <- bind_rows(
  # Path 1: Initial Submission -> Paid on Initial Submission (85%)
  tibble(
    Submitted = "Total Submitted",
    Initial = "Paid on Initial Submission",
    Final = "Paid on Initial Submission",
    count  = round(N * 0.8500)
  ),
  # Path 2: Initial Rejection -> Reworked and Paid (6.25%)
  tibble(
    Submitted = "Total Submitted",
    Initial = "Initial Rejection",
    Final = "Reworked and Paid",
    count  = round(N * 0.0625)
  ),
  # Path 3: Initial Rejection -> Abandoned (6.25%)
  tibble(
    Submitted = "Total Submitted",
    Initial = "Initial Rejection",
    Final = "Abandoned",
    count  = round(N * 0.0625)
  ),
  # Path 4: Initial Rejection -> Final Denial (2.5%)
  tibble(
    Submitted = "Total Submitted",
    Initial = "Initial Rejection",
    Final = "Final Denial",
    count  = round(N * 0.0250)
  )
) %>%
  # Expand counts back into explicit rows for ggsankey
  tidyr::uncount(count)

# Save constructed dataset to CSV
write.csv(df_wide, "claims_flow_data.csv", row.names = FALSE)

# ==============================================================================
# 3. DATA TRANSFORMATION & SANKEY PLOT
# ==============================================================================

# Convert wide data into long format required by ggsankey
df_long <- df_wide %>%
  make_long(Submitted, Initial, Final)

# Generate Sankey Chart
sankey_plot <- ggplot(df_long, aes(
  x = x, 
  next_x = next_x, 
  node = node, 
  next_node = next_node,
  fill = factor(node),
  label = node
)) +
  geom_sankey(flow.alpha = 0.6, node.color = "gray30") +
  geom_sankey_label(size = 3.5, color = "white", fill = "gray20") +
  scale_fill_viridis_d(option = "plasma", end = 0.9) +
  theme_sankey(base_size = 14) +
  labs(
    title = "Customer Journey Flow",
    subtitle = "Tracking user transitions across stages",
    x = NULL
  ) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold")
  )

# Display the plot
print(sankey_plot)
