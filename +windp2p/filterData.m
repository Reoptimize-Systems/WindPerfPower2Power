function filtered_data = filterData (data, varargin)


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
%    Dpending on the options used for processing, the following fields may also
%    be required in each sub-structure.
%
%    RPM :
%
%    IsOperational :
%
%    IsCurtailed :
%
%

    options.FilterWakeInteraction = false;
    options.IcingFilterTemperature = 5;
    options.OperationalRPMThreshold = 4;
    options.OperationalWindSpeedThreshold = [];
    options.OperationalFilterMethod = 'rpm';
    options.CurtailedFilterMethod = 'flag';
    options.CurtailedDailyTimesAndDurations = [];
    options.WindDirectionThreshNBins = 12;
    options.WindDirectionNumSamplesThresh = 1000;
    options.PowerRangeThreshBinSize = 5000;
    options.PowerRangeNumSamplesThresh = 1000;


    options = windp2p.parse_pv_pairs (options, varargin);

    % TODO: need input validation here


    % filter by Test Turbine and Reference Turbine operational, filtering by
    % status code or e.g. by RPM signal
    switch options.OperationalFilterMethod

        case 'rpm'

            good_inds = find(filtered_data.ControlWTPre.RPM >= options.OperationalRPMThreshold);
            filtered_data.ControlWTPre = leave_data_good_inds_all_fields (filtered_data.ControlWTPre, good_inds);

            good_inds = find(filtered_data.ControlWTPost.RPM >= options.OperationalRPMThreshold);
            filtered_data.ControlWTPost = leave_data_good_inds_all_fields (filtered_data.ControlWTPost, good_inds);

            good_inds = find(filtered_data.TestWTPre.RPM >= options.OperationalRPMThreshold);
            filtered_data.TestWTPre = leave_data_good_inds_all_fields (filtered_data.TestWTPre, good_inds);

            good_inds = find(filtered_data.TestWTPost.RPM >= options.OperationalRPMThreshold);
            filtered_data.TestWTPost = leave_data_good_inds_all_fields (filtered_data.TestWTPost, good_inds);


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

            filtered_data.ControlWTPre = leave_data_good_inds_all_fields (filtered_data.ControlWTPre, data.ControlWTPre.IsOperational);
            filtered_data.ControlWTPost = leave_data_good_inds_all_fields (filtered_data.ControlWTPost, data.ControlWTPost.IsOperational);
            filtered_data.TestWTPre = leave_data_good_inds_all_fields (filtered_data.TestWTPre, data.TestWTPre.IsOperational);
            filtered_data.TestWTPost = leave_data_good_inds_all_fields (filtered_data.TestWTPost, data.TestWTPost.IsOperational);

        otherwise

            error ('Unrecognised OperationalFilterMethod: ''%s''', options.OperationalFilterMethod);

    end


    % filter by Test Turbine and Reference Turbine not curtailed, filtering by
    % status signal
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
            filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, data.ControlWTPost.IsCurtailed);
            filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, data.TestWTPre.IsCurtailed);
            filtered_data.TestWTPost = strip_data_bad_inds_all_fields (filtered_data.TestWTPost, data.TestWTPost.IsCurtailed);

        otherwise

            error ('Unrecognised OperationalFilterMethod: ''%s''', options.OperationalFilterMethod);

    end

    % filter by no blade icing
    good_inds = find(filtered_data.ControlWTPre.TemperatureExternal > options.IcingFilterTemperature);
    filtered_data.ControlWTPre = leave_data_good_inds_all_fields (filtered_data.ControlWTPre, good_inds);

    good_inds = find(filtered_data.ControlWTPost.TemperatureExternal > options.IcingFilterTemperature);
    filtered_data.ControlWTPost = leave_data_good_inds_all_fields (filtered_data.ControlWTPost, good_inds);

    good_inds = find(filtered_data.TestWTPre.TemperatureExternal > options.IcingFilterTemperature);
    filtered_data.TestWTPre = leave_data_good_inds_all_fields (filtered_data.TestWTPre, good_inds);

    good_inds = find(filtered_data.TestWTPost.TemperatureExternal > options.IcingFilterTemperature);
    filtered_data.TestWTPost = leave_data_good_inds_all_fields (filtered_data.TestWTPost, good_inds);


    % optionally filter by Test Turbine and Reference Turbine free of wakes is often
    % preferable
    if options.FilterWakeInteraction

        % TODO: Filter Wake Interaction

    end

    % In Testing Period: use only wind direction ranges and power ranges also
    % covered by Training Period

    % make histogram of nacelle direction ranges for both turbine training (pre) data set
    nacelle_direction_edges = linspace(0, 360, options.WindDirectionThreshNBins);

    [N_samples_ControlWTPre, nacelle_direction_edges] = ...
        histcounts(filtered_data.ControlWTPre.DirectionNacelle, nacelle_direction_edges);

    N_samples_TestWTPre = histcounts(filtered_data.TestWTPre.DirectionNacelle, nacelle_direction_edges);

    % find wind directions where number of samples are greater a minimum threshold of samples
    good_directions = N_samples_ControlWTPre >= options.WindDirectionNumSamplesThresh ...
                        && N_samples_TestWTPre >= options.WindDirectionNumSamplesThresh


    % keep only data with these wind directions from all four data sets
    for ind = 1:numel(edges)-1

        if good_directions(ind) == false

            bad_inds = find(filtered_data.ControlWTPre.DirectionNacelle >= edges(ind) ...
                              && filtered_data.ControlWTPre.DirectionNacelle >= edges(ind+1) );

            filtered_data.ControlWTPre = strip_data_bad_inds_all_fields (filtered_data.ControlWTPre, bad_inds);

            bad_inds = find(filtered_data.ControlWTPost.DirectionNacelle >= edges(ind) ...
                              && filtered_data.ControlWTPost.DirectionNacelle >= edges(ind+1) );

            filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, bad_inds);

            bad_inds = find(filtered_data.TestWTPre.DirectionNacelle >= edges(ind) ...
                              && filtered_data.TestWTPre.DirectionNacelle >= edges(ind+1) );

            filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, bad_inds);

            bad_inds = find(filtered_data.TestWTPost.DirectionNacelle >= edges(ind) ...
                              && filtered_data.TestWTPost.DirectionNacelle >= edges(ind+1) );

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

    [N_samples_ControlWTPre, power_bin_edges] = ...
        histcounts( filtered_data.ControlWTPre.PowerActive, power_bin_edges );

    N_samples_TestWTPre = histcounts(filtered_data.TestWTPre.DirectionNacelle, power_bin_edges);

    % Find power ranges where number of samples fall below a minimum threshold of samples
    % keep only data with these power ranges from all four data sets
    for ind = 1:numel(edges)-1

        if good_directions(ind) == false

            bad_inds = find(filtered_data.ControlWTPre.PowerActive >= edges(ind) ...
                              && filtered_data.ControlWTPre.PowerActive >= edges(ind+1) );

            filtered_data.ControlWTPre = strip_data_bad_inds_all_fields (filtered_data.ControlWTPre, bad_inds);

            bad_inds = find(filtered_data.ControlWTPost.PowerActive >= edges(ind) ...
                              && filtered_data.ControlWTPost.PowerActive >= edges(ind+1) );

            filtered_data.ControlWTPost = strip_data_bad_inds_all_fields (filtered_data.ControlWTPost, bad_inds);

            bad_inds = find(filtered_data.TestWTPre.PowerActive >= edges(ind) ...
                              && filtered_data.TestWTPre.PowerActive >= edges(ind+1) );

            filtered_data.TestWTPre = strip_data_bad_inds_all_fields (filtered_data.TestWTPre, bad_inds);

            bad_inds = find(filtered_data.TestWTPost.PowerActive >= edges(ind) ...
                              && filtered_data.TestWTPost.PowerActive >= edges(ind+1) );

            filtered_data.TestWTPost = strip_data_bad_inds_all_fields (filtered_data.TestWTPost, bad_inds);

        end

    end

    % finally syncronize the time series?


end


function data = leave_data_good_inds_all_fields (turbine_data, good_inds)
% strips data not reported as good from all fields of a structure

    data_fieldnames = fieldnames (turbine_data);

    for data_field_name = data_fieldnames'

        turbine_data.(data_field_name) = turbine_data.(data_field_name)(good_inds);

    end

end

function data = strip_data_bad_inds_all_fields (turbine_data, bad_inds)
% strips data reported as bad from all fields of a structure

    data_fieldnames = fieldnames (turbine_data);

    for data_field_name = data_fieldnames'

        turbine_data.(data_field_name)(bad_inds) = [];

    end

end



