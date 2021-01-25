%{
rng(1);

neurons_opts = [15, 20, 25, 30, 35, 40];
algos_opts = ["trainrp", "trainscg", "traincgb", "traincgb"];
folds_opts = [3, 4, 5, 6, 7];

for ii=1:length(folds_opts)
    acc = cross_validate_nn(segment_features_labelled_data, folds_opts(ii), 35, 'trainscg');
    folds(ii,1) = folds_opts(ii);
    folds(ii,2) = acc;
    fprintf("\n\n*-*-*-*-*-*-*-*-*-\n*-*-*-*-*-*-*-*-*-\nAccuracy with %s is %f\n*-*-*-*-*-*-*-*-*-\n*-*-*-*-*-*-*-*-*-\n", folds_opts(ii), acc);
end

for ii=1:length(neurons_opts)
    acc = cross_validate_nn(segment_features_labelled_data, 7, neurons_opts(ii), 'trainscg');
    neurns(ii,1) = neurons_opts(ii);
    neurns(ii,2) = acc;
    fprintf("\n\n*-*-*-*-*-*-*-*-*-\n*-*-*-*-*-*-*-*-*-\nAccuracy with %s is %f\n*-*-*-*-*-*-*-*-*-\n*-*-*-*-*-*-*-*-*-\n", neurons_opts(ii), acc);
end

for ii=1:length(algos_opts)
    acc = cross_validate_nn(segment_features_labelled_data, 7, 35, algos_opts(ii));
    algos(ii,1) = algos_opts(ii);
    algos(ii,2) = acc;
    fprintf("\n\n*-*-*-*-*-*-*-*-*-\n*-*-*-*-*-*-*-*-*-\nAccuracy with %s is %f\n*-*-*-*-*-*-*-*-*-\n*-*-*-*-*-*-*-*-*-\n", algos_opts(ii), acc);
end
%}

% box_opts = [0.1, 0.7, 1.3, 10];
box_opts = [10];

for ii=1:length(box_opts)
    acc = svm_posterior(segment_features_labelled_data, final_targets_svm, "polynomial", box_opts(ii));
    boxes(ii,1) = box_opts(ii);
    boxes(ii,2) = acc;
    fprintf("\n\n*-*-*-*-*-*-*-*-*-\n*-*-*-*-*-*-*-*-*-\nAccuracy with %s is %f\n*-*-*-*-*-*-*-*-*-\n*-*-*-*-*-*-*-*-*-\n", box_opts(ii), acc);
end