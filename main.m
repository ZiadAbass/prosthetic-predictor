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
label_data
clearvars -except final_labelled_data inputs targets
