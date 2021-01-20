
% rng(1);

% algos = ["trainrp", "trainscg", "traincgb", "traincgf", "traincgp", "trainoss", "traingdx", "traingdm", "traingd"];

algos = ["trainrp", "trainscg", "traincgb", "traincgp"];

for ii=1:length(algos)
    acc = cross_validate_nn(segment_features_labelled_data, 7, 35, algos(ii));
    top_4_7_folds(ii,1) = algos(ii);
    top_4_7_folds(ii,2) = acc;
    fprintf("\n\n*-*-*-*-*-*-*-*-*-\n*-*-*-*-*-*-*-*-*-\nAccuracy with %s is %f\n*-*-*-*-*-*-*-*-*-\n*-*-*-*-*-*-*-*-*-\n", algos(ii), acc);
end

