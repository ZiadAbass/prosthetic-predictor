clear
clc

fprintf("\n--------\nRunning import_datasets...\n--------\n")
new_import_datasets;
fprintf("\n--------\nRunning filter_data...\n--------\n")
filter_data;
fprintf("\n--------\nRunning extract_reduce_features...\n--------\n")
extract_reduce_features;
% delete all the vars except the ones we need
clearvars -except raw_data processed_data
fprintf("\n--------\nRunning organise_features...\n--------\n")
organise_features
clearvars -except array_per_activity_nomagnet
fprintf("\n--------\nRunning label_data...\n--------\n")
label_data_nn
label_data_svm
clearvars -except final_labelled_data final_inputs_nn final_targets_nn final_inputs_svm final_targets_svm
fprintf("\n--------\nRunning nn_manual_test...\n--------\n")
% nn_manual_test
clc
fprintf("\n--------\nRunning svm_posterior...\n--------\n")
svm_posterior