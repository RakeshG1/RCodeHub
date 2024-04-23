# Import Libraries #
# ---------------- #
pacman::p_load(plumber)


# Run R API Code #
# -------------- #
sample_api <- plumber::plumb("C:/Users/rakes/Local/Git_Repo/RCodeHub/PlumberApps/Sample_API.R")
sample_api$run(host = '127.0.0.1', port = 8080, swagger = TRUE)