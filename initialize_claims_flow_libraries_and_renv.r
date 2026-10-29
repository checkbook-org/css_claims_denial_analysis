# This section of code initializes libraries and renv

# ==============================================================================
# 1. ENVIRONMENT SETUP (renv)
# ==============================================================================

if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

if (!file.exists("renv.lock")) {
  renv::init(bare = TRUE)
}

cran_packages <- c("dplyr", "ggplot2", "remotes")
for (pkg in cran_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    renv::install(pkg)
  }
}

if (!requireNamespace("ggsankey", quietly = TRUE)) {
  renv::install("davidsjoberg/ggsankey")
}

if (!requireNamespace("networkD3", quietly = TRUE)) {
  renv::install("networkD3")
}




renv::snapshot(prompt = FALSE)
