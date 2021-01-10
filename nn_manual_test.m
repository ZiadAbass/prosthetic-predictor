%{
This file is the same as nn.m except for that the test data is manually
taken from the array before training is done, then is given to the trained
model to test it manually.
%}

clc

load("inputs_targets.mat")

% Define number of neurons for the hidden layer of the NN
hiddenLayerSize = 10;

% Create a Pattern Recognition Network with the defined number of hidden layers.
% `patternnet` is specific for pattern-recognition NNs
net = patternnet(hiddenLayerSize);

% Set up Division of Data for Training, Validation, Testing Subsets
net.divideParam.trainRatio = 85/100;
net.divideParam.valRatio = 15/100;

% before splitting into inputs and targets shuffle the rows
random_final_labelled_data = final_labelled_data(randperm(size(final_labelled_data, 1)), :);

% set some percentage of it aside for testing
test_percent = 15;
test_element_count = uint32((test_percent/100)*length(random_final_labelled_data));

% Define which features to include in the input set.
train_inputs = random_final_labelled_data(1:end-test_element_count,1:end-5)';    % Take all the rows, and all the 10 features as inputs. Could also use: inputs = dataSet(:,1:end-2).
test_inputs= random_final_labelled_data(end-test_element_count+1:end,1:end-5)';

% Define the target set
train_targets = random_final_labelled_data(1:end-test_element_count, end-4:end)'; 
test_targets = random_final_labelled_data(end-test_element_count+1:end, end-4:end)'; 

% Train the Network
[net, tr] = train(net, train_inputs, train_targets);

% -----------------------
% Test the Network with the test subset from the current dataset
% -----------------------
actualTstOutputs = net(test_inputs);

%  compare the NN's predictions against the training set
idealTstOutputs = test_targets;
tstPerform = perform(net, idealTstOutputs, actualTstOutputs);

%  plot the confusion matrix
plotconfusion(idealTstOutputs,actualTstOutputs);

fprintf('\nPatternnet performance: %f\n', tstPerform);
fprintf('num_epochs: %d, stop: %s\n\n', tr.num_epochs, tr.stop);


