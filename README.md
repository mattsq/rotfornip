
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rotfornip

<!-- badges: start -->

<!-- badges: end -->

The goal of rotfornip is to extend parsnip to handle rotationforest
models as an engine for rand\_forest()

## Installation

This package isn’t on CRAN - and won’t be, unless someone submits a
rotationforest implementation there that I wrap.

The development version from [GitHub](https://github.com/) can be
installed with:

``` r
# install.packages("devtools")
devtools::install_github("mananshah99/rotationforest")
devtools::install_github("mattsq/rotfornip")
```

## Example

Here’s how you’d use it:

``` r
library(tidymodels)
#> Warning: replacing previous import 'vctrs::data_frame' by 'tibble::data_frame'
#> when loading 'dplyr'
#> -- Attaching packages -------------------------------------------------------------------------------------------- tidymodels 0.1.1 --
#> v broom     0.7.0      v recipes   0.1.13
#> v dials     0.0.8      v rsample   0.0.7 
#> v dplyr     1.0.0      v tibble    3.0.3 
#> v ggplot2   3.3.2      v tidyr     1.1.2 
#> v infer     0.5.3      v tune      0.1.1 
#> v modeldata 0.0.2      v workflows 0.1.3 
#> v parsnip   0.1.3      v yardstick 0.0.7 
#> v purrr     0.3.4
#> -- Conflicts ----------------------------------------------------------------------------------------------- tidymodels_conflicts() --
#> x purrr::discard() masks scales::discard()
#> x dplyr::filter()  masks stats::filter()
#> x dplyr::lag()     masks stats::lag()
#> x recipes::step()  masks stats::step()
library(rotationForest)
library(rotfornip)
```

Here we’ll use the two\_class\_dat example model from modeldata

``` r
#
 data("two_class_dat", package = "modeldata")
 set.seed(4622)
 example_split <- initial_split(two_class_dat, prop = 0.7)
 example_train <- training(example_split)
 example_test  <-  testing(example_split)
 bs_train <- bootstraps(example_train)
```

A simple fit/predict example:

``` r

 model <- rand_forest(trees = 100, mtry = 1, mode = "classification") %>%
   set_engine(engine = "rotationForest")
 rot_for_fit <- model %>%
   fit(Class ~ ., data =  example_train)
 predict(rot_for_fit, new_data = example_train)
#> # A tibble: 554 x 1
#>    .pred_class
#>    <fct>      
#>  1 Class1     
#>  2 Class2     
#>  3 Class1     
#>  4 Class2     
#>  5 Class1     
#>  6 Class2     
#>  7 Class2     
#>  8 Class2     
#>  9 Class2     
#> 10 Class1     
#> # ... with 544 more rows
```

A more complex example:

``` r

 recipe_rot <- recipe(Class ~ ., data = example_train) %>%
   step_normalize(all_predictors())
 model_grid <- rand_forest(trees = tune(), mtry = tune(), mode = "classification") %>%
   set_engine(engine = "rotationForest")
 wf <- workflow() %>%
   add_recipe(recipe_rot) %>%
   add_model(model_grid)
 grid_rot <- grid_random(mtry(range = c(1,2)), trees(), size = 3)

grid_results <- tune_grid(wf, resamples = bs_train, grid = grid_rot)

collect_metrics(grid_results)
#> # A tibble: 6 x 8
#>    mtry trees .metric  .estimator  mean     n std_err .config
#>   <int> <int> <chr>    <chr>      <dbl> <int>   <dbl> <chr>  
#> 1     2  1366 accuracy binary     0.794    25 0.00402 Model1 
#> 2     2  1366 roc_auc  binary     0.821    25 0.00480 Model1 
#> 3     1  1998 accuracy binary     0.805    25 0.00536 Model2 
#> 4     1  1998 roc_auc  binary     0.848    25 0.00651 Model2 
#> 5     2  1378 accuracy binary     0.794    25 0.00402 Model3 
#> 6     2  1378 roc_auc  binary     0.821    25 0.00480 Model3
```
