%{
This function takes in the labelled data and uses the minimum redundancy 
maximum relevance algorithm to find the most significant 15 features among 
the existing 294 features. It extracts these 15 features and plots a 
labelled bar graph of their scores.
Parameters:

Arguments:
- `labelledData`        -> labelled data
- `unlabelledInputs`    -> input data with no labels
- `classLabels`         -> svm-specific target data

Returns:
- `fifteenFeaturesLabelledData`  -> a condensed version of the given
`labelledData` that has samples from only the top 15 features.
%}

function [fifteenFeaturesLabelledData]=find_15_features(labelledData, unlabelledInputs, classLabels)

    % labels.csv contains all the class labels in english in the same order 
    % that they appear in the data
    feature_labels = readtable("labels.csv", "ReadVariableNames",true, 'Delimiter','comma');

    % run the minimum redundancy maximum relevance algorithm to order the 294
    % features according to their relevance 
    % the SVM training data is formatted in a way that is suitable as an input
    % for the fscmrmr function, so we can use it here.
    [idx,scores] = fscmrmr(unlabelledInputs,classLabels);

    % only consider the top 15 features
    idx = idx(:,1:15);

    % rank the labels according to their relevance. Most important goes first.
    sorted_labels = feature_labels(idx,1);

    % give a summary of the most significant features:
    fprintf("\nMost significant 15 features:\n  ")
    sorted_labels

    % take only the top rated 15 rows from the labelled data
    % fifteen_features_inputs_nn = nn_inputs(idx,:);
    class_labels = labelledData(:,end-4:end);
    fifteen_features_unlabelled = labelledData(:,idx);
    fifteenFeaturesLabelledData = horzcat(fifteen_features_unlabelled, class_labels);

    % take only the top rated 15 rows from the SVM data
    % fifteen_features_inputs_svm = final_inputs_svm(:,idx);

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
end

