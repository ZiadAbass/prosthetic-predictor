%{
% good practice to start with these
clear;      % clear the workspace
clc;        % clear the command window
close all;  % close all popup windows

rng(0)  % to achieve same randomisation each time

%Load dataset into the workspace
LGW_Data = readtable("../../Practicals/Session 2/normal_walk_J_trial_01.dat", "ReadVariableNames",true);  % level ground walking data
SA_Data = readtable("../../Practicals/Session 2/stair_asc_jun_trial_01.dat", "ReadVariableNames",true);  % level ground walking data

% can also use 'import data' from the toolbar at the top


%Extract pelvis data (numeric)
LGW_dataRange = [61:70];    % only concerned with these columns - the 9 variables from pelvis IMU + the timestamp
SA_dataRange = [63:72];
LGW_Pelvis = LGW_Data{:,LGW_dataRange};  % extract all the rows from th columns defined in dataRange
SA_Pelvis = SA_Data{:,SA_dataRange};  % extract all the rows from th columns defined in dataRange

% data still missing which class the data belongs to. We need encoding.



% need to translate the label to a numerical format
% 1 -> sample belongs to the LGW class
% 0 -> sample does not belong to LGW class

%Create an array of ones, and an array of zeros that matches the number of
%rows of each activity

%LGW Dataset -----------------------------
varLength = length(LGW_Pelvis);
% create a column with zeroes and another one with ones to add to the right
% of the existing data. This is to label each row to specify which class it
% belongs to
var1 = ones(varLength, 1);     % rows not columns
var2 = zeros(varLength, 1);
LGW_Pelvis_Full = horzcat(LGW_Pelvis, var1, var2);   % concatenate to add the two columns on the RHS

%SA Dataset ------------------------------
varLength = length(SA_Pelvis);
var1 = ones(varLength, 1);     % rows not columns
var2 = zeros(varLength, 1);
SA_Pelvis_Full = horzcat(SA_Pelvis, var2, var1);   % concatenate to add the two columns on the RHS. Inverse order of LGW.





% Vertical concatenation to create the full training set consisting of both
% the LGW data and the SA data
dataSet = vertcat(LGW_Pelvis_Full, SA_Pelvis_Full);

% Define which features to include in the input set.
inputs = dataSet(:,1:10)';    % Take all the rows, and all the 10 features as inputs. Could also use: inputs = dataSet(:,1:end-2).

% Define the target set
targets = dataSet(:, 11:12)'; % Take all the rows, and the last two columns as outputs. Could also use: targets = dataSet(:, end-1:end)


% Define number of neurons for the hidden layer of the NN
hiddenLayerSize = 10;

% Create a Pattern Recognition Network with the defined number of hidden layers.
% `patternnet` is specific for pattern-recognition NNs
net = patternnet(hiddenLayerSize);

% Set up Division of Data for Training, Validation, Testing Subsets
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
% inputs = inputs';
% targets = targets';
[net, tr] = train(net, inputs, targets);



% Test the Network with the test subset from the current dataset

%  get the indices/positions randomly selected for the test dataset (15%)
tInd = tr.testInd;

%  obtain the NN's predictions of the test data
tstOutputs = net(inputs(:,tInd));

%  compare the NN's predictions against the training set
tstPerform = perform(net, targets(:,tInd), tstOutputs);
fprintf("\nPerformance using the test data set aside from original dataset: %f\n", tstPerform)

%  plot the confusion matrix
% figure
% plotconfusion(targets(:,tInd),tstOutputs)


% -!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-
% Evaluate the performance of your model using a new dataset
% -!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-

% --------------------------------------------------------------------
% Data Preparation
% --------------------------------------------------------------------

% Extract the new datasets
new_LGW_Data = readtable("../../Practicals/Session 2/normal_walk_lg_trial_01.dat", "ReadVariableNames",true);  % new level ground walking data
new_SA_Data = readtable("../../Practicals/Session 2/stair_asc_lg_trial_01.dat", "ReadVariableNames",true);  % new level ground walking data

% --------------------------------------------------------------------
% Format test data
% --------------------------------------------------------------------
new_LGW_dataRange = [63:72];    % only concerned with these columns - the 9 variables from pelvis IMU + the timestamp
new_SA_dataRange = [63:72];
new_LGW_Pelvis = new_LGW_Data{:,new_LGW_dataRange};  % extract all the rows from th columns defined in dataRange
new_SA_Pelvis = new_SA_Data{:,new_SA_dataRange};  % extract all the rows from th columns defined in dataRange

%LGW Dataset -----------------------------
varLength = length(new_LGW_Pelvis);
% create a column with zeroes and another one with ones to add to the right
% of the existing data. This is to label each row to specify which class it
% belongs to
var1 = ones(varLength, 1);     % rows not columns
var2 = zeros(varLength, 1);
new_LGW_Pelvis_Full = horzcat(new_LGW_Pelvis, var1, var2);   % concatenate to add the two columns on the RHS

%SA Dataset ------------------------------
varLength = length(new_SA_Pelvis);
var1 = ones(varLength, 1);     % rows not columns
var2 = zeros(varLength, 1);
new_SA_Pelvis_Full = horzcat(new_SA_Pelvis, var2, var1);   % concatenate to add the two columns on the RHS. Inverse order of LGW.

% Vertical concatenation to create the full training set consisting of both
% the LGW data and the SA data
new_dataSet = vertcat(new_LGW_Pelvis_Full, new_SA_Pelvis_Full);

% Define which features to include in the input set.
new_inputs = new_dataSet(:,1:10)';    % Take all the rows, and all the 10 features as inputs.

% Define the target set
new_targets = new_dataSet(:, 11:12)'; % Take all the rows, and the last two columns as outputs.

% --------------------------------------------------------------------
% Test the Network
% --------------------------------------------------------------------

%  obtain the NN's predictions of all the data (not divided into trai/val/test this time)
new_tstOutputs = net(new_inputs);

%  compare the NN's predictions against the training set
new_tstPerform = perform(net, new_targets, new_tstOutputs);
fprintf("\nPerformance using the completely new dataset: %f\n", new_tstPerform)

%  plot the confusion matrix
figure
plotconfusion(new_targets,new_tstOutputs)







% -!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-
% Extract the moving average of each feature under k windows to train the model
% -!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-

% ------------------------------------------------------------------
% Calculate the moving average values over a sliding window of size k 
% from each feature from each activity
% ------------------------------------------------------------------
length(dataSet(:,1:10))
dataSet(:,1:10) = movmean(dataSet(:,1:10), [100,200]);
length(dataSet(:,1:10))
new_dataSet(:,1:10)  = movmean(new_dataSet(:,1:10), [100,200]);

% ------------------------------------------------------------------
% Create new input set
% ------------------------------------------------------------------
% Define which features to include in the input set.
inputs = dataSet(:,1:10)';    % Take all the rows, and all the 10 features as inputs. Could also use: inputs = dataSet(:,1:end-2).
new_inputs = new_dataSet(:,1:10)';    % Take all the rows, and all the 10 features as inputs.

% Define the target set
targets = dataSet(:, 11:12)'; % Take all the rows, and the last two columns as outputs. Could also use: targets = dataSet(:, end-1:end)
new_targets = new_dataSet(:, 11:12)'; % Take all the rows, and the last two columns as outputs.

% Create a Pattern Recognition Network --------------------------------
% Define number of neurons for the hidden layer of the NN
hiddenLayerSize = 10;

% Create a Pattern Recognition Network with the defined number of hidden layers.
% `patternnet` is specific for pattern-recognition NNs
net = patternnet(hiddenLayerSize);

% Set up Division of Data for Training, Validation, Testing Subsets
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% ------------------------------------------------------------------
% Train the Network
% ------------------------------------------------------------------
[net, tr] = train(net, inputs, targets);

% ------------------------------------------------------------------
% Test the Network with the test subset from the current dataset
% ------------------------------------------------------------------
%  get the indices/positions randomly selected for the test dataset (15%)
tInd = tr.testInd;

%  obtain the NN's predictions of the test data
tstOutputs = net(inputs(:,tInd));

%  compare the NN's predictions against the training set
tstPerform_movmean = perform(net, targets(:,tInd), tstOutputs);
fprintf("\nMOVMEAN Performance using the test data set aside from original dataset: %f\n", tstPerform_movmean);

%  plot the confusion matrix
% figure
% plotconfusion(targets(:,tInd),tstOutputs)

% ------------------------------------------------------------------
% Test the Network with the separate data
% ------------------------------------------------------------------
%  obtain the NN's predictions of all the data (not divided into trai/val/test this time)
new_tstOutputs = net(new_inputs);
%  compare the NN's predictions against the training set
new_tstPerform_movmean = perform(net, new_targets, new_tstOutputs);
fprintf("\nMOVMEAN Performance using the completely new dataset: %f\n\n", new_tstPerform_movmean);

%  plot the confusion matrix
figure
plotconfusion(new_targets,new_tstOutputs)
%}











