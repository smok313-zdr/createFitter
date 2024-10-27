# createFitter

The function `createFitter` is designed to facilitate the creation, training, and prediction stages of a simple MLP (Multilayer Perceptron) neural network model.

### Function overview

**1. Function Signature and Argument:**

* The function `createFitter(size)` takes a single parameter, `size`, which specifies the size of the hidden layer in the MLP. This parameter defines the complexity of the neural network by determining the number of neurons in the hidden layer.

**2. Returns a Fitter Function:**

* `createFitter` returns another function, called a fitter. The fitter is initialized with a defined, yet untrained, neural network model. This fitter function is intended to train the neural network on specific data provided by the user.

**3. Fitter Function Structure:**

* The fitter function accepts two arguments:

  * `formula`: A formula that defines the structure of the training data. The formula uses notation such as `y ~ x`, where `y` is the target variable (the value to predict), and `x` is the feature (or features) used to make predictions. The formula may also use shortcut notation, like `y ~ .`, where all variables except `y` are treated as features.
  * `data`: A data frame (or a compatible class derived from the data frame) containing the training data. This data includes both the target and feature variables specified by the formula.
* Training Process: The fitter function uses the specified `formula` and `data` to train the neural network model, optimizing it based on the relationships within the provided data.

**4. Returning a Predictor Function:**

* Once training is complete, the fitter function returns a predictor function. This predictor function uses the trained model to make predictions on new data.

**5. Predictor Function Structure:**

* The predictor function takes a single argument:

  * `data`: A data frame containing new feature values for prediction.
* Prediction Process: The predictor function outputs the input data frame with an additional column that holds the predicted target values based on the model's learned relationships.

In summary, `createFitter` enables the seamless creation of a neural network model by defining the network, training it with specific data, and using it to predict future outcomes. The design simplifies the workflow by creating a series of nested functions, each focused on a different stage of the machine learning pipeline.
