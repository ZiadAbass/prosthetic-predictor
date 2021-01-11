load('posterior_svm.mat')

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
for oo=1 : length(confusionMatrixResults)
    correct_predictions = correct_predictions + confusionMatrixResults(oo,oo);
end
accuracy = (correct_predictions/length(test_targets))*100;

fprintf("\nModel accuracy: %f\n", accuracy)
fprintf("\nModel binary loss: %s\n\n", SVMModel.BinaryLoss)
% Binary Loss is quadratic since posterior probabilities are 
% being found by all the binary learners

%{
load('EstimatePosteriorExample.mat')

maxi = max(PosteriorRegion,[],2);
size1 = size(x1Grid,1);
size2 = size(x1Grid,2);
hamada = reshape(maxi,size1,size2);
contourf(x1Grid,x2Grid,hamada);
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