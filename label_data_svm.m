%{
This script takes in the array_per_activity_nomagnet struct containing a
single table for each activity.
We now want to label this data
    (eg if one-hot-encoding will need a complementary matrix with labels)
We also want to group all of the data into a single table after labelling
it.
%}

function [final_inputs_svm, final_targets_svm] = label_data_svm(array_per_activity_nomagnet)
    % array containing the names of the activities. 
    % These names will match the field names in the struct
    sets = ["LGW","RA","RD","SiS","StS"];
    % redefining the sets in a way that is compatible with SVM class labelling
    sets_for_labels = [{'LGW'} {'RA'} {'RD'} {'SiS'} {'StS'}];

    % ----------------------------------------------
    % Label the data by having a single column dedicated for string class labels
    % ----------------------------------------------
    for ff = 1 : length(sets)
        % obtain the number of rows in the current dataset
        sample = array_per_activity_nomagnet(1).(sets{ff});
        temp_labels = cell(length(sample),1);

        % we want one column of labels, each row labelled using a string
        % according to the target class
        temp_labels(:,1) = sets_for_labels(ff);

        % store all the targets as one long 1D array
        if ff == 1
            final_targets_svm = temp_labels;
            final_inputs_svm = sample;
        else
            final_targets_svm = vertcat(final_targets_svm, temp_labels);
            final_inputs_svm = vertcat(final_inputs_svm, sample);
        end
    end
end











