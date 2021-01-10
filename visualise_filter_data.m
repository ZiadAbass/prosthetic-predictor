%{
This file takes in the struct containing all the datasets.
It picks one column in one dataset and visualises the effect of
a low pass filter on it.
You can change line 19 to pick a differnt sample.
%}

% good practice to start with these
% clear;      % clear the workspace
clc;        % clear the command window
close all;  % close all popup windows

% create a low pass filter
filter_Fs = 100;            % filter sampling rate
filter_Fc = 7;              % cutoff frequency in Hz
d = designfilt('lowpassfir', 'FilterOrder', 8, 'CutoffFrequency', filter_Fc, 'SampleRate', Fs);

% extract time column (x) and one feature (y)
current_dataset = raw_data(3).RA;
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

% ----------------------------------------------

% apply the low pass filter
filtered_Y = filter(d, Y);

% ----------------------------------------------

% plot a single reading before and after filtering using different colours
plot(x, Y, 'g')
hold on
plot(x, filtered_Y, 'r')