%{
This function takes in the struct containing all the datasets.
It extracts a column/feature in a given dataset and returns the required
data to visualise the effect of a low pass filter on it.
%}

function [x, Y, filtered_Y] = visualise_filter_data(raw_data, cutoffFreq, sampleRate, activityIndex, datasetIndex)
    % create a low pass filter with the given params
    d = designfilt('lowpassfir', 'FilterOrder', 8, 'CutoffFrequency', cutoffFreq, 'SampleRate', sampleRate);

    % extract time column (x) and one feature (y)
    sets = ["LGW","RA","RD","SiS","StS"];
    current_dataset = raw_data(datasetIndex).(sets{activityIndex});
    x = table2array(current_dataset(1:end,1));
    % ----------------------------------------------
    % Loop through a single dataset
    % ----------------------------------------------
    Y = 0;
    % loop through the columns in the single dataset
    for ii = 1 : width(current_dataset)
        % obtain the relevant column
        colm = table2array(current_dataset(:,ii));
        % ignore timestamp columns
        avg = abs(nanmean(colm));
        % if columns is NOT a timestamp one nor a 0 value one
        if (avg < 1000) && (avg > 0)
            % apply the filter on the column's values
            Y = colm;
            % overwrite the column with the filtered data
        end
    end
    % apply the low pass filter
    filtered_Y = filter(d, Y);
end


