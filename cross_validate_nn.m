%{
cross_validate_nn() takes in the processed data and performs K-Fold Cross
Validation by randomising the samples then taking sequential folds from the
data. It retrieves the classification accuracy from each fold and finds the
mean accuracy accross all the folds.
%}

function [final_accuracy] = cross_validate_nn(labelledData, folds, hiddenLayerSize)
    % define the number test samples in each fold
    test_element_count = int32(size(labelledData,1)/folds);

    % initialisations
    foldCounter = 1;
    total_accuracy = 0;

    % before runninng cross validation and splitting into inputs and targets shuffle the rows
    random_final_labelled_data = labelledData(randperm(size(labelledData, 1)), :);

    for ii=0 : test_element_count : size(random_final_labelled_data,1)
        % make sure there are enough elements to make up the fold
        if ii+test_element_count <= size(random_final_labelled_data,1)+1
            fprintf("\n*******************\nRunning fold %i out of %i\n",foldCounter, folds)
            % extract the test set 
            test_extracted = random_final_labelled_data((ii+1:ii+test_element_count-1),:);
            % train_extracted = final_labelled_data((ii+1:ii+test_element_count),:);
            % extract the test set (the remaining data), which also includes
            % validation data
            train_extracted = random_final_labelled_data;
            train_extracted((ii+1:ii+test_element_count-1),:) = [];

            % Define the input set.
            train_inputs = train_extracted(:,1:end-5)';
            test_inputs= test_extracted(:,1:end-5)';

            % Define the target set
            train_targets = train_extracted(:, end-4:end)'; 
            test_targets = test_extracted(:, end-4:end)'; 

            % train the ANN with the extracted data
            acc = nn(train_inputs, test_inputs, train_targets, test_targets, hiddenLayerSize);
            fprintf("\n    Accuracy for this fold is %f\n\n", acc)

            foldCounter = foldCounter+1;
            % keep track of all the accuracies to find the mean
            total_accuracy = total_accuracy + acc;
        end
    end

    % give a summary of all the folds
    final_accuracy = total_accuracy/folds;
    fprintf("\n===================\nAverage accuracy across %i folds: %f\n===================\n", folds, final_accuracy);
end