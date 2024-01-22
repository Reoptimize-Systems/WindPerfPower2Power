function filtered_data = syncAndFilterData (data, varargin)
% syncronises and filters SCADA for power to power comparison
%
% Syntax
%
% filtered_data = filterData (data)
% filtered_data = filterData (data, varargin)
%
% Description
%
% 
%
% Input
%
%  Data - Nested structure containing the following fields:
%
%    ControlWTPre : Structure containing data from the control turbine in the
%      period prior to modification of control parameters on the test turbine.
%
%    ControlWTPost : Structure containing data from the control turbine in the
%      period after modification of control parameters on the test turbine.
%
%    TestWTPre : Structure containing data from test turbine in the period prior
%      to modification of control parameters on the test turbine.
%
%    TestWTPost : Structure containing data from the test turbine in the
%      period after modification of control parameters on the test turbine.
%
%    Each of these sub-structures must contain at least the following fields:
%
%    Time :
%
%    PowerActive :
%
%    TemperatureExternal :
%
%    DirectionNacelle :
%
%    Depending on the options used for processing, the following fields may also
%    be required in each sub-structure.
%
%    RPM :
%
%    IsOperational :
%
%    IsCurtailed :
%
%

%% Setting up parse arguements

options.FilterWakeInteraction = false; % unused so far
options.IcingFilterTemperature = 2; % used to filter out data where outside temperture is too low. 
options.OperationalRPMThreshold = 3; % Only enabled if "options.OperationalFilterMethod" (2 lines down) is set to rpm
options.OperationalWindSpeedThreshold = []; % unused
options.OperationalFilterMethod = 'rpm'; % Select 'rpm', 'flag', or 'none' 
options.CurtailedFilterMethod = 'none'; % Select 'daily_times_and_durations', 'flag', or 'none'
options.CurtailedDailyTimesAndDurations = []; % CHECK my understanding is that the times at which a wind turbine is curtailed is probably recorded. 
options.WindDirectionThreshNBins = 37; % Number of edges, ie 37 will create 36 bins of 10 degrees
options.WindDirectionNumSamplesThresh = 1000; % Minimum number of samples required for each directional bin
options.PowerRangeThreshBinSize = 5000; % The rough size in W for each power bin
options.PowerRangeNumSamplesThresh = 5; %5 % (very low bc sample small at the mo) % Minimum number of samples required for each power bin
options.DataGapInfillThreshold = 5; % TBC, but I think that: This is the time between consecutive samples which is too big (anything smaller is OK)
options.SyncronisedTimeStepSize = 1; % TBC
options.TestTurbineTimeShift = 0; % manual shifting of time series
options.OperationalPowerThreshold = 1e-4; % New variable to remove all P = 0s 
options.Troubleshooting = 0; % 1 = plot sync filter only; 2 = plot sync and op filter; ...

options = windp2p.parse_pv_pairs (options, varargin);

%%

% TODO: need input validation here

%% Synchronise and interpolate the data time series (function at the bottom of script)

filtered_data = syncronize_data (data, 'ControlWTPre', 'TestWTPre', options);
filtered_data = syncronize_data (data, 'ControlWTPost', 'TestWTPost', options);

if options.Troubleshooting == 1
    [~] = plot200(data, filtered_data);
    sgtitle 'Plotting synchronisation filter'
end

%% filter by Test Turbine and Reference Turbine operational, filtering by
% status code or e.g. by RPM signal
switch options.OperationalFilterMethod

    case 'rpm'

        bad_inds = find(filtered_data.ControlWTPre.RPM < options.OperationalRPMThreshold);
        filtered_data.ControlWTPre =  strip_data_bad_inds_all_fields (filtered_data.ControlWTPre, bad_inds);
        filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, bad_inds);

        bad_inds = find(filtered_data.ControlWTPost.RPM < options.OperationalRPMThreshold);
        filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, bad_inds);
        filtered_data.TestWTPost = strip_data_bad_inds_all_fields (filtered_data.TestWTPost, bad_inds);

        bad_inds = find(filtered_data.TestWTPre.RPM < options.OperationalRPMThreshold);
        filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, bad_inds);
        filtered_data.ControlWTPre =  strip_data_bad_inds_all_fields (filtered_data.ControlWTPre, bad_inds);

        bad_inds = find(filtered_data.TestWTPost.RPM < options.OperationalRPMThreshold);
        filtered_data.TestWTPost = strip_data_bad_inds_all_fields (filtered_data.TestWTPost, bad_inds);
        filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, bad_inds);


    case 'flag'

        % yes, the following is long-winded, but at least the problem will
        % be clear
        if ~isfield(data.ControlWTPre, 'IsOperational')
            error ('OperationalFilterMethod is %s, but data.ControlWTPre does not have the ''IsOperational'' field', ...
                    options.OperationalFilterMethod);
        end
        if ~isfield(data.ControlWTPost, 'IsOperational')
            error ('OperationalFilterMethod is %s, but data.ControlWTPost does not have the ''IsOperational'' field', ...
                    options.OperationalFilterMethod);
        end
        if ~isfield(data.TestWTPre, 'IsOperational')
            error ('OperationalFilterMethod is %s, but data.TestWTPre does not have the ''IsOperational'' field', ...
                    options.OperationalFilterMethod);
        end
        if ~isfield(data.TestWTPost, 'IsOperational')
            error ('OperationalFilterMethod is %s, but data.TestWTPost does not have the ''IsOperational'' field', ...
                    options.OperationalFilterMethod);
        end

        % leave only pre data where both turbines are simultaneously
        % operational
        filtered_data.ControlWTPre = leave_data_good_inds_all_fields (filtered_data.ControlWTPre, data.ControlWTPre.IsOperational);
        filtered_data.TestWTPre = leave_data_good_inds_all_fields (filtered_data.TestWTPre, data.ControlWTPre.IsOperational);

        filtered_data.ControlWTPost = leave_data_good_inds_all_fields (filtered_data.ControlWTPost, data.ControlWTPost.IsOperational);
        filtered_data.TestWTPost = leave_data_good_inds_all_fields (filtered_data.TestWTPost, data.ControlWTPost.IsOperational);


        filtered_data.TestWTPre = leave_data_good_inds_all_fields (filtered_data.TestWTPre, data.TestWTPre.IsOperational);
        filtered_data.ControlWTPre = leave_data_good_inds_all_fields (filtered_data.ControlWTPre, data.TestWTPre.IsOperational);

        filtered_data.TestWTPost = leave_data_good_inds_all_fields (filtered_data.TestWTPost, data.TestWTPost.IsOperational);
        filtered_data.ControlWTPost = leave_data_good_inds_all_fields (filtered_data.ControlWTPost, data.TestWTPost.IsOperational);

    case 'none'

        % do nothing

    otherwise

        error ('Unrecognised OperationalFilterMethod: ''%s''', options.OperationalFilterMethod);

end





%%%%%%%%%% New addition, remove all tiny powers, to tidy up speed-power and
%%%%%%%%%% wind speed-power curves

% NOTE: unintended consequence is the removal of lots of lower RPM values

bad_inds = find(abs(filtered_data.ControlWTPre.PowerActive) < options.OperationalPowerThreshold);
filtered_data.ControlWTPre =  strip_data_bad_inds_all_fields (filtered_data.ControlWTPre, bad_inds);
filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, bad_inds);

bad_inds = find(abs(filtered_data.ControlWTPost.PowerActive) < options.OperationalPowerThreshold);
filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, bad_inds);
filtered_data.TestWTPost = strip_data_bad_inds_all_fields (filtered_data.TestWTPost, bad_inds);

bad_inds = find(abs(filtered_data.TestWTPre.PowerActive) < options.OperationalPowerThreshold);
filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, bad_inds);
filtered_data.ControlWTPre =  strip_data_bad_inds_all_fields (filtered_data.ControlWTPre, bad_inds);

bad_inds = find(abs(filtered_data.TestWTPost.PowerActive) < options.OperationalPowerThreshold);
filtered_data.TestWTPost = strip_data_bad_inds_all_fields (filtered_data.TestWTPost, bad_inds);
filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, bad_inds);

%%%%%%%%%% New addition end

%%%%%%%%%% New addition, remove all negative powers

% NOTE: This is to simplify the binning process later.

bad_inds = find((filtered_data.ControlWTPre.PowerActive) < 0);
filtered_data.ControlWTPre =  strip_data_bad_inds_all_fields (filtered_data.ControlWTPre, bad_inds);
filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, bad_inds);

bad_inds = find((filtered_data.ControlWTPost.PowerActive) < 0);
filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, bad_inds);
filtered_data.TestWTPost = strip_data_bad_inds_all_fields (filtered_data.TestWTPost, bad_inds);

bad_inds = find((filtered_data.TestWTPre.PowerActive) < 0);
filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, bad_inds);
filtered_data.ControlWTPre =  strip_data_bad_inds_all_fields (filtered_data.ControlWTPre, bad_inds);

bad_inds = find((filtered_data.TestWTPost.PowerActive) < 0);
filtered_data.TestWTPost = strip_data_bad_inds_all_fields (filtered_data.TestWTPost, bad_inds);
filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, bad_inds);

%%%%%%%%%% New addition end




if options.Troubleshooting == 2
    [~] = plot200(data, filtered_data);
    sgtitle 'Plotting synchronisation filter & operational method filter'
end

%% filter by Test Turbine and Reference Turbine not curtailed, filtering by status signal
switch options.CurtailedFilterMethod

    case 'daily_times_and_durations'

        error ('CurtailedFilterMethod ''daily_times_and_durations '' method not yet implemented');

        if ~isstruct (options.CurtailedDailyTimesAndDurations) ...
            || ~isscalar (options.CurtailedDailyTimesAndDurations)

            error ('CurtailedDailyTimesAndDurations must be a scalar structure');

        end

        if isfield ( options.CurtailedDailyTimesAndDurations, 'TimesAndDurations')

            options.CurtailedDailyTimesAndDurations.TimesAndDurations = sortrows (options.CurtailedDailyTimesAndDurations.TimesAndDurations, 1);

            % TODO : check curtailed times don't overlap

        end

        % TODO complete CurtailedFilterMethod daily_times_and_durations method

    case 'flag'

        % yes, the following tests are long-winded, but at least the problem will
        % be clear immediately
        if ~isfield(data.ControlWTPre, 'IsCurtailed')
            error ('CurtailedFilterMethod is %s, but data.ControlWTPre does not have the ''IsCurtailed'' field', ...
                    options.CurtailedFilterMethod);
        end
        if ~isfield(data.ControlWTPost, 'IsCurtailed')
            error ('CurtailedFilterMethod is %s, but data.ControlWTPost does not have the ''IsCurtailed'' field', ...
                    options.CurtailedFilterMethod);
        end
        if ~isfield(data.TestWTPre, 'IsCurtailed')
            error ('CurtailedFilterMethod is %s, but data.TestWTPre does not have the ''IsCurtailed'' field', ...
                    options.CurtailedFilterMethod);
        end
        if ~isfield(data.TestWTPost, 'IsCurtailed')
            error ('CurtailedFilterMethod is %s, but data.TestWTPost does not have the ''IsCurtailed'' field', ...
                    options.CurtailedFilterMethod);
        end

        filtered_data.ControlWTPre = strip_data_bad_inds_all_fields (filtered_data.ControlWTPre, data.ControlWTPre.IsCurtailed);
        filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, data.ControlWTPre.IsCurtailed);

        filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, data.ControlWTPost.IsCurtailed);
        filtered_data.TestWTPost = strip_data_bad_inds_all_fields (filtered_data.TestWTPost, data.ControlWTPost.IsCurtailed);

        filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, data.TestWTPre.IsCurtailed);
        filtered_data.ControlWTPre = strip_data_bad_inds_all_fields (filtered_data.ControlWTPre, data.TestWTPre.IsCurtailed);

        filtered_data.TestWTPost = strip_data_bad_inds_all_fields (filtered_data.TestWTPost, data.TestWTPost.IsCurtailed);
        filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, data.TestWTPost.IsCurtailed);

    case 'none'

        % do nothing

    otherwise

        error ('Unrecognised OperationalFilterMethod: ''%s''', options.OperationalFilterMethod);

end

%% filter by no blade icing

good_inds = find(filtered_data.ControlWTPre.TemperatureExternal > options.IcingFilterTemperature);
filtered_data.ControlWTPre = leave_data_good_inds_all_fields (filtered_data.ControlWTPre, good_inds);
filtered_data.TestWTPre = leave_data_good_inds_all_fields (filtered_data.TestWTPre, good_inds);

good_inds = find(filtered_data.ControlWTPost.TemperatureExternal > options.IcingFilterTemperature);
filtered_data.ControlWTPost = leave_data_good_inds_all_fields (filtered_data.ControlWTPost, good_inds);
filtered_data.TestWTPost = leave_data_good_inds_all_fields (filtered_data.TestWTPost, good_inds);

good_inds = find(filtered_data.TestWTPre.TemperatureExternal > options.IcingFilterTemperature);
filtered_data.TestWTPre = leave_data_good_inds_all_fields (filtered_data.TestWTPre, good_inds);
filtered_data.ControlWTPre = leave_data_good_inds_all_fields (filtered_data.ControlWTPre, good_inds);

good_inds = find(filtered_data.TestWTPost.TemperatureExternal > options.IcingFilterTemperature);
filtered_data.TestWTPost = leave_data_good_inds_all_fields (filtered_data.TestWTPost, good_inds);
filtered_data.ControlWTPost = leave_data_good_inds_all_fields (filtered_data.ControlWTPost, good_inds);


if options.Troubleshooting == 3
    [~] = plot200(data, filtered_data);
    sgtitle 'Plotting synchronisation filter, operational method filter & blade icing'
end

%% optionally filter by Test Turbine and Reference Turbine free of wakes is often % preferable
if options.FilterWakeInteraction

    % TODO: Filter Wake Interaction

end

%% In Testing Period: use only wind direction ranges and power ranges also covered by Training Period

% make histogram of nacelle direction ranges for both turbine training (pre) data sets
nacelle_direction_edges = linspace(0, 360, options.WindDirectionThreshNBins);

N_samples_ControlWTPre_DirectionNacelle = histcounts(filtered_data.ControlWTPre.DirectionNacelle, nacelle_direction_edges);
N_samples_TestWTPre_DirectionNacelle = histcounts(filtered_data.TestWTPre.DirectionNacelle, nacelle_direction_edges);

% find wind directions where number of samples are greater a minimum threshold of samples
good_directions = N_samples_ControlWTPre_DirectionNacelle >= options.WindDirectionNumSamplesThresh ...
                    & N_samples_TestWTPre_DirectionNacelle >= options.WindDirectionNumSamplesThresh;

% MK NOTE: "edges" does not exist, let's try to add this:
edges = nacelle_direction_edges;

% keep only data with these wind directions from all four data sets
for ind = 1:numel(edges)-1 % For each bin

    if good_directions(ind) == false % if there are insufficient data points in the good_directions vector, discard datapoints with that direction in all 4 datasets

        bad_inds = find(filtered_data.ControlWTPre.DirectionNacelle >= edges(ind) ...
                          & filtered_data.ControlWTPre.DirectionNacelle <= edges(ind+1) );

        filtered_data.ControlWTPre = strip_data_bad_inds_all_fields (filtered_data.ControlWTPre, bad_inds);

        bad_inds = find(filtered_data.ControlWTPost.DirectionNacelle >= edges(ind) ...
                          & filtered_data.ControlWTPost.DirectionNacelle <= edges(ind+1) );

        filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, bad_inds);

        bad_inds = find(filtered_data.TestWTPre.DirectionNacelle >= edges(ind) ...
                          & filtered_data.TestWTPre.DirectionNacelle <= edges(ind+1) );

        filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, bad_inds);

        bad_inds = find(filtered_data.TestWTPost.DirectionNacelle >= edges(ind) ...
                          & filtered_data.TestWTPost.DirectionNacelle <= edges(ind+1) );

        filtered_data.TestWTPost = strip_data_bad_inds_all_fields (filtered_data.TestWTPost, bad_inds);

    end

end

% find the maximum power in all data
max_power_all_tests = max( [ max(filtered_data.ControlWTPre.PowerActive), ...
                             max(filtered_data.ControlWTPost.PowerActive), ...
                             max(filtered_data.TestWTPre.PowerActive), ...
                             max(filtered_data.TestWTPre.PowerActive) ] );

% find the minimum power in all data (remember we have filtered for
% operational data above already)
min_power_all_tests = min( [ min(filtered_data.ControlWTPre.PowerActive), ...
                             min(filtered_data.ControlWTPost.PowerActive), ...
                             min(filtered_data.TestWTPre.PowerActive), ...
                             min(filtered_data.TestWTPre.PowerActive) ] );

% make histogram of power ranges for both turbine training (pre) data sets
power_bin_edges = linspace( min_power_all_tests, ...
                            max_power_all_tests, ...
                            round((max_power_all_tests - min_power_all_tests)./options.PowerRangeThreshBinSize) ...
                          );

N_samples_ControlWTPre = histcounts( filtered_data.ControlWTPre.PowerActive, power_bin_edges );
N_samples_TestWTPre = histcounts(filtered_data.TestWTPre.PowerActive, power_bin_edges);

% find power bins where number of samples are greater a minimum
% threshold of samples
good_power = N_samples_ControlWTPre >= options.PowerRangeNumSamplesThresh ...
                    & N_samples_TestWTPre >= options.PowerRangeNumSamplesThresh;

if options.Troubleshooting == 4
    [~] = plot200(data, filtered_data);
end

edges = power_bin_edges;


% Find power ranges where number of samples fall below a minimum threshold of samples
% keep only data with these power ranges from all four data sets
for ind = 1:numel(edges)-1

    if good_power(ind) == false

        binstart = edges(ind);

        bad_inds = find(filtered_data.ControlWTPre.PowerActive >= edges(ind) ...
                          & filtered_data.ControlWTPre.PowerActive <= edges(ind+1) );

        filtered_data.ControlWTPre = strip_data_bad_inds_all_fields (filtered_data.ControlWTPre, bad_inds);

        bad_inds = find(filtered_data.ControlWTPost.PowerActive >= edges(ind) ...
                          & filtered_data.ControlWTPost.PowerActive <= edges(ind+1) );

        filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, bad_inds);

        bad_inds = find(filtered_data.TestWTPre.PowerActive >= edges(ind) ...
                          & filtered_data.TestWTPre.PowerActive <= edges(ind+1) );

        filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, bad_inds);

        bad_inds = find(filtered_data.TestWTPost.PowerActive >= edges(ind) ...
                          & filtered_data.TestWTPost.PowerActive <= edges(ind+1) );

        filtered_data.TestWTPost = strip_data_bad_inds_all_fields (filtered_data.TestWTPost, bad_inds);

        % [~] = plot200(data, filtered_data);
        
    end

end


if options.Troubleshooting == 5
    [~] = plot200(data, filtered_data);
    sgtitle 'Plotting impact of power binning'
end

    % finally syncronize the time series?

end

function data = syncronize_data (data, field1, field2, options)

    % shift the test turbine time by the specified time in seconds (default
    % is zero, i.e. no shift). 
    data.(field2).Time = data.(field2).Time + options.TestTurbineTimeShift;

    % calculate the durations between all time steps for the pre-test
    % period
    time_diff_field1 = diff (data.(field1).Time);
    time_diff_field2 = diff (data.(field2).Time);

    % identify the data where the durations between time steps are below a
    % chosen threshold, e.g. 5 x the nominal sample period or something
    % (should be almost entirely 1s)
    sample_threshold_field1 = time_diff_field1 < options.DataGapInfillThreshold;
    sample_threshold_field2 = time_diff_field2 < options.DataGapInfillThreshold;

    % find the transistions between 0-1 and 1-0 to locate where in the time
    % series the 'good' (without a gap in the time steps) blocks start and
    % end
    field1_good_start_time_inds = find(diff([false, sample_threshold_field1]) == 1);% should include the first time sample (ie 1) as a minimum
    field1_good_end_time_inds = find(diff([sample_threshold_field1, false]) == -1) + 1; % should include the last sample (ie length(dataset) ) as a minimum

    field2_good_start_time_inds = find(diff([false, sample_threshold_field2]) == 1);% should include the first time sample (ie 1) as a minimum
    field2_good_end_time_inds = find(diff([sample_threshold_field2, false]) == -1) + 1;% should include the last sample (ie length(dataset) ) as a minimum

    % create a new time series with the desired time step, starting from
    % the earlier of the two time series and ending at the later
    new_series_start_time = round2 (min ( [data.(field1).Time(:); data.(field2).Time(:)] ), options.SyncronisedTimeStepSize);
    new_series_end_time = round2 (max ( [data.(field1).Time(:); data.(field2).Time(:)] ), options.SyncronisedTimeStepSize);

    new_time = new_series_start_time : options.SyncronisedTimeStepSize : new_series_end_time; % if this is empty then there has been a mistake somewhere

    % find the overlapping times
    field1_good_new_times = false(size (new_time));
    for ind = 1:numel(field1_good_start_time_inds)

        field1_good_new_times = field1_good_new_times | ...
                                    ( new_time >= data.(field1).Time (field1_good_start_time_inds(ind)) ...
                                        & new_time <= data.(field1).Time (field1_good_end_time_inds(ind)) );

    end

    field2_good_new_times = false(size (new_time));
    for ind = 1:numel(field2_good_start_time_inds)

        field2_good_new_times = field2_good_new_times | ...
                                    ( new_time >= data.(field2).Time (field2_good_start_time_inds(ind)) ...
                                        & new_time <= data.(field2).Time (field2_good_end_time_inds(ind)) );

    end

    % the new times at which we want the interpolated values from both
    % time series
    new_time = new_time(field1_good_new_times & field2_good_new_times);

    % now interpolate all data fields at the desired new time points which
    % are common to both time series
    data_fieldnames = fieldnames (data.(field1));

    for data_field_name = data_fieldnames'

        if ~strcmp(data_field_name{1}, 'Time')
            data.(field1).(data_field_name{1}) = interp1 (data.(field1).Time, data.(field1).(data_field_name{1}), new_time);
            data.(field2).(data_field_name{1}) = interp1 (data.(field2).Time, data.(field2).(data_field_name{1}), new_time);
        end

    end

    data.(field1).Time = new_time;
    data.(field2).Time = new_time;

end

function turbine_data = leave_data_good_inds_all_fields (turbine_data, good_inds)
% strips data not reported as good from all fields of a structure

    data_fieldnames = fieldnames (turbine_data);

    for data_field_name = data_fieldnames'

        turbine_data.(data_field_name{1}) = turbine_data.(data_field_name{1})(good_inds);

    end

end

function turbine_data = strip_data_bad_inds_all_fields (turbine_data, bad_inds)
% strips data reported as bad from all fields of a structure

    data_fieldnames = fieldnames (turbine_data);

    for data_field_name = data_fieldnames'

        turbine_data.(data_field_name{1})(bad_inds) = [];

    end

end

function test = plot200(data, filtered_data)

    figure(200)
    ax1 = subplot(4, 4, 1);
    plot(data.ControlWTPre.Time, data.ControlWTPre.RPM,'*r')
    hold on
    plot(filtered_data.ControlWTPre.Time, filtered_data.ControlWTPre.RPM,'ob')
    hold off
    grid minor
    legend Unfiltered Filtered 
    ylabel 'RPM'
    % xlim([0 500])
    title 'ControlWTPre'
    ax5 = subplot(4, 4, 5);
    plot(data.ControlWTPre.Time, data.ControlWTPre.PowerActive,'*r')
    hold on
    plot(filtered_data.ControlWTPre.Time, filtered_data.ControlWTPre.PowerActive,'ob')
    hold off
    grid minor
    ylabel 'P'
    % xlim([0 500])
    % % % % % 
    ax2 = subplot(4, 4, 2);
    plot(data.TestWTPre.Time, data.TestWTPre.RPM,'*r')
    hold on
    plot(filtered_data.TestWTPre.Time, filtered_data.TestWTPre.RPM,'ob')
    hold off
    grid minor
    ylabel 'RPM'
    % xlim([0 500])
    title 'TestWTPre'
    ax6 = subplot(4, 4, 6);
    plot(data.TestWTPre.Time, data.TestWTPre.PowerActive,'*r')
    hold on
    plot(filtered_data.TestWTPre.Time, filtered_data.TestWTPre.PowerActive,'ob')
    hold off
    grid minor
    ylabel 'P'
    % xlim([0 500])
    % % % % % 
    ax3 = subplot(4, 4, 3);
    plot(data.ControlWTPost.Time, data.ControlWTPost.RPM,'*r')
    hold on
    plot(filtered_data.ControlWTPost.Time, filtered_data.ControlWTPost.RPM,'ob')
    hold off
    grid minor
    ylabel 'RPM'
    % xlim([0 500]+10000)
    title 'ControlWTPost'
    ax7 = subplot(4, 4, 7);
    plot(data.ControlWTPost.Time, data.ControlWTPost.PowerActive,'*r')
    hold on
    plot(filtered_data.ControlWTPost.Time, filtered_data.ControlWTPost.PowerActive,'ob')
    hold off
    grid minor
    ylabel 'P'
    % xlim([0 500]+10000)
    % % % % % 
    ax4 = subplot(4, 4, 4);
    plot(data.TestWTPost.Time, data.TestWTPost.RPM,'*r')
    hold on
    plot(filtered_data.TestWTPost.Time, filtered_data.TestWTPost.RPM,'ob')
    hold off
    grid minor
    ylabel 'RPM'
    % xlim([0 500]+10000)
    title 'TestWTPost'
    ax8 = subplot(4, 4, 8);
    plot(data.TestWTPost.Time, data.TestWTPost.PowerActive,'*r')
    hold on
    plot(filtered_data.TestWTPost.Time, filtered_data.TestWTPost.PowerActive,'ob')
    hold off
    grid minor
    ylabel 'P'
    % xlim([0 500]+10000)
    %
    %
    %
    %
    ax9 = subplot(4, 4, 9);
    plot(data.ControlWTPre.Time, data.ControlWTPre.TemperatureExternal,'*r')
    hold on
    plot(filtered_data.ControlWTPre.Time, filtered_data.ControlWTPre.TemperatureExternal,'ob')
    hold off
    grid minor
    legend Unfiltered Filtered 
    ylabel 'Temp Ext'
    % xlim([0 500])
    ylim([-5 20])
    ax13 = subplot(4, 4, 13);
    plot(data.ControlWTPre.Time, data.ControlWTPre.DirectionNacelle,'*r')
    hold on
    plot(filtered_data.ControlWTPre.Time, filtered_data.ControlWTPre.DirectionNacelle,'ob')
    hold off
    grid minor
    ylabel 'Dir Nacelle'
    % xlim([0 500])
    % % % % % 
    ax10 = subplot(4, 4, 10);
    plot(data.TestWTPre.Time, data.TestWTPre.TemperatureExternal,'*r')
    hold on
    plot(filtered_data.TestWTPre.Time, filtered_data.TestWTPre.TemperatureExternal,'ob')
    hold off
    grid minor
    ylabel 'Temp Ext'
    % xlim([0 500])
    ylim([-5 20])
    ax14 = subplot(4, 4, 14);
    plot(data.TestWTPre.Time, data.TestWTPre.DirectionNacelle,'*r')
    hold on
    plot(filtered_data.TestWTPre.Time, filtered_data.TestWTPre.DirectionNacelle,'ob')
    hold off
    grid minor
    ylabel 'Dir Nacelle'
    % xlim([0 500])
    % % % % % 
    ax11 = subplot(4, 4, 11);
    plot(data.ControlWTPost.Time, data.ControlWTPost.TemperatureExternal,'*r')
    hold on
    plot(filtered_data.ControlWTPost.Time, filtered_data.ControlWTPost.TemperatureExternal,'ob')
    hold off
    grid minor
    ylabel 'Temp Ext'
    % xlim([0 500]+10000)
    ylim([-5 20])
    ax15 = subplot(4, 4, 15);
    plot(data.ControlWTPost.Time, data.ControlWTPost.DirectionNacelle,'*r')
    hold on
    plot(filtered_data.ControlWTPost.Time, filtered_data.ControlWTPost.DirectionNacelle,'ob')
    hold off
    grid minor
    ylabel 'Dir Nacelle'
    % xlim([0 500]+10000)
    % % % % % 
    ax12 = subplot(4, 4, 12);
    plot(data.TestWTPost.Time, data.TestWTPost.TemperatureExternal,'*r')
    hold on
    plot(filtered_data.TestWTPost.Time, filtered_data.TestWTPost.TemperatureExternal,'ob')
    hold off
    grid minor
    ylabel 'Temp Ext'
    % xlim([0 500]+10000)
    ylim([-5 20])
    ax16 = subplot(4, 4, 16);
    plot(data.TestWTPost.Time, data.TestWTPost.DirectionNacelle,'*r')
    hold on
    plot(filtered_data.TestWTPost.Time, filtered_data.TestWTPost.DirectionNacelle,'ob')
    hold off
    grid minor
    ylabel 'Dir Nacelle'
    % xlim([0 500]+10000)

    % xlim([     min([data.ControlWTPre.Time(1) data.TestWTPre.Time(1)])...
    %      max([data.ControlWTPre.Time(end) data.TestWTPre.Time(end)])    ])

    linkaxes([ax1 ax2 ax5 ax6 ax9 ax10 ax13 ax14],'x')

    % xlim([     min([data.ControlWTPost.Time(1) data.TestWTPost.Time(1)])...
    %     max([data.ControlWTPost.Time(end) data.TestWTPost.Time(end)])    ])

    linkaxes([ax3 ax4 ax7 ax8 ax11 ax12 ax15 ax16],'x')

    test = 1;
end

