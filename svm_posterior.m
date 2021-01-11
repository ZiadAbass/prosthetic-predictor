%{
This script also build a multiclass svm model, but evaluates it using 
Posterior Probabilities
%}

% load('svm_data.mat')

% ######### Set aside some of the data for testing ##########

% We want to shuffle both inputs and outputs while preserving the
% correlation
p = randperm(length(final_inputs_svm));
random_final_inputs = final_inputs_svm(p, :);
random_final_targets = final_targets_svm(p, :);

% set some percentage of it aside for testing
test_percent = 15;
test_element_count = uint32((test_percent/100)*length(random_final_inputs));

% Define which features to include in the input set.
train_inputs = random_final_inputs(1:end-test_element_count,:);    % Take all the rows, and all the 10 features as inputs. Could also use: inputs = dataSet(:,1:end-2).
test_inputs= random_final_inputs(end-test_element_count+1:end,:);

% Define the target set
train_targets = random_final_targets(1:end-test_element_count, :); 
test_targets = random_final_targets(end-test_element_count+1:end,:);


% ######### Model Training ##################################

%Create a SVM Model template to fit into fitcecoc()
t = templateSVM('Standardize',true,'KernelFunction','gaussian');

%{
Train the ECOC classifier using the SVM template. 
- 'FitPosterior':   -> To transform classification scores to class posterior 
                        probabilities (which are returned by predict or resubPredict) 
- 'ClassNames'      -> To specify the class order.
- 'Verbose'         -> To display diagnostic messages during training 
%}
SVMModel = fitcecoc(train_inputs,train_targets,'Learners',t,'FitPosterior',true,...
    'ClassNames',{'LGW','RA','RD','SiS','StS'},...
    'Verbose',2);

% Predict the training-sample labels and class posterior probabilities.
[label,~,~,Posterior] = resubPredict(SVMModel,'Verbose',1);

% obtain a random sample from the data
idx = randsample(size(train_inputs,1),10,1);

% generate a table showing the predicted label and the 
% posterior probabilites of the sample data. 
% The 5 columns in the 'Posterior' columns correlate to: {'LGW','RA','RD','SiS','StS'}
table(train_targets(idx),label(idx),Posterior(idx,:),...
    'VariableNames',{'TrueLabel','PredLabel','Posterior'})


% ######### Model Evaluation ##################################

%{
Predict the posterior probabilities for each instance in the test data.
%}
[~,~,~,TestSamplePosteriorRegion] = predict(SVMModel,test_inputs);

% Convert the Nx5 TestSamplePosteriorRegion matrix into an Nx1 array
% with the index number of the class with the highest posterior prob.
[~,I] = max(TestSamplePosteriorRegion, [],2);

% Translate each class number into a string representing the class
sets_for_labels = [{'LGW'} {'RA'} {'RD'} {'SiS'} {'StS'}];
for ii=1 : length(I)
    targets_from_posterior_test_prediction(ii,1) = sets_for_labels(I(ii,1));
end

% Plot Confusion Matrix
cm = confusionchart(test_targets,targets_from_posterior_test_prediction,...
    'Title', 'Confusion Matrix for SVM based on Posterior Prediction',...
    'RowSummary', 'absolute',...
    'ColumnSummary', 'absolute');

% Calculate the classification accuracy from the confusion matrix
% Need to first obtain the number of correct classifications, this will
% be equal to the sum of the values in the diagonal of the CM
confusionMatrixResults = cm.NormalizedValues;
correct_predictions = 0;
for ii=1 : length(confusionMatrixResults)
    correct_predictions = correct_predictions + confusionMatrixResults(ii,ii);
end
accuracy = (correct_predictions/length(test_targets))*100;

fprintf("\nModel accuracy: %f\n", accuracy)
fprintf("\nModel binary loss: %s\n\n", SVMModel.BinaryLoss)
% Binary Loss is quadratic since posterior probabilities are 
% being found by all the binary learners

%{ 
We can see that the confusion matrix produced by the SVM model using 
posterior probability does not show 100% classification accuracy like the
one produced when the SVM was evaluated normally. 
This way of evaluating the SVM model is more robust.
%}

%{ 
TODO (Optional): Fix this section to visaulise max class posterior probability, 
see end of openExample('stats/EstimatePosteriorProbabilitiesUsingECOCClassifiersExample')
for an example

%{
For each coordinate on the grid, plot the maximum class posterior probability among all classes.
%}
maxi = max(TestSamplePosteriorRegion,[],2);
size1 = size(test_inputs,1);
size2 = size(test_inputs,2);
hamada = reshape(maxi,size2,size1);
contourf(test_inputs(:,1),test_inputs(:,2),maxi);

h = colorbar;
h.YLabel.String = 'Maximum posterior';
h.YLabel.FontSize = 15;

hold on
gh = gscatter(X(:,1),X(:,2),Y,'krk','*xd',8);
gh(2).LineWidth = 2;
gh(3).LineWidth = 2;

title('Iris Petal Measurements and Maximum Posterior')
xlabel('Petal length (cm)')
ylabel('Petal width (cm)')
axis tight
legend(gh,'Location','NorthWest')
hold off
%}

