library(testthat)
library(rotfornip)

testthat::test_check("rotfornip")



 ## TODO Alla this needs to be turned into a test suite!
# # Testing -----------------------------------------------------------------

# data("two_class_dat", package = "modeldata")
# set.seed(4622)
# example_split <- initial_split(two_class_dat, prop = 0.7)
# example_train <- training(example_split)
# example_test  <-  testing(example_split)
# bs_train <- bootstraps(example_train)
#
# ### this works just fine:
# model <- rand_forest(trees = 100, mtry = 1, mode = "classification") %>%
#   set_engine(engine = "rotationForest")
# rot_for_fit <- model %>%
#   fit(Class ~ ., data =  example_train)
# predict(rot_for_fit, new_data = example_train)
# ## this call works just fine as well:
# parameters(model)
#
# ## this should also work fine
# recipe_rot <- recipe(Class ~ ., data = example_train) %>%
#   step_normalize(all_predictors())
# model_grid <- rand_forest(trees = tune(), mtry = tune(), mode = "classification") %>%
#   set_engine(engine = "rotationForest")
# wf <- workflow() %>%
#   add_recipe(recipe_rot) %>%
#   add_model(model_grid)
# grid_rot <- grid_random(mtry(range = c(1,2)), trees(), size = 3)
# ## it fails here:
# tune_grid(wf, resamples = bs_train, grid = grid_rot)

