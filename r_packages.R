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
  "glue",
  "rstanarm",
  "brms",
  "varstan",
  "bayesforecast",
  "prophet",
  "languageserver",
  "httpgd"
)

dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)
.libPaths(Sys.getenv("R_LIBS_USER"))

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

install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))

cmdstanr::install_cmdstan()

Sys.setenv(R_STAN_BACKEND = "CMDSTANR")