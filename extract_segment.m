%{
This function takes in the name of the most significant body segment, as
well as the dataset.
It extracts all of the segment's information from the data, and returns the
dataset after reducing it to only data from that segment.
%}

function [segment_features_labelled_data, sig_indexes]=extract_segment(keyword, final_labelled_data)
    % labels.csv contains all the class labels in english in the same order 
    % that they appear in the data
    feature_labels = readtable("labels.csv", "ReadVariableNames",true, 'Delimiter','comma');
    ll = 0;
    % sig_indexes will contain the indexes of the features
    % related to the relevant body part i.e. keyword given.
    sig_indexes = zeros(1,1);
    feature_labels_array = table2array(feature_labels);

    % Loop through the feature names
    for ii=1 : size(feature_labels_array,1)
        % Find features that have the word we are looking for
        is_present = contains(feature_labels_array(ii),keyword,'IgnoreCase',true);
        if is_present
            % Its index correlates to the same index in the data as class labels are in
            % the same order
            sig_indexes(1,ll+1) = ii;
            ll = ll+1;
        end

    end
    % extract just the segment's columns from the labelled data
    class_labels = final_labelled_data(:,end-4:end);
    segment_features_unlabelled = final_labelled_data(:,sig_indexes);
    segment_features_labelled_data = horzcat(segment_features_unlabelled, class_labels);
end


