%{
This script also build a multiclass svm model, but evaluates it using 
Posterior Probabilities
%}
%{
clc
load('svm_data.mat')

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
%}


%{
Print out the binary loss function.
It is quadratic since posterior probabilities are being found by all the binary learners
%}
SVMModel.BinaryLoss

% obtain a random sample from the data
idx = randsample(size(train_inputs,1),10,1);
SVMModel.ClassNames

% generate a table showing the predicted label and the 
% posterior probabilites of the sample data. 
% The 5 columns in the 'Posterior' columns correlate to: {'LGW','RA','RD','SiS','StS'}
table(train_targets(idx),label(idx),Posterior(idx,:),...
    'VariableNames',{'TrueLabel','PredLabel','Posterior'})




%{
Define a grid of values in the observed predictor space. 
Predict the posterior probabilities for each instance in the grid.
%}
xMax = max(train_inputs);
xMin = min(train_inputs);

x1Pts = linspace(xMin(1),xMax(1));
x2Pts = linspace(xMin(2),xMax(2));
[x1Grid,x2Grid] = meshgrid(x1Pts,x2Pts);

[~,~,~,PosteriorRegion] = predict(SVMModel,[x1Grid(:),x2Grid(:)]);


%{
For each coordinate on the grid, plot the maximum class posterior probability among all classes.
%}
contourf(x1Grid,x2Grid,...
        reshape(max(PosteriorRegion,[],2),size(x1Grid,1),size(x1Grid,2)));
h = colorbar;
h.YLabel.String = 'Maximum posterior';
h.YLabel.FontSize = 15;

hold on
gh = gscatter(train_inputs(:,1),train_inputs(:,2),train_targets,'krk','*xd',8);
gh(2).LineWidth = 2;
gh(3).LineWidth = 2;

title('Activity classifier & Maximum Posterior')
xlabel('Petal length (cm)')
ylabel('Petal width (cm)')
axis tight
legend(gh,'Location','NorthWest')
hold off
    
