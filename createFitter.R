if (!"nnet" %in% installed.packages()) {
  install.packages("nnet")
}
library(nnet)
if (!"tidyverse" %in% installed.packages()) {
  install.packages("tidyverse")
}
library(tidyverse)

### Cleaning
rm(list = ls())

createFitter <- function(size) {
  function(data, formula) {
    target <- as.character(formula[2])
    feature <- all.vars(formula)[-1]
    if(length(feature) == 1 && feature == ".") {
      feature <- setdiff(names(data), target)
    }
    model <- nnet(model.matrix(formula, data)[, -1], data[which(colnames(data)==target)], size=size, linout = TRUE, trace = FALSE)
    
    function(newData) {
      if (!all(feature %in% names(newData))) {
        stop("New data has different features!")
      }
      predictions <- predict(model, newData)
      newData$prediction <- predictions
      return(newData)
    }
  }
}

# Example 1
d <- tibble(
  x = rnorm(10^3),
  y = x^2 + 3 * cos(x) + rnorm(10^3, sd = 0.4)
)

### Testing set
dTest <- tibble(
  x = seq(
    from = min(d$x),
    to = max(d$x),
    length.out = 100)) ## features
fitter <- createFitter(size = 10)
predictor <- fitter(formula = y ~ x, data = d)

### Visualizing example results
x11()
plot(d, pch = 20,
     col = rgb(1, 0, .5, 0.2),
     xlab = "feature", ylab = "target")
grid(lty = "solid", col = "lightgray")

lines(x = predictor(newData = dTest),
      col = rgb(.5, 0, 1, .9),
      lwd = 2)

# Example 2
fitter <- createFitter(size = 3)
predictor <- fitter(formula = y ~ x, data = d)

### Visualizing results
x11()
plot(d, pch = 20,
     col = rgb(1, 0, .5, 0.2),
     xlab = "feature", ylab = "target")
grid(lty = "solid", col = "lightgray")

lines(x = predictor(newData = dTest),
      col = rgb(.5, 0, 1, .9),
      lwd = 2)

# Example 3
d1 <- tibble(
  x = rnorm(10^3, mean = -5),
  y = (x + 5)^2 + 3 * cos(x) + rnorm(10^3, sd = 0.4)
)
d2 <- tibble(
  x = rnorm(10^3, mean = 5),
  y = (x - 5)^2 + 3 * cos(x) + rnorm(10^3, sd = 0.4)
)
d <- rbind(d1, d2)

### Creating a test dataset
dTest <- tibble(
  x = seq(
    from = min(d$x),
    to = max(d$x),
    length.out = 100)) ## features

fitter3 <- createFitter(size = 3)
fitter20 <- createFitter(size = 20)
predictor3 <- fitter3(formula = y ~ x, data = d)
predictor20 <- fitter20(formula = y ~ x, data = d)

### Visualizing results
x11()
plot(d, pch = 20,
     col = rgb(1, 0, .5, 0.2),
     xlab = "feature", ylab = "target")
grid(lty = "solid", col = "lightgray")
lines(x = predictor3(newData = dTest),
      col = rgb(.5, 0, 1, .9),
      lwd = 2)
lines(x = predictor20(newData = dTest),
      col = rgb(0, .5, 1, .9),
      lwd = 2)


# -----------------------------------------------------------------------------------
# lines method
PredictedData <- function(data) {
  class(data) <- c("PredictedData", "data.frame")
  return(data)
}

lines.PredictedData <- function(data, col = "blue", lwd = 2, ...) {
  lines(data$x, data$prediction, col = col, lwd = lwd, ...)
}

predicted_data <- predictor(newData = dTest)
predicted_data <- PredictedData(predicted_data)

x11()
plot(d$x, d$y, pch = 20, col = rgb(1, 0, 0.5, 0.2), xlab = "feature", ylab = "target")
grid(lty = "solid", col = "lightgray")

lines(predicted_data, col = rgb(0.5, 0, 1, 0.9), lwd = 2)
