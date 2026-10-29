# Define all unique nodes in the network
nodes <- data.frame(
  name = c(
    "Total Submitted (100%)",            # Index 0
    "Paid on Initial Submission (85%)",  # Index 1
    "Initial Rejection (15%)",           # Index 2
    "Reworked and Paid (6.25%)",         # Index 3
    "Abandoned (6.25%)",                 # Index 4
    "Final Denial (2.5%)"                # Index 5
  )
)

# Define connections using source/target indices and your exact percentages
links <- data.frame(
  source = c(0,    0,    2,    2,    2),   # Origin node index
  target = c(1,    2,    3,    4,    5),   # Destination node index
  value  = c(85.0, 15.0, 6.25, 6.25, 2.5)  # Percentages
)

# Create custom JavaScript color scale (optional)
custom_colors <- 'd3.scaleOrdinal()
  .domain(["Total Submitted", "Paid on Initial Submission", "Initial Rejection", "Reworked and Paid", "Abandoned", "Final Denial"])
  .range(["#2b5c8f", "#2ca02c", "#d95f02", "#7570b3", "#999999", "#e7298a"]);'

# Generate the Sankey Chart
p<-sankeyNetwork(
  Links = links,
  Nodes = nodes,
  Source = "source",
  Target = "target",
  Value = "value",
  NodeID = "name",
  units = "%",
  fontSize = 14,
  fontFamily = "sans-serif",
  nodeWidth = 25,
  nodePadding = 18,
  colourScale = custom_colors,
  #sinksRight = FALSE # Prevents nodes without outgoing links from being forced to the right edge
  sinksRight = TRUE # <--- Pushes all terminal nodes to the far right column
  )

# 5. Inject JavaScript to force "Initial Rejection" label to the left of its node
htmlwidgets::onRender(p, '
  function(el, x) {
    d3.select(el).selectAll(".node text")
      .filter(function(d) { return d.name.indexOf("Initial Rejection") !== -1; })
      .attr("x", -6)
      .attr("text-anchor", "end");
  }
')         
