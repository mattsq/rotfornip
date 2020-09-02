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

  parsnip::set_fit(
    model = "rand_forest",
    eng = "rotationForest",
    mode = "classification",
    value = list(
      interface = "data.frame",
      protect = c("xdf", "ydf"),
      func = c(pkg = "rotationForest", fun = "rotationForest"),
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

