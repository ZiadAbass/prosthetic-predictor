%{
This function takes in the name of the most significant body segment, as
well as the dataset and extracts all of the segment's information.

Arguments
- `keyword`          -> body segment to extract (e.g. 'foot_r')
- `labelledData`     -> the labelled dataset

Returns:
- `segmentFeaturesLabelled`  -> dataset after reducing it to only data from that segment.
%}

function [segmentFeaturesLabelled, sig_indexes]=extractSegment(keyword, labelledData)
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
    class_labels = labelledData(:,end-4:end);
    segment_features_unlabelled = labelledData(:,sig_indexes);
    segmentFeaturesLabelled = horzcat(segment_features_unlabelled, class_labels);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

