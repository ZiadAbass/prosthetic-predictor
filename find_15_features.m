%{
This sript takes in the cleaned up dataset as inputs and targets.
It uses the minimum redundancy maximum relevance algorithm to find the most
significant 15 features among the existing 294 features.
It extracts these 15 features and plots a labelled bar graph of their scores.

%}

feature_labels = readtable("labels.csv", "ReadVariableNames",true, 'Delimiter','comma');

% run the minimum redundancy maximum relevance algorithm to order the 294
% features according to their relevance 
% the SVM training data is formatted in a way that is suitable as an input
% for the fscmrmr function, so we can use it here.
[idx,scores] = fscmrmr(final_inputs_svm,final_targets_svm);

% only consider the top 15 features
idx = idx(:,1:15);

% rank the labels according to their relevance. Most important goes first.
sorted_labels = feature_labels(idx,1);

% give a summary of the most significant features:
fprintf("\nMost significant 15 features:\n  ")
sorted_labels

% take only the top rated 15 rows from the NN data
fifteen_features_inputs_nn = final_inputs_nn(idx,:);
fifteen_features_labelled_data = final_labelled_data(:,idx);

% take only the top rated 15 rows from the SVM data
fifteen_features_inputs_svm = final_inputs_svm(:,idx);

% need to convert the table to a cell array to show feature names in the
% plot
sorted_labels_cell = table2cell(sorted_labels);	
X = categorical(sorted_labels_cell);
% categorical sorts the labels alphabetically by default, need to reorder
% to perserve the ascending order of the feature score
X = reordercats(X,sorted_labels_cell);
Y = scores(idx);
% plot the bar chart showing the most significant 15 features
bar(X,Y)


clearvars -except sorted_labels sorted_labels_cell fifteen_features_inputs_svm fifteen_features_inputs_nn fifteen_features_labelled_data final_targets_nn final_targets_svm

