%{
This file takes in the struct containing all the datasets 
and filters the data using a low pass filter
%}

function raw_data = filter_data(raw_data)
    close all;  % close all popup windows

    % create a low pass filter
    filter_Fs = 100;            % filter sampling rate
    filter_Fc = 7;              % cutoff frequency in Hz
    d = designfilt('lowpassfir', 'FilterOrder', 8, 'CutoffFrequency', filter_Fc, 'SampleRate', filter_Fs);

    % extract time column (x) and one feature (y)
    current_dataset = raw_data(3).RA;
%     x = table2array(current_dataset(1:end,1));

    % ----------------------------------------------
    % Loop through all of the raw_data and apply the filter on each column
    % ----------------------------------------------
    % array containing the names of the folders. These names will match the
    % field names in the struct
    sets = ["LGW","RA","RD","SiS","StS"];
    % loop through each of the folders
    for ff = 1 : length(sets)
        for kk = 1 : length(raw_data)
            % sequentially extract a single dataset
            current_dataset = raw_data(kk).(sets{ff});
            % Filter the data
            % loop through the columns in the single dataset
            for ii = 1 : width(current_dataset)
                % obtain the relevant column
                colm = table2array(current_dataset(1:end,ii));
                % ignore timestamp columns
                avg = abs(nanmean(colm));
                % if columns is NOT a timestamp one and not a 0 value one
                if (avg < 1000) && (avg ~= 0)
                    % apply the filter on the column
                    filtered_Y = filter(d, colm);
                    % update the column in the strut with the filtered data
                    raw_data(kk).(sets{ff})(:,ii) = array2table(filtered_Y);
                end
            end
        end
    end

    % ----------------------------------------------
end