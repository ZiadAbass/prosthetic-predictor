%{
This function is for finding the optimal params for the low pass filter.
It runs a low pass filter with the given params on random feature columns
and visualises the impact of the filter on these features in overlayed plots.

Arguments:
- `raw_data`    -> raw, unfiltered data 
- `cutoffFreq`  -> filter cutoff frequency (in Hz)
- `sampleRate`  -> filter sampling rate

%}

function [] = experimentFilters(raw_data, cutoffFreq, sampleRate)
    sets = ["LGW","RA","RD","SiS","StS"];
    for ii=1 : 8
        subplot(2,4,ii)
        set_index = rem(ii,length(sets))+1;
        % take a random sample of activities and datasets to plot before and after
        % applying the low pass filter
        [x, y, fy] = visualiseFilterData(raw_data, cutoffFreq, sampleRate, set_index, ii);
        % plot a single features before filtering in vlue
        plot(x, y, 'b')
        hold on
        % plot a single feature after filtering in red
        plot(x, fy, 'r')
        % give each subplot a title
        t = sprintf("%s dataset number %i", sets(set_index), ii);
        title(t)
    end
    % give all the subplots a main title
    mainTitle = sprintf("Single features before (blue) & after (red) applying a low pass filter of %i Hz", cutoffFreq);
    sgtitle(mainTitle)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%