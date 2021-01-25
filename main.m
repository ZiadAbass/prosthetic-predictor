
clear;      % clear the workspace
clc;        % clear the command window
close all;  % close all popup windows

% ======================================
% ================ TASK 1 ==============
% ======================================

fprintf("\n--------\n Importing the data...\n--------\n")
rawData = new_import_datasets();

fprintf("\n--------\n Filtering the data...\n--------\n")
filteredRawData = filter_data(rawData);

fprintf("\n--------\n Extracting the time-domain features...\n--------\n")
processedData = extract_reduce_features(filteredRawData);

fprintf("\n--------\n Organising the features...\n--------\n")
arrayPerActivity = organise_features(processedData);

fprintf("\n--------\n Labelling the data...\n--------\n")
[labelledData] = label_data_nn(arrayPerActivity);
[unlabelledData, classLabels] = label_data_svm(arrayPerActivity);

fprintf("\n--------\n Training the ANN using all the features...\n--------\n")
allFeaturesNNAccuracy = cross_validate_nn(labelledData, 5, 201, "trainscg");
close all

fprintf("\n--------\n Training the SVM using all the features...\n--------\n")
allFeaturesSVMAccuracy = svm_posterior(labelledData, classLabels, "polynomial", 1);


% ======================================
% ================ TASK 2 ==============
% ======================================

% delete vars no longer needed to save memory
clearvars -except labelledData final_inputs_nn final_targets_nn unlabelledData classLabels

fprintf("\n--------\n Finding the top 15 features...\n--------\n")
fifteenFeaturesLabelled = find_15_features(labelledData, unlabelledData, classLabels);

fprintf("\n--------\n Training the ANN using 15 features...\n--------\n")
fifteenFeaturesNNAccuracy = cross_validate_nn(fifteenFeaturesLabelled, 5, 10, "trainscg");

fprintf("\n--------\n Training the SVM using 15 features...\n--------\n")
fifteenFeaturesSVMAccuracy = svm_posterior(fifteenFeaturesLabelled, classLabels, "polynomial", 1);

% ======================================
% ================ TASK 3 ==============
% ======================================

fprintf("\n--------\n Finding features from a single segment...\n--------\n")
[segmentFeaturesLabelled] = extract_segment("thigh_r", labelledData);

% ======================================
% ================ TASK 4 ==============
% ======================================

fprintf("\n--------\n Training the ANN using features from a single segment...\n--------\n")
single_segment_nn_accuracy = cross_validate_nn(segmentFeaturesLabelled, 5, 35, "trainscg");

fprintf("\n--------\n Training the SVM using features from a single segment...\n--------\n")
single_segment_svm_accuracy = svm_posterior(segmentFeaturesLabelled, classLabels, "polynomial", 1);

