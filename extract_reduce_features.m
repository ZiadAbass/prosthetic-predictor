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

This script outputs the 'processed_data' struct. The data is reduced using the given time window.

%}

function processed_data = extract_reduce_features(raw_data)
    close all;  % close all popup windows

    % ----------------------------------------------
    % Loop through all of the raw_data, extract max, min, mean, standard
    % deviation and RMS.
    fprintf("\nExtracting time domain features...\n")
    % ----------------------------------------------
    % array containing the names of the activities. 
    % These names will match the field names in the struct
    sets = ["LGW","RA","RD","SiS","StS"];
    % array containing the names of the time domain features. 
    % These names will match the field names in the struct.
    features = ["MAX", "MIN", "AVG", "SD","RMS"];
    % size of the sliding window for extracting features in milliseconds
    window_duration = 400;
    % loop through each of the folders
    for ff = 1 : length(sets)
        for kk = 1 : length(raw_data)
            current_dataset = table2array(raw_data(kk).(sets{ff}));
            current_dataset_without_timestamp = current_dataset(:,2:end);
            current_timestamp = current_dataset(:,1);

            % -------------------------------------------------------
            % We should not assume that the timestep between samples is fixed.
            % Therefore, we find the average timestep for every dataset and
            % change the window size accordingly.

            % find the average timestep between rows
            avg_timestep = mean(diff(current_timestamp));
            % in case the timestep is in seconds rather than milliseconds
            if avg_timestep < 1
                avg_timestep = avg_timestep*1000;
            end
            % `window_size` defines the number of readings in each window
            window_size = int32(window_duration/avg_timestep);
            %-------------------------------------------------------

            % extract time domain features from each dataset
            smean = movmean(current_dataset_without_timestamp, window_size);
            stdD = movstd(current_dataset_without_timestamp, window_size);
            maxV = movmax(current_dataset_without_timestamp, window_size);
            min = movmin(current_dataset_without_timestamp, window_size);
            rms = sqrt(movmean(current_dataset_without_timestamp .^ 2, window_size));
            % group all the features
            dataset_features = {maxV, min, smean, stdD, rms};
            % assign all the features to a single new struct
            for w = 1 : length(dataset_features)
                % reduce the data using the required time interval. 
                % We want to extract only every Nth row to match our time
                % interval. The 'interval' var defines N.
                [reduced_data, interval] = reduce_data(current_timestamp, dataset_features{1,w});
                temp_processed_data(1).(features{w}) = reduced_data; 
            end
            processed_data(kk).(sets{ff}) = temp_processed_data;
        end
    end


    % ----------------------------------------------
    % Loop through all of the raw_data, extract Zero Crossing.
    fprintf("\nManually extracting Zero Crossing...\n")
    % ----------------------------------------------
    % extract zero crossing for the data and add to the same processed_data
    % struct
    % loop through each of the folders
    for ff = 1 : length(sets)
        for kk = 1 : length(raw_data)
            % fprintf("\nIn set number %i and dataset number %i, in set %s\n", ff, kk, sets(ff))
            current_dataset = raw_data(kk).(sets{ff});
            current_dataset_without_timestamp = current_dataset(:,2:end);
            current_timestamp = table2array(current_dataset(:,1));
            % -------------------------------------------------------
            % We should not assume that the timestep between samples is fixed.
            % Therefore, we find the average timestep for every dataset and
            % change the window size accordingly.

            % find the average timestep between rows
            avg_timestep = mean(diff(current_timestamp));
            % in case the timestep is in seconds rather than milliseconds
            if avg_timestep < 1
                avg_timestep = avg_timestep*1000;
            end
            % `window_size` defines the number of readings in each window
            window_size = int16(window_duration/avg_timestep);
            half_window_size = int16(window_size/2);
            %-------------------------------------------------------
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
                for r = 1 : interval :length(colm)   % change 5 to change interval
                % for r = 1 :length(colm)
                    if length(colm) < (window_size+2)
                        % if the column is smaller than the window size then
                        % take the whole column
                        h = colm;
                    elseif r > (length(colm)-(half_window_size+1))
                        % if towards the end of the column, window/2 values
                        % before r and all values after it.
                        h = colm(r-half_window_size:end);
                    elseif r < (half_window_size+1)
                        % if towards the start of the column, take all values
                        % before r and window/2 values after r
                        h = colm(1:r+half_window_size);
                    else
                        % under normal conditions, take window/2 values before
                        % r and window/2 values after it
                        h = colm(r-half_window_size:r+half_window_size);
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
                        zc_column(((r-1)/interval)+1) = 1;   % if r going in 5s
                    else
                        zc_column(((r-1)/interval)+1) = 0;   % if r going in 5s
                    end
                    zc = false;
                end
                % append the zc_column to the existing zc table
                zc_dataset(:,ii) = zc_column;
            end
            processed_data(kk).(sets{ff})(1).ZC = zc_dataset;
        end
    end


    % ----------------------------------------------
    % Loop through all of the raw_data, extract maximum slope change.
    fprintf("\nManually extracting Maximum slope change...\n")
    % ----------------------------------------------
    % extract maximum slope for the data and add to the same processed_data
    % struct
    % loop through each of the folders
    for ff = 1 : length(sets)
        for kk = 1 : length(raw_data)
    %         fprintf("\nIn set number %i and dataset number %i, in set %s\n", ff, kk, sets(ff))
            current_dataset = raw_data(kk).(sets{ff});
            current_dataset_without_timestamp = current_dataset(:,2:end);
            current_timestamp = table2array(current_dataset(:,1));
            % -------------------------------------------------------
            % We should not assume that the timestep between samples is fixed.
            % Therefore, we find the average timestep for every dataset and
            % change the window size accordingly.

            % find the average timestep between rows
            avg_timestep = mean(diff(current_timestamp));
            % in case the timestep is in seconds rather than milliseconds
            if avg_timestep < 1
                avg_timestep = avg_timestep*1000;
            end
            % `window_size` defines the number of readings in each window
            window_size = int16(window_duration/avg_timestep);
            half_window_size = int16(window_size/2);
            %-------------------------------------------------------
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
                    if length(colm) < (window_size+2)
                        % if the column is smaller than the window size then
                        % take the whole column
                        h = colm;
                        timeColum = current_timestamp;
                    elseif r > (length(colm)-(half_window_size+1))
                        % if towards the end of the column, window/2 values
                        % before r and all values after it.
                        h = colm(r-half_window_size:end);
                        timeColum = current_timestamp(r-half_window_size:end);
                    elseif r < (half_window_size+1)
                        % if towards the start of the column, take all values
                        % before r and window/2 values after r
                        h = colm(1:r+half_window_size);
                        timeColum = current_timestamp(1:r+half_window_size);
                    else
                        % under normal conditions, take window/2 values before
                        % r and window/2 values after it
                        h = colm(r-half_window_size:r+half_window_size);
                        timeColum = current_timestamp(r-half_window_size:r+half_window_size);
                    end
                    % gradient() finds the slope change between consequetive
                    % data points. 
                    dydx = gradient(h) ./ gradient(timeColum);
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
end