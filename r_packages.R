# ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
# ██░▄▄▀████░▄▄░█░▄▄▀██░▄▄▀██░█▀▄█░▄▄▀██░▄▄░██░▄▄▄██░▄▄▄░██
# ██░▀▀▄████░▀▀░█░▀▀░██░█████░▄▀██░▀▀░██░█▀▀██░▄▄▄██▄▄▄▀▀██
# ██░██░████░████░██░██░▀▀▄██░██░█░██░██░▀▀▄██░▀▀▀██░▀▀▀░██
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

# parameters ----

options(repos = c(RSPM = "https://packagemanager.rstudio.com/all/latest"))
dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)
.libPaths(Sys.getenv("R_LIBS_USER"))

# user input ----

cat(
  "Package bundles:\n
  1. main
  2. db
  3. geo
  4. cpp
  5. dev
  6. parallel
  7. stan
  8. all"
)

choosed_packages <- readline(
    prompt = "Enter packages bundles to install (without white space): "
  ) |>
  strsplit(split = ",") |>
  unlist()

# requirements ----

if (!require("stringi")) install.packages(
  "stringi",
  dependencies = TRUE,
  INSTALL_opts = "--no-lock",
  configure.args = "--disable-pkg-config"
)

if (!require("rjson")) install.packages("jsonlite")

# packages ----

packages <- rjson::fromJSON(file = "r_packages.json")

if (choosed_packages == "all") {
  vec_packages <- packages |>
    unlist(use.names = FALSE)
} else {
  vec_packages <- lapply(choosed_packages, function(i) packages[[i]]) |>
    unlist(use.names = FALSE)
}

# install packages ----

invisible(
  lapply(
    vec_packages,
    function(i) {
      if (!(i %in% rownames(installed.packages()))) {
        cat(paste0("\n[INFO] - Installing ", i, "\n"))
        install.packages(i)
      } else {
        cat(paste0("\n[INFO] - Package ", i, " already installed.\n"))
      }
    }
  )
)

if ("tinytex" %in% vec_packages) tinytex::install_tinytex(force = TRUE)

if ("cmdstanr" %in% vec_packages) {
  install.packages(
    "cmdstanr",
    repos = c("https://mc-stan.org/r-packages/", getOption("repos"))
  )

  cmdstanr::install_cmdstan()

  Sys.setenv(R_STAN_BACKEND = "CMDSTANR")
}
