
clear;      % clear the workspace
clc;        % clear the command window
close all;  % close all popup windows

% ======================================
% ================ TASK 1 ==============
% ======================================

fprintf("\n--------\n Importing the data...\n--------\n")
% new_import_datasets;
raw_data = new_import_datasets();

fprintf("\n--------\n Filtering the data...\n--------\n")
% filter_data;
raw_data = filter_data(raw_data);

fprintf("\n--------\n Extracting the time-domain features...\n--------\n")
% extract_reduce_features;
processed_data = extract_reduce_features(raw_data);
% clearvars -except raw_data processed_data

fprintf("\n--------\n Organising the features...\n--------\n")
% organise_features
array_per_activity_nomagnet = organise_features(processed_data);
% clearvars -except array_per_activity_nomagnet

fprintf("\n--------\n Labelling the data...\n--------\n")
% label_data_nn
[final_labelled_data1, final_inputs_nn1, final_targets_nn1] = label_data_nn(array_per_activity_nomagnet);
% label_data_svm
[final_inputs_svm1, final_targets_svm1] = label_data_svm(array_per_activity_nomagnet);
% clearvars -except final_labelled_data final_inputs_nn final_targets_nn final_inputs_svm final_targets_svm

%{
fprintf("\n--------\n Training the ANN using all the features...\n--------\n")
nn_manual(final_labelled_data)
clearvars -except final_labelled_data final_inputs_nn final_targets_nn final_inputs_svm final_targets_svm
close all

fprintf("\n--------\n Training the SVM using all the features...\n--------\n")
svm_posterior(final_labelled_data, final_targets_svm)


% ======================================
% ================ TASK 2 ==============
% ======================================

fprintf("\n--------\n Finding the top 15 features...\n--------\n")
fifteen_features_labelled_data = find_15_features(final_labelled_data, final_inputs_svm, final_targets_svm);
clearvars -except sorted_labels sorted_labels_cell fifteen_features_inputs_svm fifteen_features_inputs_nn fifteen_features_labelled_data final_targets_nn final_targets_svm

fprintf("\n--------\n Training the ANN using 15 features...\n--------\n")
nn_manual(fifteen_features_labelled_data)
clearvars -except sorted_labels sorted_labels_cell fifteen_features_labelled_data fifteen_features_inputs_svm final_targets_svm final_labelled_data final_inputs_svm

fprintf("\n--------\n Training the SVM using 15 features...\n--------\n")
svm_posterior(fifteen_features_labelled_data, final_targets_svm)

% ======================================
% ================ TASK 3 ==============
% ======================================

fprintf("\n--------\n Finding features from a single segment...\n--------\n")
[segment_features_labelled_data] = extract_segment("Thigh", final_labelled_data);

% ======================================
% ================ TASK 4 ==============
% ======================================

fprintf("\n--------\n Training the ANN using features from a single segment...\n--------\n")
nn_manual(segment_features_labelled_data)

fprintf("\n--------\n Training the SVM using features from a single segment...\n--------\n")
svm_posterior(segment_features_labelled_data, final_targets_svm)


%{
TODO:
- Compare the networks with all features vs with only 15 features vs with a
single segment?
%}

%}



