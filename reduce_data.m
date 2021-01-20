%{
This function takes in a column containing timestamps and a table
containing an extracted feature (e.g. mean).
It also takes in the required time interval which will be used to determine
which rows/values to take.
It calculates the timestep between each row using the timestamp column and
deletes the rows that are not needed from the extracted features table.
Also takes in timeInterval which defines the time interval required in ms (delta t).
%}

function [reduced_data, interval]=reduce_data(timestampColumn,dataTable, timeInterval)

    % the max and min time increment steps allowed between consequetive
    % readings. If a step beyond the allowed limits is found an error is
    % raised. These are in milliseconds.
    maxStepAllowed_ms = 11;
    minStepAllowed_ms = 9;

    % read the timestamp and feature extracted
%     some_interval = current_timestamp;
%     some_data = meanCopy;

    % find the average timestep between rows
    avg_timestep = mean(diff(timestampColumn));

    % differentiate between seconds and milliseconds and define the interval
    % jump based on that. The 'interval' variable will define the Nth row to
    % take from the extracted data
    if (avg_timestep > minStepAllowed_ms) && (avg_timestep < maxStepAllowed_ms)
%         fprintf("\ntimestep is in milliseconds: %f\n", avg_timestep)
        interval = int16(timeInterval/avg_timestep);
    elseif (avg_timestep > minStepAllowed_ms/1000) && (avg_timestep < maxStepAllowed_ms/1000)
%         fprintf("\ntimestep is in seconds: %f\n", avg_timestep)
        interval = int16((timeInterval/1000)/avg_timestep);
    else
        fprintf("\nError - cannot determine the timestep unit: %f\n", avg_timestep)
    end

    % loop through the data and only take the relevant rows (e.g. every fifth row)
    for ii = 1 : interval : length(dataTable)
        index = (((ii-1)/5)+1);
        incrementing_reduced_data(index,:) = dataTable(index, :);
    end

    % return reduced_data
    reduced_data = incrementing_reduced_data;
end





