%{
This file takes in the struct containing all the datasets 
- Need to filter the data
- Extract all the time-domain features:
    1. Maximum
    2. Minimum
    3. Mean
    4. Standard deviation
    5. Root means square (RMS)
    6. Maximum slope changes
    7. Zero crossing
        The notations for them: "MAX", "MIN", "AVG", "SD","RMS".

TODO:
    - Use the time interval param
    - Fix this max slope change. right now it is taking so long. Currently
    we are extracting zero crossing twice to fill up the space.

This script outputs the 'processed_data' struct. The data still needs to be
reduced (i.e. use the time interval param). This is the difference between
this script and new_extract_features.m

%}

% good practice to start with these
% clear;      % clear the workspace
clc;        % clear the command window
close all;  % close all popup windows

% ----------------------------------------------
% Loop through all of the raw_data, extract max, min, mean, standard
% deviation and RMS.
% ----------------------------------------------
% array containing the names of the activities. 
% These names will match the field names in the struct
sets = ["LGW","RA","RD","SiS","StS"];
% array containing the names of the time domain features. 
% These names will match the field names in the struct.
features = ["MAX", "MIN", "AVG", "SD","RMS"];
% size of the sliding window for extracting features
window = 400;
Y = 0;
% loop through each of the folders
for ff = 1 : length(sets)
    for kk = 1 : length(raw_data)
%         fprintf("\nkk is %i, ff is %i\n", kk, ff)
        current_dataset = table2array(raw_data(kk).(sets{ff}));
        current_dataset_without_timestamp = current_dataset(:,2:end);
        % extract time domain features from each dataset
        mean = movmean(current_dataset_without_timestamp, window);
        stdD = movstd(current_dataset_without_timestamp, window);
        maxV = movmax(current_dataset_without_timestamp, window);
        min = movmin(current_dataset_without_timestamp, window);
        rms = sqrt(movmean(current_dataset_without_timestamp .^ 2, window));
        % group all the features
        dataset_features = {maxV, min, mean, stdD, rms};
        % assign all the features to a single new struct
        for w = 1 : length(dataset_features)
            temp_processed_data(1).(features{w}) = dataset_features{1,w}; 
        end
        processed_data(kk).(sets{ff}) = temp_processed_data;
    end
end

% ----------------------------------------------
% Loop through all of the raw_data, extract Zero Crossing.
% ----------------------------------------------
% extract zero crossing for the data and add to the same processed_data
% struct
% loop through each of the folders
for ff = 1 : length(sets)
    for kk = 1 : length(raw_data)
        fprintf("\nIn set number %i and dataset number %i, in set %s\n", ff, kk, sets(ff))
        current_dataset = raw_data(kk).(sets{ff});
        current_dataset_without_timestamp = current_dataset(:,2:end);
        % Filter the data
        % loop through the columns in the single dataset
        clearvars zc_dataset
        for ii = 1 : width(current_dataset_without_timestamp)
            % obtain the relevant column
            colm = table2array(current_dataset_without_timestamp(1:end,ii));
            % calculate zero crossing manually
            % (for each window, 1 if a ZC exists, 0 if not)
            zc = false;
            clearvars zc_column
            % loop through the column
            % for r = 1 : 5 :length(colm)   % change 5 to change interval
            for r = 1 :length(colm)
                if length(colm) < (window+2)
                    % if the column is smaller than the window size then
                    % take the whole column
                    h = colm;
                elseif r > (length(colm)-((window/2)+1))
                    % if towards the end of the column, window/2 values
                    % before r and all values after it.
                    h = colm(r-(window/2):end);
                elseif r < ((window/2)+1)
                    % if towards the start of the column, take all values
                    % before r and window/2 values after r
                    h = colm(1:r+(window/2));
                else
                    % under normal conditions, take window/2 values before
                    % r and window/2 values after it
                    h = colm(r-(window/2):r+(window/2));
                end
                % loop through h and see if a ZC exists
                for rr = 1 : length(h)-1
                    if (h(rr)*h(rr+1))<0
                        zc = true;
                    end
                end
                % if we had found a ZC then we want to assign 1, if not
                % then 0. Indexing (((r-1)/5)+1) instead of r as r is
                % increasing by increments of 5.
                if zc
%                     zc_column(((r-1)/5)+1) = 1;   % if r going in 5s
                    zc_column(r) = 1;               % if r going in 1s
                else
%                     zc_column(((r-1)/5)+1) = 0;   % if r going in 5s
                    zc_column(r) = 0;               % if r going in 1s
                end
                zc = false;
            end
            % append the zc_column to the existing zc table
            zc_dataset(:,ii) = zc_column;
            % <add zc_feature>
        end
        processed_data(kk).(sets{ff})(1).ZC = zc_dataset;
    end
end

% ----------------------------------------------
% Loop through all of the raw_data, extract Zero Crossing.
% NOTE: This is temporary until max slope change is fixed
% ----------------------------------------------
% extract zero crossing for the data and add to the same processed_data
% struct
% loop through each of the folders
for ff = 1 : length(sets)
    for kk = 1 : length(raw_data)
        fprintf("\nIn set number %i and dataset number %i, in set %s\n", ff, kk, sets(ff))
        current_dataset = raw_data(kk).(sets{ff});
        current_dataset_without_timestamp = current_dataset(:,2:end);
        % Filter the data
        % loop through the columns in the single dataset
        clearvars zc_dataset
        for ii = 1 : width(current_dataset_without_timestamp)
            % obtain the relevant column
            colm = table2array(current_dataset_without_timestamp(1:end,ii));
            % calculate zero crossing manually
            % (for each window, 1 if a ZC exists, 0 if not)
            zc = false;
            clearvars zc_column
            % loop through the column
            % for r = 1 : 5 :length(colm)   % change 5 to change interval
            for r = 1 :length(colm)
                if length(colm) < (window+2)
                    % if the column is smaller than the window size then
                    % take the whole column
                    h = colm;
                elseif r > (length(colm)-((window/2)+1))
                    % if towards the end of the column, window/2 values
                    % before r and all values after it.
                    h = colm(r-(window/2):end);
                elseif r < ((window/2)+1)
                    % if towards the start of the column, take all values
                    % before r and window/2 values after r
                    h = colm(1:r+(window/2));
                else
                    % under normal conditions, take window/2 values before
                    % r and window/2 values after it
                    h = colm(r-(window/2):r+(window/2));
                end
                % loop through h and see if a ZC exists
                for rr = 1 : length(h)-1
                    if (h(rr)*h(rr+1))<0
                        zc = true;
                    end
                end
                % if we had found a ZC then we want to assign 1, if not
                % then 0. Indexing (((r-1)/5)+1) instead of r as r is
                % increasing by increments of 5.
                if zc
%                     zc_column(((r-1)/5)+1) = 1;   % if r going in 5s
                    zc_column(r) = 1;               % if r going in 1s
                else
%                     zc_column(((r-1)/5)+1) = 0;   % if r going in 5s
                    zc_column(r) = 0;               % if r going in 1s
                end
                zc = false;
            end
            % append the zc_column to the existing zc table
            zc_dataset(:,ii) = zc_column;
            % <add zc_feature>
        end
        processed_data(kk).(sets{ff})(1).MSC = zc_dataset;
    end
end

%{
% ----------------------------------------------
% Loop through all of the raw_data, extract maximum slope change.
% ----------------------------------------------
% extract maximum slope for the data and add to the same processed_data
% struct
% loop through each of the folders
for ff = 1 : length(sets)
    for kk = 1 : length(raw_data)
        fprintf("\nkk is %i, ff is %i, in set %s\n", kk, ff, sets(ff))
        current_dataset = raw_data(kk).(sets{ff});
        % Filter the data
        % loop through the columns in the single dataset
        clearvars ms_dataset
        for ii = 1 : width(current_dataset)
            fprintf("\nDone %i of %i columns in this dataset", ii, width(current_dataset))
            % obtain the relevant column
            colm = table2array(current_dataset(1:end,ii));
            % calculate zero crossing manually
            % (for each window, 1 if a ZC exists, 0 if not)
            zc = false;
            clearvars ms_column
            window = 400;
            % loop through the column
            % for r = 1 : 5 :length(colm)   % change 5 to change interval
            for r = 1 :length(colm)
                if length(colm) < (window+2)
                    % if the column is smaller than the window size then
                    % take the whole column
                    h = colm;
                elseif r > (length(colm)-((window/2)+1))
                    % if towards the end of the column, window/2 values
                    % before r and all values after it.
                    h = colm(r-(window/2):end);
                elseif r < ((window/2)+1)
                    % if towards the start of the column, take all values
                    % before r and window/2 values after r
                    h = colm(1:r+(window/2));
                else
                    % under normal conditions, take window/2 values before
                    % r and window/2 values after it
                    h = colm(r-(window/2):r+(window/2));
                end
                h = h.';
                % loop through h and find max slope change
                % max_slope = findchangepts(h,'Statistic','linear','MaxNumChanges',1);
                [TF,slopes] = ischange(h,'linear','Threshold',200);
                % fprintf("\nYes done %i of %i", r, length(colm))
                max_slope = max(slopes, [], 'all');
                % zc_column(((r-1)/5)+1) = 1;   % if r going in 5s
                ms_column(r) = max_slope;       % if r going in 1s
            end
            % append the zc_column to the existing zc table
            % ms_dataset(:,ii) = ms_column;
        end
        % processed_data(kk).(sets{ff})(1).ZC = ms_dataset;
    end
end
%}
