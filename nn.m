clc
load("inputs_targets.mat")

% Define number of neurons for the hidden layer of the NN
hiddenLayerSize = 10;

% Create a Pattern Recognition Network with the defined number of hidden layers.
% `patternnet` is specific for pattern-recognition NNs
net = patternnet(hiddenLayerSize);
%{
patternnet() is specialized for pattern recognition problems. 
- Default training algo: Scaled conjugate gradient backpropagation (trainscg). 
    * trainscg's goal: minimize a cost function.
- Default loss cost function: Cross-entropy.
    * This function measures the performance of a classification model whose 
    output varies between 0 and 1. 
    * Cross-entropy loss increases as the prediction probability diverges 
    from the output value. 
    * Therefore, small values -> good performance, large values -> bad performance.
%}

% Set up Division of Data for Training, Validation, Testing Subsets
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
% inputs = inputs';
% targets = targets';
[net, tr] = train(net, inputs, targets);

% Visualise the NN architecture
% view(net)

% -----------------------
% Test the Network with the test subset from the current dataset
% -----------------------
%  get the indices/positions randomly selected for the test dataset (15%)
tInd = tr.testInd;

%  obtain the NN's predictions of the test data
tstInputs = inputs(:,tInd);
tstOutputs = net(tstInputs);

%  compare the NN's predictions against the training set
actualTstOutputs = targets(:,tInd);
tstPerform = perform(net, actualTstOutputs, tstOutputs);

%  plot the confusion matrix
% plotconfusion(targets(:,tInd),tstOutputs)


fprintf('\nPatternnet performance: %f\n', tstPerform);
fprintf('num_epochs: %d, stop: %s\n\n', tr.num_epochs, tr.stop);


