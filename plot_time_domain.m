%{
Serving as a verification that time-domain features have been successfully
extracted, this function extracts all the time domain features
from a certain axis of a certain body segment (e.g. thigh_l_gyro_x)
and plots the first 150 readings of the 7 extracted features corresponding
to it.
%}

function [] = plot_time_domain(keyword, labelledData)
    % extract the relevant data from the dataset
    [segment_features_labelled_data, sig_indexes] = extract_segment(keyword, labelledData);

    % sig_indexes contains the column indexes of the relevant features in order
    % labels.csv contains all the class labels in english in the same order 
    % that they appear in the data
    feature_labels = readtable("labels.csv", "ReadVariableNames",true, 'Delimiter','comma');
    feature_labels_array = table2array(feature_labels);
    relevant_features = feature_labels_array(sig_indexes);

    % plot all the time domain features side by side on a stem plot
    figure;
    for ii=1 : 7
        subplot(2,4,ii)
        jj = segment_features_labelled_data(500:650,ii);
        kk = flip(jj,1);
        stem(kk, 'b')
        title(relevant_features(ii))
    end
end