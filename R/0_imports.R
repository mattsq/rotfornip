#' @importFrom parsnip set_new_model
#' @importFrom stats predict

# ------------------------------------------------------------------------------

# The functions below define the model information. These access the model
# environment inside of parsnip so they have to be executed once parsnip has
# been loaded.

.onLoad <- function(libname, pkgname) {
  # This defines rotationforest in the model database
  add_rotationforest_engine()
}
