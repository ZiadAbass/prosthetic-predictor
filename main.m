
clear;      % clear the workspace
clc;        % clear the command window
close all;  % close all popup windows

% ======================================
% ================ TASK 1 ==============
% ======================================

fprintf("\n--------\n Importing the data...\n--------\n")
raw_data = new_import_datasets();

fprintf("\n--------\n Filtering the data...\n--------\n")
raw_data = filter_data(raw_data);

fprintf("\n--------\n Extracting the time-domain features...\n--------\n")
processed_data = extract_reduce_features(raw_data);

fprintf("\n--------\n Organising the features...\n--------\n")
array_per_activity_nomagnet = organise_features(processed_data);

fprintf("\n--------\n Labelling the data...\n--------\n")
[final_labelled_data, final_inputs_nn, final_targets_nn] = label_data_nn(array_per_activity_nomagnet);
[final_inputs_svm, final_targets_svm] = label_data_svm(array_per_activity_nomagnet);

fprintf("\n--------\n Training the ANN using all the features...\n--------\n")
all_features_nn_accuracy = cross_validate_nn(final_labelled_data, 5, 201);
close all

fprintf("\n--------\n Training the SVM using all the features...\n--------\n")
% svm_posterior(final_labelled_data, final_targets_svm)


% ======================================
% ================ TASK 2 ==============
% ======================================

% delete vars no longer needed to save memory
clearvars -except final_labelled_data final_inputs_nn final_targets_nn final_inputs_svm final_targets_svm

fprintf("\n--------\n Finding the top 15 features...\n--------\n")
fifteen_features_labelled_data = find_15_features(final_labelled_data, final_inputs_svm, final_targets_svm);

fprintf("\n--------\n Training the ANN using 15 features...\n--------\n")
fifteen_features_nn_accuracy = cross_validate_nn(fifteen_features_labelled_data, 5, 10);

fprintf("\n--------\n Training the SVM using 15 features...\n--------\n")
svm_posterior(fifteen_features_labelled_data, final_targets_svm)

% ======================================
% ================ TASK 3 ==============
% ======================================

fprintf("\n--------\n Finding features from a single segment...\n--------\n")
[segment_features_labelled_data] = extract_segment("foot_r", final_labelled_data);

% ======================================
% ================ TASK 4 ==============
% ======================================

fprintf("\n--------\n Training the ANN using features from a single segment...\n--------\n")
single_segment_nn_accuracy = cross_validate_nn(segment_features_labelled_data, 5, 33);

fprintf("\n--------\n Training the SVM using features from a single segment...\n--------\n")
svm_posterior(segment_features_labelled_data, final_targets_svm)

