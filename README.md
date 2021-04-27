# prosthetic-predictor
This is a MATLAB-based machine learning project used to classify 5 different activities of daily living from IMU data. Two separate machine learning models are built, tested and optimised.

1. Multi-Class one-vs-all Support Vector Machine (SVM) 
2. Pattern Recognition Artificial Neural Network (ANN).

An IMU is an Inertial Measurement Unit that contains an accelerometer, gyroscope and a magnetometer.

-----------
</br>

## How to Run
1. Clone the repo using `git clone https://github.com/ZiadAbass/prosthetic-predictor.git --depth 1`. 
>NOTE: This depth specification makes git ignore the repo's commit history, which includes irrelevant binary files that would otherwise make the repo size too big.
2. Change your MATLAB directory to that of the repo
3. Run `main.m` and you're good to go!
>NOTE: There are some optional function calls commented out in `main.m`. Look through the file to determine the code flow.

-----------
</br>

## The Data
The data used was obtained during a study led by Professor Abbas Dehghani-Sanij at the University of Leeds. It was collected from various healthy volunteers who wore 5 IMU sensors on different parts of the body:
- Right foot
- Left foot
- Right thigh
- Left thigh
- Pelvis

While each wearing these 5 IMU sensors, they performing the following 5 activities of daily living:
- Level-Ground walking ([LGW](/LGW))
- Going up a ramp ([RA](/RA))
- Going down a ramp ([RD](RD))
- Standing to sitting ([StS](StS))
- Sitting to standing ([SiS](SiS))

</br>

-----------
</br>

## Data Preprocessing
### Filtering
Data is filtered using a low pass filter with a sampling rate of 100 and a cut-off frequency of 7Hz. Researchers using IMUs tend to use low-pass filters to minimise the effect of sensor white noise as they are sensitive to the high-frequency noise produced by system vibration. Fast Fourier Transforms was used to help decide on the cut-off frequency.

</br>

### Feature Extraction
The following seven time-domain features are extracted from a sliding time window of 400ms going in increments (∆t) of 50ms:
- Maximum
- Minimum
- Mean
- Root Mean Square
- Standard Deviation
- Zero Crossing (binary)
- Maximum Slope Change

The average time-step for every dataset is found, and the window size and ∆t are converted accordingly from milliseconds to number of readings. 

</br>

### Structuring the Data
The data is structured to have a single 9859x294 array containing features from all body parts for all activities vertically stacked. Magnetometer information is removed as it is irrelevant for classifying human movements that has nothing to do with magnetism. This leaves 294 features (7 time-domain features x 7 body segments x 6 IMU measurements).

</br>

### Finding the Most Influencial IMU
It is not practical to need 5 IMU sensors for every person to be able to predict intent. We therefore want to find the IMU sensor location which provides data that is most relevant to the ML algorithms. To do that, the top 15 features are found first using a minimum redundancy maximum relevance (mrmr) algorithm. From these 15, it was apparent that the Right Thigh IMU appeared the most times in the top 15 features. This signified that it likely is the most relevant segment in classifying the data into the 5 activities. 


</br>

-----------
</br>

## The Artificial Neural Network Model

- **Scaled conjugate gradient backpropagation** (trainscg) training algorithm is chosen as it built
the most accurate classifier for our data (Table 6). It works well with various problems by
taking advantage of backpropagation for calculating the derivative of performance against
bias and weights.
- Since the data is not linearly separable, at least one hidden layer is required. **One hidden layer**
with enough neurons was enough to achieve a decent classification accuracy. More layers
would lead to many neurons not being trained enough and hence an over-complicated model.
- Neurons in the **input layer** are **equal to the number of features**, and those in the output layer
are equal to the **number of classes (5)**. Hidden layer neurons should be between the size of the
input and the output layers. Various numbers were tested with the single-segment classifier
and **35 neurons** produced the best model. For all-feature classifier, **201 neurons**
produced the best model.
- **K-Fold Cross Validation** is used for validation. It allows using the limited data in the most
efficient way possible. Essentially, all the data samples take turns in being used to train and
to test by splitting the data into many folds.
- The network assesses it performance using **cross-entropy**, which works well with our data as
it imposes a strong penalty on highly inaccurate predictions, and only a small penalty on
slightly incorrect ones. This is optimal for classification problems.
- Data is **normalised and standardised** before feeding into the network. Both these processes
have been proven to create more accurate and responsive NN and SVM models.


</br>

-----------
</br>


## The Support Vector Machine Model

- **Quadratic kernel function**. This is the type of mathematical function used by the model to
convert the inputs into outputs required. Gaussian functions are most commonly used in
classifiers for having localised solutions at all x-axis coordinates. However, different
functions were tested and the quadratic function kernel was best at classifying the data.
- **Box constraint (C) of 1**. This parameter defines the fault-tolerance of the model by imposing
a penalty for each sample misclassified. A low C leads to a large-margin decision 
5
boundary but also to a higher number of misclassified points. A high C builds a more robust
model at the expense of a much smaller-margin decision boundary. Different values for
C were attempted and 1 seemed a to produce a model with a decent compromise between the
two extremes mentioned.
- Evaluation method based on **posterior probabilities**. The SVM models built were evaluated
using that way as it is more robust than the default hinge binary loss function.


</br>

-----------
</br>

## Results/Conclusions

This work demonstrates that building an accurate SVM and ANN model that can accurately predict user intent
from a single IMU attached to the right thigh is possible. While both the SVM and ANN achieved very similar
final classification accuracies (98.934% and 98.656% respectively), it can be concluded that the ANN model shows
the most promise. This is due to the certainty that collecting more training data from the right thigh segment will
further improve its prediction accuracy. The SVM model may improve by exploring different ways of finding
relevant features, or by using data from more than a single segment. These would form the basis for future
studies.



