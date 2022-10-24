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
  8. all\n
  Enter packages bundles to install (without white space): "
)

choosed_packages <- readLines(con = "stdin", n = 1) |>
  strsplit(split = ",") |>
  unlist()

# requirements ----

invisible(
  lapply(
    c("stringi", "textshaping"),
    function(i) {
      if (!require(i, character.only = TRUE)) install.packages(
        i,
        dependencies = TRUE,
        INSTALL_opts = "--no-lock",
        configure.args = "--disable-pkg-config"
      )
    }
  )
)

if (!require("rjson")) install.packages("rjson")

# packages ----

packages <- rjson::fromJSON(file = "r_packages.json")

if ("all" %in% choosed_packages) {
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
      if (!require(i, character.only = TRUE)) {
        cat(paste0("\n[INFO] - Installing ", i, "\n"))
        install.packages(i, character.only = TRUE)
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
