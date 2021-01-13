clear
clc

fprintf("\n--------\n Importing the data...\n--------\n")
new_import_datasets;

fprintf("\n--------\n Filtering the data...\n--------\n")
filter_data;

fprintf("\n--------\n Extracting the time-domain features...\n--------\n")
extract_reduce_features;
% delete all the vars except the ones we need
clearvars -except raw_data processed_data

fprintf("\n--------\n Organising the features...\n--------\n")
organise_features
clearvars -except array_per_activity_nomagnet

fprintf("\n--------\n Labelling the data...\n--------\n")
label_data_nn
label_data_svm
clearvars -except final_labelled_data final_inputs_nn final_targets_nn final_inputs_svm final_targets_svm

fprintf("\n--------\n Training the ANN using all the features...\n--------\n")
nn_manual(final_labelled_data)
clearvars -except final_labelled_data final_inputs_nn final_targets_nn final_inputs_svm final_targets_svm
close all

fprintf("\n--------\n Training the SVM using all the features...\n--------\n")
svm_posterior(final_inputs_svm, final_targets_svm)

fprintf("\n--------\n Finding the top 15 features...\n--------\n")
find_15_features
clearvars -except sorted_labels sorted_labels_cell fifteen_features_inputs_svm fifteen_features_inputs_nn fifteen_features_labelled_data final_targets_nn final_targets_svm

fprintf("\n--------\n Training the ANN using 15 features...\n--------\n")
nn_manual(fifteen_features_labelled_data)
clearvars -except sorted_labels sorted_labels_cell fifteen_features_inputs_svm final_targets_svm

fprintf("\n--------\n Training the SVM using 15 features...\n--------\n")
svm_posterior(fifteen_features_inputs_svm, final_targets_svm)
