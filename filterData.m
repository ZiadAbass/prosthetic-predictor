%{
This function takes in the struct containing all the raw data and runs it 
through a low pass filter.

Arguments:
- `rawData`    -> struct containing the data imported from the folders

Returns:
- `rawData`    -> updated struct containing the filtered data
%}

function rawData = filterData(rawData)
    % create a low pass filter
    filter_Fs = 100;            % filter sampling rate
    filter_Fc = 7;              % cutoff frequency in Hz
    % create the low pass filter
    d = designfilt('lowpassfir', 'FilterOrder', 8, 'CutoffFrequency', filter_Fc, 'SampleRate', filter_Fs);
    % ----------------------------------------------
    % Loop through all of the rawData and apply the filter on each column
    % ----------------------------------------------
    % array containing the names of the folders. These names will match the
    % field names in the struct
    sets = ["LGW","RA","RD","SiS","StS"];
    % loop through each of the folders
    for ff = 1 : length(sets)
        for kk = 1 : length(rawData)
            % sequentially extract a single dataset
            current_dataset = rawData(kk).(sets{ff});
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
                    rawData(kk).(sets{ff})(:,ii) = array2table(filtered_Y);
                end
            end
        end
    end

    % ----------------------------------------------
end