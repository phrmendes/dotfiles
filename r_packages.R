packages <- c(
  "pacman",
  "tidyverse",
  "data.table",
  "arrow",
  "duckdb",
  "mice",
  "quarto",
  "renv",
  "devtools",
  "usethis",
  "shiny",
  "furrr",
  "future",
  "gh",
  "janitor",
  "markdown",
  "pbapply",
  "styler",
  "lintr",
  "testthat",
  "fs",
  "Rcpp",
  "RcppEigen",
  "writexl",
  "rmarkdown",
  "rstan",
  "sf",
  "parallel",
  "distill",
  "tinytex",
  "reticulate"
)

invisible(lapply(packages, install.packages))

tinytex::install_tinytex()