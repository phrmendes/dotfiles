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
  "classInt", 
  "sf",
  "parallel",
  "distill",
  "tinytex",
  "reticulate",
  "glue"
)

invisible(
  lapply(
    packages, 
    function(i) {
      if (i %in% rownames(installed.packages()) == FALSE) {
        cat(paste0("\n[INFO] - Instalando ", i, "\n"))
        install.packages(i)
      } else {
        cat(paste0("\n[INFO] - Pacote ", i, " já instalado.\n"))
      }
    } 
  )
)

tinytex::install_tinytex(force = TRUE)