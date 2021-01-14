clear
clc
load("post_extract_without_msc.mat")

window = 400;
interval = 5;

% ----------------------------------------------
% Loop through all of the raw_data, extract maximum slope change.
% ----------------------------------------------
% extract maximum slope for the data and add to the same processed_data
% struct
% loop through each of the folders
for ff = 1 : length(sets)
    for kk = 1 : length(raw_data)
        fprintf("\nIn set number %i and dataset number %i, in set %s\n", ff, kk, sets(ff))
        current_dataset = raw_data(kk).(sets{ff});
        current_dataset_without_timestamp = current_dataset(:,2:end);
        current_timestamp = table2array(current_dataset(:,1));
        % Filter the data
        % loop through the columns in the single dataset
        clearvars ms_dataset
        for ii = 1 : width(current_dataset_without_timestamp)
%             fprintf("\nDone %i of %i columns in this dataset", ii, width(current_dataset_without_timestamp))
            % obtain the relevant column
            colm = table2array(current_dataset_without_timestamp(1:end,ii));
            % calculate max slope change manually
            clearvars ms_column
            % loop through the column
            for r = 1 : interval :length(colm)   % change 5 to change interval
            % for r = 1 :length(colm)
                if length(colm) < (window+2)
                    % if the column is smaller than the window size then
                    % take the whole column
                    h = colm;
                    timeColum = current_timestamp;
                elseif r > (length(colm)-((window/2)+1))
                    % if towards the end of the column, window/2 values
                    % before r and all values after it.
                    h = colm(r-(window/2):end);
                    timeColum = current_timestamp(r-(window/2):end);
                elseif r < ((window/2)+1)
                    % if towards the start of the column, take all values
                    % before r and window/2 values after r
                    h = colm(1:r+(window/2));
                    timeColum = current_timestamp(1:r+(window/2));
                else
                    % under normal conditions, take window/2 values before
                    % r and window/2 values after it
                    h = colm(r-(window/2):r+(window/2));
                    timeColum = current_timestamp(r-(window/2):r+(window/2));
                end
                % gradient() finds the slope change between consequetive
                % data points.
                dydx = gradient(timeColum) ./ gradient(h);
                % we now need to find the differences between consequtive
                % gradients, then find the maximum value i.e. max slope
                % change
                maxSlopeChange = max(diff(dydx));
                ms_column(((r-1)/5)+1) = maxSlopeChange;   % r going in increments
            end
            % append the ms_column to the existing msc table
            ms_dataset(:,ii) = ms_column;
        end
        processed_data(kk).(sets{ff})(1).MSC = ms_dataset;
    end
end