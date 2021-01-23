

sets = ["LGW","RA","RD","SiS","StS"];
mismatch_counts = 0;
gen_counts = 0;

% ----------------------------------------------
% 1. Loop through the processed data and horizonatally concatenate
% all the features 
% ----------------------------------------------
for ff = 1 : length(sets)
    for kk = 1 : length(processed_data)
        % sample is the struct containing the 7 tables
        % (one for each time feature)
        sample = processed_data(kk).(sets{ff});
        len_max = size(sample(1).MAX,1);
        len_zc = size(sample(1).MSC,1);
        if len_max ~= len_zc
            fprintf("\nMismatch! %i Max - %i ZC", len_max, len_zc)
            mismatch_counts = mismatch_counts+1;
        end
        gen_counts = gen_counts + 1;
    end
end

fprintf("\n\n**************\n%i mismatches out of %i\n\n", mismatch_counts, gen_counts)