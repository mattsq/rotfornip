# These functions are tested indirectly when the models are used. Since this
# function is executed on package startup, you can't execute them to test since
# they are already in the parsnip model database. We'll exclude them from
# coverage stats for this reason.

# nocov

add_rotationforest_engine <- function() {

  parsnip::set_model_mode(model = "rand_forest", mode = "classification")
  parsnip::set_model_engine(
    "rand_forest",
    mode = "classification",
    eng = "rotationForest"
  )
  parsnip::set_dependency("rand_forest", eng = "rotationForest", pkg = "rotationForest")
  parsnip::set_model_arg(
    model = "rand_forest",
    eng = "rotationForest",
    parsnip = "mtry",
    original = "npredictor",
    func = list(pkg = "dials", fun = "mtry"),
    has_submodel = FALSE
  )

  parsnip::set_model_arg(
    model = "rand_forest",
    eng = "rotationForest",
    parsnip = "trees",
    original = "ntree",
    func = list(pkg = "dials", fun = "trees"),
    has_submodel = FALSE
  )

  parsnip::set_model_arg(
    model = "rand_forest",
    eng = "rotationForest",
    parsnip = "cp",
    original = "cp",
    func = list(pkg = "dials", fun = "cp"),
    has_submodel = FALSE
  )

  parsnip::set_fit(
    model = "rand_forest",
    eng = "rotationForest",
    mode = "classification",
    value = list(
      interface = "data.frame",
      protect = c("xdf", "ydf"),
      func = c(pkg = "rotfornip", fun = "rotationForest_train"),
      defaults = list()
      )
    )

  class_info <-
    list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args =
        list(
          rotationForestObject = quote(object$fit),
          dependent = quote(new_data),
          prob = FALSE

        )
    )

  parsnip::set_pred(
    model = "rand_forest",
    eng = "rotationForest",
    mode = "classification",
    type = "class",
    value = class_info
  )

  prob_info <-
    list(
      pre = NULL,
      # The predict method returns a matrix so add a post-processor
      post = function(x, object) {
        tibble::as_tibble(x)
      },
      func = c(fun = "predict"),
      args =
        list(
          rotationForestObject = quote(object$fit),
          dependent = quote(new_data),
          prob = TRUE
        )
    )

  parsnip::set_pred(
    model = "rand_forest",
    eng = "rotationForest",
    mode = "classification",
    type = "prob",
    value = prob_info
  )

  parsnip::set_encoding(model = "rand_forest",
               mode = "classification",
               eng = "rotationForest",
               options = list(predictor_indicators = "none",
                              compute_intercept = FALSE,
                              remove_intercept = FALSE))


}

#' @importFrom rpart rpart.control
#' @importFrom rotationForest rotationForest
#' @importFrom dplyr expr
rotationforest_train <- function(x, y, npredictor, ntree, verbose, cp = .01, minsplit = 20L, maxdepth = 30L) {

  rotationforest_call <- dplyr::expr(rotationForest::rotationForest(control = NULL))
  rpart_control_call <- dplyr::expr(rpart::rpart.control(cp = NULL, minsplit = NULL, maxdepth = NULL))

  rotationforest_call$xdf <- x
  rotationforest_call$ydf <- y
  rotationforest_call$npredictor <- npredictor
  rotationforest_call$ntree <- ntree
  rotationforest_call$verbose <- verbose

  rpart_control_call$cp <- cp
  rpart_control_call$minsplit <- minsplit
  rpart_control_call$maxdepth <- maxdepth

  rotationforest_call$control <- rpart_control_call

  return(eval(rotationforest_call))

}

