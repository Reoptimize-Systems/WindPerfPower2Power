
% Northing by Mathieu Kervyn

% Initially developed for Power-to-Power, but as the Northing code grows it makes sense to separate it. 

clc

%% Data selection (internal function used to protect sensitive IP)

clear metadata

% Select Wind Farm

% SELECT_DATA = 'WF0';
% SELECT_DATA = 'WF1';
% SELECT_DATA = 'WF2';
% SELECT_DATA = 'WF3';
SELECT_DATA = 'WF4';

folder_data_linking = fullfile ( ...
    reos_shared_nextcloud_dir(), ...
    'Projects', ...
    'INTERNAL--Power_to_Power_Comparison', ...
    'MATLAB_code' ...
    );

addpath(folder_data_linking)

local_data_folder = uigetdir('', 'Choose local folder for data checkout.');

row_set = 13; % see inside function for more information. not applicable to all WFs
metadata = FCN_P2P_init(SELECT_DATA, 'row_set', row_set); 

clear Prev_calculated__Average_error_sum
Combinations = [];
IDX = 0;

% FOR LOOPING. Select n, which determines which turbine pairs of "row_set" is being investigated
for n = 1:50 %[1 16 21 22 35]      %[16 21 22 35]%1:50%1:length(metadata.All_combinations)
    %% Load data (internal function used to protect sensitive IP)
    
        % close all
    
    IDX = IDX + 1;
    % n and IDX required for WF4
    
    [data, base_kW, ControlWT_S_No, TestWT_S_No] = windp2p_load_test_data( ...
        SELECT_DATA, ...
        'n', n, ...
        'IDX', IDX, ...
        'Metadata', metadata, ...
        'LocalDataDirectory', local_data_folder ...
        );
    
    Combinations{IDX, 1} = ControlWT_S_No;
    Combinations{IDX, 2} = TestWT_S_No;
    
    %% Plot input data
    
    % Finding values that are sampled at the same time for both turbines
    [data.TestWTPre.Time, data.TestWTPre.idx] = intersect(data.TestWTPre.Time, data.ControlWTPre.Time);
    [data.ControlWTPre.Time, data.ControlWTPre.idx] = intersect(data.ControlWTPre.Time, data.TestWTPre.Time);
    
    % Extract same indexed variables for remaining datasets
    data.ControlWTPre.OmegaRotor = data.ControlWTPre.OmegaRotor(data.ControlWTPre.idx);
    data.ControlWTPre.RPM = data.ControlWTPre.RPM(data.ControlWTPre.idx);
    data.ControlWTPre.PowerActive = data.ControlWTPre.PowerActive(data.ControlWTPre.idx);
    data.ControlWTPre.TemperatureExternal = data.ControlWTPre.TemperatureExternal(data.ControlWTPre.idx);
    data.ControlWTPre.PitchAngleA = data.ControlWTPre.PitchAngleA(data.ControlWTPre.idx);
    data.ControlWTPre.PitchAngleB = data.ControlWTPre.PitchAngleB(data.ControlWTPre.idx);
    data.ControlWTPre.PitchAngleC = data.ControlWTPre.PitchAngleC(data.ControlWTPre.idx);
    data.ControlWTPre.DirectionNacelle = data.ControlWTPre.DirectionNacelle(data.ControlWTPre.idx);
    data.ControlWTPre.WindSpeed = data.ControlWTPre.WindSpeed(data.ControlWTPre.idx);
    data.ControlWTPre.WindDirection = data.ControlWTPre.WindDirection(data.ControlWTPre.idx);
    
    % same again for TestWTpre
    data.TestWTPre.OmegaRotor = data.TestWTPre.OmegaRotor(data.TestWTPre.idx);
    data.TestWTPre.RPM = data.TestWTPre.RPM(data.TestWTPre.idx);
    data.TestWTPre.PowerActive = data.TestWTPre.PowerActive(data.TestWTPre.idx);
    data.TestWTPre.TemperatureExternal = data.TestWTPre.TemperatureExternal(data.TestWTPre.idx);
    data.TestWTPre.PitchAngleA = data.TestWTPre.PitchAngleA(data.TestWTPre.idx);
    data.TestWTPre.PitchAngleB = data.TestWTPre.PitchAngleB(data.TestWTPre.idx);
    data.TestWTPre.PitchAngleC = data.TestWTPre.PitchAngleC(data.TestWTPre.idx);
    data.TestWTPre.DirectionNacelle = data.TestWTPre.DirectionNacelle(data.TestWTPre.idx);
    data.TestWTPre.WindSpeed = data.TestWTPre.WindSpeed(data.TestWTPre.idx);
    data.TestWTPre.WindDirection = data.TestWTPre.WindDirection(data.TestWTPre.idx);
    
    % Get date time
    DateTimeTestWTPre = datetime(1970, 1, 1, 0, 0, data.TestWTPre.Time);
    DateTimeTestWTPost = datetime(1970, 1, 1, 0, 0, data.TestWTPost.Time);
    DateTimeControlWTPre = datetime(1970, 1, 1, 0, 0, data.ControlWTPre.Time);
    DateTimeControlWTPost = datetime(1970, 1, 1, 0, 0, data.ControlWTPost.Time);
    
    %% Run sync and filter function
    
    % clc
    
    % Set out parameters for filtering
    % 1) Power
    Max_power = max([ ...
        max(data.ControlWTPre.PowerActive), ...
        max(data.ControlWTPost.PowerActive), ...
        max(data.TestWTPre.PowerActive), ...
        max(data.TestWTPost.PowerActive) ...
        ]);
    
    % 2) Set out ata Gap Infill Threshold
    Datagap_inFill = 3;
    Mean_timestep = mean(diff(data.ControlWTPre.Time));
    
    % 3) Set out lower threshold of RPM
    lower_threshold_rpm_per_unit = 0.1; 
    Max_gen_rpm = max([ ...
        max(data.ControlWTPre.RPM) max(data.ControlWTPost.RPM), ...
        max(data.TestWTPre.RPM) max(data.TestWTPost.RPM) ...
        ]);
    
    % 4) Set out nacelle direction binning
    degree_separation_per_bin = 20;%5;% degrees
    No_threshold_direction = 360 / degree_separation_per_bin + 1;
    
    No_bins = 15;%50;
    P_per_bin = Max_power / No_bins;
    
    switch SELECT_DATA

        case 'WF0'

            filtered_data = windp2p.syncAndFilterData(data, ...
                'WindDirectionNumSamplesThresh', 20, ...
                'PowerRangeThreshBinSize', 500000);

        case 'WF1'

            filtered_data = windp2p.syncAndFilterData(data, ...
                'WindDirectionNumSamplesThresh', 50,...
                'WindDirectionThreshNBins', No_threshold_direction,...
                'PowerRangeThreshBinSize', P_per_bin,...
                'SyncronisedTimeStepSize', Mean_timestep,...
                'DataGapInfillThreshold', Mean_timestep*Datagap_inFill,...
                'OperationalRPMThreshold', lower_threshold_rpm_per_unit * Max_gen_rpm ...
                );

        case 'WF3'

            filtered_data = windp2p.syncAndFilterData(data, ...
                'WindDirectionNumSamplesThresh', 50,...
                'WindDirectionThreshNBins', No_threshold_direction,...
                'PowerRangeThreshBinSize', P_per_bin,...
                'SyncronisedTimeStepSize', Mean_timestep,...
                'DataGapInfillThreshold', Mean_timestep*Datagap_inFill,...
                'OperationalRPMThreshold', lower_threshold_rpm_per_unit * Max_gen_rpm ...
                );

        case 'WF4'

            filtered_data = windp2p.syncAndFilterData(data, ...
                'WindDirectionNumSamplesThresh', 1,...
                'WindDirectionThreshNBins', No_threshold_direction,...
                'PowerRangeThreshBinSize', P_per_bin,...
                'SyncronisedTimeStepSize', Mean_timestep,...
                'DataGapInfillThreshold', Mean_timestep*Datagap_inFill,...
                'OperationalRPMThreshold', lower_threshold_rpm_per_unit * Max_gen_rpm, ...
                'WindDirectionNumSamplesThresh', 0 ...
                );

        otherwise

            error('Unrecognised value for data selction code');

    end
    
    %% Aligning the indexing of the "filtered" data for both WTs
    
    % Finding values that are sampled at the same time for both turbines
    [filtered_data_new.TestWTPre.Time, filtered_data_new.TestWTPre.idx] = ...
        intersect(filtered_data.TestWTPre.Time, filtered_data.ControlWTPre.Time);
    
    [filtered_data_new.ControlWTPre.Time, filtered_data_new.ControlWTPre.idx] = ...
        intersect(filtered_data.ControlWTPre.Time, filtered_data.TestWTPre.Time);
    
    % Extract same indexed variables for remaining datasets
    filtered_data_new.ControlWTPre.OmegaRotor = filtered_data.ControlWTPre.OmegaRotor(filtered_data_new.ControlWTPre.idx);
    filtered_data_new.ControlWTPre.RPM = filtered_data.ControlWTPre.RPM(filtered_data_new.ControlWTPre.idx);
    filtered_data_new.ControlWTPre.PowerActive = filtered_data.ControlWTPre.PowerActive(filtered_data_new.ControlWTPre.idx);
    filtered_data_new.ControlWTPre.TemperatureExternal = filtered_data.ControlWTPre.TemperatureExternal(filtered_data_new.ControlWTPre.idx);
    filtered_data_new.ControlWTPre.PitchAngleA = filtered_data.ControlWTPre.PitchAngleA(filtered_data_new.ControlWTPre.idx);
    filtered_data_new.ControlWTPre.PitchAngleB = filtered_data.ControlWTPre.PitchAngleB(filtered_data_new.ControlWTPre.idx);
    filtered_data_new.ControlWTPre.PitchAngleC = filtered_data.ControlWTPre.PitchAngleC(filtered_data_new.ControlWTPre.idx);
    filtered_data_new.ControlWTPre.DirectionNacelle = filtered_data.ControlWTPre.DirectionNacelle(filtered_data_new.ControlWTPre.idx);
    filtered_data_new.ControlWTPre.WindSpeed = filtered_data.ControlWTPre.WindSpeed(filtered_data_new.ControlWTPre.idx);
    filtered_data_new.ControlWTPre.WindDirection = filtered_data.ControlWTPre.WindDirection(filtered_data_new.ControlWTPre.idx);

    % same again for TestWTpre
    filtered_data_new.TestWTPre.OmegaRotor = filtered_data.TestWTPre.OmegaRotor(filtered_data_new.TestWTPre.idx);
    filtered_data_new.TestWTPre.RPM = filtered_data.TestWTPre.RPM(filtered_data_new.TestWTPre.idx);
    filtered_data_new.TestWTPre.PowerActive = filtered_data.TestWTPre.PowerActive(filtered_data_new.TestWTPre.idx);
    filtered_data_new.TestWTPre.TemperatureExternal = filtered_data.TestWTPre.TemperatureExternal(filtered_data_new.TestWTPre.idx);
    filtered_data_new.TestWTPre.PitchAngleA = filtered_data.TestWTPre.PitchAngleA(filtered_data_new.TestWTPre.idx);
    filtered_data_new.TestWTPre.PitchAngleB = filtered_data.TestWTPre.PitchAngleB(filtered_data_new.TestWTPre.idx);
    filtered_data_new.TestWTPre.PitchAngleC = filtered_data.TestWTPre.PitchAngleC(filtered_data_new.TestWTPre.idx);
    filtered_data_new.TestWTPre.DirectionNacelle = filtered_data.TestWTPre.DirectionNacelle(filtered_data_new.TestWTPre.idx);
    filtered_data_new.TestWTPre.WindSpeed = filtered_data.TestWTPre.WindSpeed(filtered_data_new.TestWTPre.idx);
    filtered_data_new.TestWTPre.WindDirection = filtered_data.TestWTPre.WindDirection(filtered_data_new.TestWTPre.idx);
    
    DateTimeTestWTPreNew = datetime(1970, 1, 1, 0, 0, filtered_data_new.TestWTPre.Time);
    DateTimeControlWTPreNew = datetime(1970, 1, 1, 0, 0, filtered_data_new.ControlWTPre.Time);
    
    DateTimeTestWTPreNew(1);
    DateTimeControlWTPreNew(1);
    DateTimeTestWTPreNew(end);
    DateTimeControlWTPreNew(end);
    
    %% Make new histogram figure 
    
    degree_sep_per_bin = 2;
    range              = 360;
    
    % figure(1)
    % ax1 = subplot(1, 2, 1);
    % histogram(filtered_data_new.TestWTPre.DirectionNacelle , [0:degree_sep_per_bin:range])
    % grid on
    % grid minor
    % xlabel 'Nacelle Position [{\circ}]'
    % ylabel 'Count'
    % title(sprintf('Turbine A (S%d)', TestWT_S_No)) % sgtitle 'Nacelle Position between two WTs'
    % ax2 = subplot(1, 2, 2);
    % histogram(filtered_data_new.ControlWTPre.DirectionNacelle , [0:degree_sep_per_bin:range])
    % grid on
    % grid minor
    % xlabel 'Nacelle Position [{\circ}]'
    % ylabel 'Count'
    % % ylim([0 3500])
    % title(sprintf('Turbine B (S%d)', ControlWT_S_No)) % sgtitle 'Nacelle Position between two WTs'
    % sgtitle(sprintf('Uncorrected Nacelle Position Turbine A (S%d) and Turbine B (S%d)', TestWT_S_No, ControlWT_S_No)) 
    % linkaxes([ax1 ax2],'x')
    % xlim([0 360])
    % % 
    % x0 = 1700;
    % y0 = -300;
    % Width = 900;
    % Height = 400;
    % % set(gcf,'position',[x0, y0, Width, Height])
    
    % figure(11)
    % histogram(filtered_data_new.TestWTPre.DirectionNacelle , [0:degree_sep_per_bin:range])
    % grid on
    % grid minor
    % xlabel 'Nacelle Position [{\circ}]'
    % ylabel 'Count'
    % % title(sprintf('Turbine A (S%d)', TestWT_S_No)) % sgtitle 'Nacelle Position between two WTs'
    % % 
    % x0 = 1700;
    % y0 = -300;
    % Width = 400;
    % Height = 400;
    % set(gcf,'position',[x0, y0, Width, Height])
    
    
    %% Try to track **when** slip occurs [very much for WTs S22, S28, S29 and S42]
    
    clear Nacelle_pos_TestWTPre_split_wrap Nacelle_pos_TestWTPre_split_wrap
    
    % % % Averaging of wind direction. Has to be done in vector decomposition (Borrowed from JP) 
    
    % 1.- Convert to sin and cosine. direction (in degress)
    u_TestWT_x = cosd(filtered_data_new.TestWTPre.DirectionNacelle); 
    u_TestWT_y = sind(filtered_data_new.TestWTPre.DirectionNacelle);
    u_ControlWT_x = cosd(filtered_data_new.ControlWTPre.DirectionNacelle); 
    u_ControlWT_y = sind(filtered_data_new.ControlWTPre.DirectionNacelle);

    % 2.- Data Averaging. 
    u_TestWT_x_sliding_window = mean(buffer(u_TestWT_x, 1000, 999)); % buffer requires signal processing toolbox
    u_TestWT_y_sliding_window = mean(buffer(u_TestWT_y, 1000, 999));
    u_ControlWT_x_sliding_window = mean(buffer(u_ControlWT_x, 1000, 999));
    u_ControlWT_y_sliding_window = mean(buffer(u_ControlWT_y, 1000, 999));

    % 3.-Convert to a unique angle
    New_Direction_TestWT = 180 / pi * atan2(u_TestWT_y_sliding_window, u_TestWT_x_sliding_window);
    New_Direction_ControlWT = 180 / pi * atan2(u_ControlWT_y_sliding_window, u_ControlWT_x_sliding_window);

    % 4.-Change negative angles
    idx = find(New_Direction_TestWT<0);
    New_Direction_TestWT(idx) = New_Direction_TestWT(idx) + 360;
    idx = find(New_Direction_ControlWT<0);
    New_Direction_ControlWT(idx) = New_Direction_ControlWT(idx) + 360;
    
    % % % Average error new
    Average_error_sum_new = (New_Direction_TestWT - New_Direction_ControlWT);
    Average_error_sum_new(isnan(Average_error_sum_new)) = [];
    Average_error_sum_new = mean(Average_error_sum_new);
    
    % figure(7)
    % ax1 = subplot(3, 1, 1);
    % plot(DateTimeTestWTPreNew , (filtered_data_new.TestWTPre.DirectionNacelle),'.')
    % hold on
    % plot(DateTimeControlWTPreNew , (filtered_data_new.ControlWTPre.DirectionNacelle),'.')
    % hold off
    % grid on
    % grid minor
    % xlabel 'Date Time'
    % ylabel 'Instantaneous Nacelle Position [\circ]'
    % title(sprintf('Nacelle Position for Turbine A (S%d) and Turbine B (S%d)', TestWT_S_No, ControlWT_S_No)) % sgtitle 'Nacelle Position between two WTs'
    % legend 'Turbine A' 'Turbine B'
    % %
    % ax2 = subplot(3, 1, 2);
    % plot(DateTimeTestWTPreNew, New_Direction_TestWT,'.')
    % hold on
    % plot(DateTimeControlWTPreNew, New_Direction_ControlWT,'.')
    % hold off
    % grid on
    % grid minor
    % xlim([DateTimeTestWTPreNew(1) DateTimeTestWTPreNew(end)])
    % xlabel 'DateTime'
    % ylabel 'Nacelle Position [\circ]'
    % sgtitle(sprintf('Sliding Mean Nacelle Position for Turbine A (S%d) and Turbine B (S%d)', TestWT_S_No, ControlWT_S_No)) % sgtitle 'Nacelle Position between two WTs'
    % %
    % ax3 = subplot(3, 1, 3);
    % plot(DateTimeTestWTPreNew , (New_Direction_TestWT - New_Direction_ControlWT),'.')
    % grid on
    % grid minor
    % xlabel 'Date Time'
    % ylabel 'Mean relative Yaw Error [\circ]'
    % linkaxes([ax1 ax2 ax3],'x')
    
    
    hfig = figure();
    hax = axes(hfig);

    plot(hax, DateTimeTestWTPreNew, New_Direction_TestWT,'.');
    hold on
    plot(hax, DateTimeControlWTPreNew, New_Direction_ControlWT,'.');
    hold off
    grid on
    grid minor
    xlim([DateTimeTestWTPreNew(1) DateTimeTestWTPreNew(end)]);
    xlabel('DateTime');
    ylabel('Nacelle Position [\circ]');
    % % % sgtitle(sprintf('Sliding Window Average Nacelle Position for Turbine (S%d) and Turbine (S%d)', TestWT_S_No, ControlWT_S_No)) % sgtitle 'Nacelle Position between two WTs'
    Legend{1} = ['Turbine S', num2str(TestWT_S_No)];
    Legend{2} = ['Turbine S', num2str(ControlWT_S_No)];
    legend(Legend)
    % % % Figure sizing
    x0 = 2300;
    y0 = 300;
    Width = 1400;
    Height = 400;
    set(gcf, 'position', [x0, y0, Width, Height])
    
    
    %%  Northing Average offset between two turbines
    
    % clear Average_error Average_error_sum Column_1_complex Column_2_complex Table_NacDir_dot_product 
    
    degree_separation_per_bin = 4;% degrees
    No_threshold_direction = 360/degree_separation_per_bin + 1;
    nacelle_direction_edges = linspace(0, 360, No_threshold_direction);
    
    % Part 1: Correcting Nacelle Direction Error
    
    % Make a table where each column is the
    % sequencial nacelle direction of each turbine. Then sort for one of the
    % turbines. Then compare and calculate error
    
    NacDir_column1_TestWTPre = filtered_data_new.TestWTPre.DirectionNacelle';
    NacDir_column2_ControlWTPre = filtered_data_new.ControlWTPre.DirectionNacelle';
    Table_NacDir = table(NacDir_column1_TestWTPre, NacDir_column2_ControlWTPre);
    
    Table_NacDir = sortrows(Table_NacDir,'NacDir_column2_ControlWTPre');
    
    % % % Original average error - PROBLEMATIC AS DOESN'T ACCOUNT FOR WRAP
    % Average_error = wrapTo180(Table_NacDir.NacDir_column1_TestWTPre - Table_NacDir.NacDir_column2_ControlWTPre);
    % Average_error(isnan(Average_error))=[];
    % Average_error_sum = sum(Average_error)/length(Table_NacDir.NacDir_column2_ControlWTPre);
    
    % % % New Average_error and Average_error_sum - PROBLEMATIC AS DOESN'T % ACCOUNT SIGN
    % Column_1_complex = cosd(Table_NacDir.NacDir_column1_TestWTPre)+i*sind(Table_NacDir.NacDir_column1_TestWTPre);
    % Column_2_complex = cosd(Table_NacDir.NacDir_column2_ControlWTPre)+i*sind(Table_NacDir.NacDir_column2_ControlWTPre);
    % Table_NacDir_dot_product = real(Column_1_complex).*real(Column_2_complex)+imag(Column_1_complex).*imag(Column_2_complex);
    % Average_error = acosd(Table_NacDir_dot_product);
    % Average_error(isnan(Average_error))=[];
    % Average_error_sum = sum(Average_error)/length(Table_NacDir.NacDir_column2_ControlWTPre);
    
    % The best average error is the one obtained from the sliding window
    Average_error_sum = Average_error_sum_new;
    
    % % % New shifted column 1 for plotting
    New_shifted_NacDir_column1 = wrapTo360(Table_NacDir.NacDir_column1_TestWTPre - Average_error_sum);
    
    % figure(2)
    % % ax1 = subplot(1, 2, 1);
    % plot(Table_NacDir.NacDir_column1_TestWTPre,'.')
    % hold on
    % plot(New_shifted_NacDir_column1,'.')
    % plot(Table_NacDir.NacDir_column2_ControlWTPre,'.')
    % txt = ['mean(Error): ' num2str(round(Average_error_sum*100)/100) '{\circ}'];
    % if Average_error_sum > 50
    % text(5000, (0.5*(Table_NacDir.NacDir_column1_TestWTPre(5000)+Table_NacDir.NacDir_column2_ControlWTPre(5000))),txt)
    % else
    %     text(5000, 80, txt)
    % end
    % hold off
    % grid on
    % grid minor
    % legend 'Turbine A' 'Turbine A - mean(Error)' 'Turbine B' 'location' 'northoutside' 'Orientation' 'horizontal'
    % xlabel 'Sample'
    % ylabel 'Nacelle Position [{\circ}]'
    % xlim([0 length(Table_NacDir.NacDir_column1_TestWTPre)])
    % ylim([0 360])
    % % ax2 = subplot(1, 2, 2);
    % % % plot(Average_error,'.','Color',[0.4940 0.1840 0.5560])
    % % FCN_plot_heat_scatter([1:length(Average_error)],Average_error, 130)
    % % hold on 
    % % plot([1 length(Average_error)],[Average_error_sum Average_error_sum],':',LineWidth = 2, Color = [0.4660 0.6740 0.1880])
    % % txt = ['mean(Error): ' num2str(round(Average_error_sum*100)/100) '{\circ}'];
    % % text(1000, (Average_error_sum + 50*sign(Average_error_sum_new)),txt)
    % % hold off 
    % % box on
    % % % ylim([-60 60])
    % % legend 'Error = Turbine A - Turbine B' 'mean(Error)' 'location' 'northoutside' 'Orientation' 'horizontal'
    % % grid on
    % % grid minor
    % % xlabel 'Sample'
    % % ylabel '\DeltaPosition = Error [{\circ}]'
    % % xlim([0 length(Average_error)])
    % % ylim([min((Average_error_sum - 80),0) 180])
    % sgtitle(sprintf('Nacelle Position for Turbine A (S%d) and Turbine B (S%d)', TestWT_S_No, ControlWT_S_No)) % sgtitle 'Nacelle Position between two WTs'
    % % % 
    % % % x0 = 1550;
    % % % y0 = 300;
    % % % Width = 900;
    % % % Height = 400;
    % % % % set(gcf,'position',[x0, y0, Width, Height])
    
    filtered_data_new.ControlWTPre.DirectionNacelleCorrected = wrapTo360(filtered_data_new.ControlWTPre.DirectionNacelle + Average_error_sum);
    
    %% Part 2: Make bins
    
    clear midpoint deviation

    midpoint = 0.5 * ( ...
        (nacelle_direction_edges(1:(No_threshold_direction - 1))) ...
        + (nacelle_direction_edges(2:(No_threshold_direction))) ...
        );
    
    dev1 = filtered_data_new.TestWTPre.DirectionNacelle;
    dev2 = filtered_data_new.ControlWTPre.DirectionNacelleCorrected;
    
    deviation_raw = wrapTo180(dev1 - dev2);
    
    % figure(3)
    % plot(DateTimeTestWTPreNew, deviation_raw,'.')
    % ylabel 'Deviation in nacelle direction between WTs'
    % xlabel DateTime
    % grid minor
    
    clear Pow_binned_ControlWTpre Pow_binned_TestWTpre U_binned_ControlWTpre U_binned_TestWTpre idx_ControlWTPre_Dir idx_TestWTPre_Dir
    
    for k = 1:(length(nacelle_direction_edges) - 1)

        idx_ControlWTPre_Dir{k} = find( ...
            (filtered_data_new.ControlWTPre.DirectionNacelleCorrected >= nacelle_direction_edges(k)) ...
            & (filtered_data_new.ControlWTPre.DirectionNacelleCorrected <= nacelle_direction_edges(k + 1)) ...
            );

        idx_TestWTPre_Dir{k} = find( ...
            (filtered_data_new.TestWTPre.DirectionNacelle >= nacelle_direction_edges(k)) ...
            & (filtered_data_new.TestWTPre.DirectionNacelle <= nacelle_direction_edges(k + 1)) ...
            );
    
        Pow_binned_ControlWTpre(k) = mean(filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_Dir{k}));
        Pow_binned_TestWTpre(k) = mean(filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_Dir{k}));
    
        U_binned_ControlWTpre(k) = mean(filtered_data_new.ControlWTPre.WindSpeed(idx_ControlWTPre_Dir{k}));
        U_binned_TestWTpre(k) = mean(filtered_data_new.TestWTPre.WindSpeed(idx_TestWTPre_Dir{k}));
    
        deviation(k) = mean(deviation_raw(idx_TestWTPre_Dir{k}));
    
        Mean_NacDir_ControlWTpre(k) = mean(filtered_data_new.ControlWTPre.DirectionNacelleCorrected(idx_ControlWTPre_Dir{k}));
        Mean_NacDir_TestWTpre(k) = mean(filtered_data_new.TestWTPre.DirectionNacelle(idx_TestWTPre_Dir{k}));
    
        Deviation_bins(k) = Mean_NacDir_TestWTpre(k)-Mean_NacDir_ControlWTpre(k);
    
    end
    
    %% Part 3: plot power and wind speed (raw and binned)
    
    % figure(4)
    % ax1 = subplot(1, 2, 1);
    % yyaxis left
    % plot(midpoint, Pow_binned_ControlWTpre./Pow_binned_TestWTpre,'-sq','LineWidth',1.5)
    % ylabel 'P_{Turbine B}/P_{Turbine A}' % 'P_{control}/P_{test}'
    % yyaxis right
    % plot(midpoint, U_binned_ControlWTpre./U_binned_TestWTpre,'-o','LineWidth',1.5)
    % ylabel 'v_{Turbine B}/v_{Turbine A}' % 'v_{control}/v_{test}'
    % grid on
    % grid minor
    % ylim([0 2])
    % xlabel 'Nacelle Position [{\circ}]'
    % xlim([0 360])
    % %
    % ax2 = subplot(1, 2, 2);
    % yyaxis left
    % % plot(filtered_data_new.TestWTPre.DirectionNacelle, filtered_data_new.ControlWTPre.DirectionNacelleCorrected,'.k')
    % % hold on
    % plot(Mean_NacDir_TestWTpre, Mean_NacDir_ControlWTpre,'o-','LineWidth',1.5)
    % % hold off
    % ylim([0 360])
    % ylabel 'Nacelle Position Turbine B [{\circ}]' % 'Nacelle Pos Control WT [{\circ}]'
    % yyaxis right
    % % plot(midpoint, deviation,'-^','LineWidth',2)
    % % hold on
    % plot(midpoint, Deviation_bins,'-sq','LineWidth',1.5)
    % % hold off
    % ylim([-40 40])
    % ylabel 'Nac Position_{Turbine A} - Nac Position_{Turbine B} [{\circ}]'
    % grid on
    % grid minor
    % xlabel 'Nacelle Position Turbine A [{\circ}]' % 'Nacelle Pos Test WT [{\circ}]'
    % xlim([0 360])
    % % sgtitle 'Northing with filtered data'
    % sgtitle(sprintf('Northing of Turbine A (S%d) and Turbine B (S%d)', TestWT_S_No, ControlWT_S_No)) 
    % % % % Figure sizing
    % x0 = 2300;
    % y0 = 300;
    % Width = 900;
    % Height = 400;
    % % set(gcf,'position',[x0, y0, Width, Height])
    
    %% Part 4: Northing plots
    
    % figure(5)
    % subplot(2, 2, 1)
    % plot(midpoint, Pow_binned_TestWTpre,'-^','LineWidth',1.5)
    % hold on
    % plot(midpoint, Pow_binned_ControlWTpre,'-sq','LineWidth',1.5)
    % hold off
    % ylabel 'Power [kW]' 
    % xlabel 'Nacelle Position [{\circ}]'
    % grid on
    % grid minor
    % xlim([0 360])
    % legend 'Turbine A' 'Turbine B' %'location' 'northoutside' 'Orientation' 'horizontal'
    % title 'Binned averages'
    % % ylim([-0.5 14])
    % subplot(2, 2, 3)
    % plot(filtered_data_new.TestWTPre.DirectionNacelle, filtered_data_new.TestWTPre.PowerActive,'.')
    % hold on
    % plot(filtered_data_new.ControlWTPre.DirectionNacelleCorrected, filtered_data_new.ControlWTPre.PowerActive,'.')
    % hold off
    % ylabel 'Power [kW]' 
    % xlabel 'Nacelle Position [{\circ}]'
    % grid on
    % grid minor
    % legend 'Turbine A' 'Turbine B' %'location' 'northoutside' 'Orientation' 'horizontal'
    % xlim([0 360])
    % % sgtitle(sprintf('Power and Wind Speed of Turbine A (S%d) and Turbine B (S%d)', TestWT_S_No, ControlWT_S_No)) 
    % % ylim([-0.5 14])
    % x0 = 2450;
    % y0 = -300;
    % Width = 700;
    % Height = 900;
    % % set(gcf,'position',[x0, y0, Width, Height])
    % % 
    % title 'Whole dataset'
    % subplot(2, 2, 2)
    % plot(midpoint, U_binned_TestWTpre,'-^','LineWidth',1.5)
    % hold on
    % plot(midpoint, U_binned_ControlWTpre,'-sq','LineWidth',1.5)
    % hold off
    % ylabel 'Wind Speed [m/s]' 
    % xlabel 'Nacelle Position [{\circ}]'
    % grid on
    % grid minor
    % xlim([0 360])
    % % legend 'Turbine A' 'Turbine B' %'location' 'northoutside' 'Orientation' 'horizontal'
    % % ylim([-0.5 14])
    % title 'Binned averages'
    % subplot(2, 2, 4)
    % plot(filtered_data_new.TestWTPre.DirectionNacelle, filtered_data_new.TestWTPre.WindSpeed,'.')
    % hold on
    % plot(filtered_data_new.ControlWTPre.DirectionNacelleCorrected, filtered_data_new.ControlWTPre.WindSpeed,'.')
    % hold off
    % ylabel 'Wind Speed [m/s]' 
    % xlabel 'Nacelle Position [{\circ}]'
    % grid on
    % grid minor
    % xlim([0 360])
    % title 'Whole dataset'
    % sgtitle(sprintf('Power of Turbine A (S%d) and Turbine B (S%d)', TestWT_S_No, ControlWT_S_No)) 
    % % ylim([-0.5 14])
    % % % % Figure sizing
    % x0 = 2800;
    % y0 = 300;
    % % Width = 700;
    % Width = 900;
    % Height = 900;
    % % set(gcf,'position',[x0, y0, Width, Height])
    
    %% Density / Heat scatter plots
    
    % figure(6)
    % ax1 = subplot(2, 2, 1);
    % FCN_plot_heat_scatter(filtered_data_new.TestWTPre.DirectionNacelle, filtered_data_new.TestWTPre.PowerActive, 130)
    % ylabel 'Power [kW]' 
    % xlabel 'Nacelle Position [{\circ}]'
    % grid on
    % grid minor
    % title 'Turbine A' 
    % xlim([0 360])
    % ax2 = subplot(2, 2, 2);
    % FCN_plot_heat_scatter(filtered_data_new.ControlWTPre.DirectionNacelleCorrected, filtered_data_new.ControlWTPre.PowerActive, 130)
    % ylabel 'Power [kW]' 
    % xlabel 'Nacelle Position [{\circ}]'
    % grid on
    % grid minor
    % xlim([0 360])
    % title 'Turbine B'
    % %
    % ax3 = subplot(2, 2, 3);
    % FCN_plot_heat_scatter(filtered_data_new.TestWTPre.DirectionNacelle, filtered_data_new.TestWTPre.WindSpeed, 130)
    % ylabel 'Wind Speed [m/s]' 
    % xlabel 'Nacelle Position [{\circ}]'
    % grid on
    % grid minor
    % title 'Turbine A' 
    % xlim([0 360])
    % ax4 = subplot(2, 2, 4);
    % FCN_plot_heat_scatter(filtered_data_new.ControlWTPre.DirectionNacelleCorrected, filtered_data_new.ControlWTPre.WindSpeed, 130)
    % ylabel 'Wind Speed [m/s]' 
    % xlabel 'Nacelle Position [{\circ}]'
    % grid on
    % grid minor
    % xlim([0 360])
    % title 'Turbine B'
    % sgtitle(sprintf('Density plots for Power & Wind Speed of Turbine A (S%d) and Turbine B (S%d)', TestWT_S_No, ControlWT_S_No)) 
    % % ylim([-0.5 14])
    % % % % Figure sizing
    % x0 = 2800;
    % y0 = 300;
    % % Width = 700;
    % Width = 900;
    % Height = 900;
    % % set(gcf,'position',[x0, y0, Width, Height])
    
    %% Uncomment if saving figures (make sure you're in the right folder!)
    
    % % % Saving Figures
    % Fig_Histogram_name = "Sonnedix_Histogram_S"+TestWT_S_No+"_and_S"+ControlWT_S_No+"from_Jan_2023";
    % saveas(figure(1),Fig_Histogram_name,'jpg')
    % saveas(figure(1),Fig_Histogram_name,'fig')
    % 
    % Fig_Error_name = "Sonnedix_NacError_S"+TestWT_S_No+"_and_S"+ControlWT_S_No+"from_Jan_2023";
    % saveas(figure(2),Fig_Error_name,'jpg')
    % saveas(figure(2),Fig_Error_name,'fig')
    % 
    % Fig_Northing_name = "Sonnedix_Northing_S"+TestWT_S_No+"_and_S"+ControlWT_S_No;
    % saveas(figure(4),Fig_Northing_name,'jpg')
    % saveas(figure(4),Fig_Northing_name,'fig')
    % 
    % Fig_Pow_WindSp_name = "Sonnedix_Power_and_Wind_Speed_S"+TestWT_S_No+"_and_S"+ControlWT_S_No;
    % saveas(figure(5),Fig_Pow_WindSp_name,'jpg')
    % saveas(figure(5),Fig_Pow_WindSp_name,'fig')
    % 
    % Fig_Density_name = "Sonnedix_Density_Plots_S"+TestWT_S_No+"_and_S"+ControlWT_S_No;
    % saveas(figure(6),Fig_Density_name,'jpg')
    % saveas(figure(6),Fig_Density_name,'fig')
    % 
    % Fig_Sliding_Mean_name = "Sonnedix_Sliding_Mean_S"+TestWT_S_No+"_and_S"+ControlWT_S_No;
    % saveas(figure(7),Fig_Sliding_Mean_name,'jpg')
    % saveas(figure(7),Fig_Sliding_Mean_name,'fig')
    
    Fig_Sliding_Mean_singular_name = "Sonnedix_Sliding_Mean_singular_S"+TestWT_S_No+"_and_S"+ControlWT_S_No;
    saveas(figure(77),Fig_Sliding_Mean_singular_name,'jpg')
    saveas(figure(77),Fig_Sliding_Mean_singular_name,'fig')
    
    % Fig_Histogram_mono_name = "Sonnedix_Mono_Histogram_S"+TestWT_S_No+"_from_Jan_2023";
    % saveas(figure(11),Fig_Histogram_mono_name,'jpg')
    % saveas(figure(11),Fig_Histogram_mono_name,'fig')
    
    
    
    %% Comparing wind and nacelle error... (only works if wind direction is recorded)
    
    % clc
    
    NacDir_column1_TestWT = filtered_data_new.TestWTPre.DirectionNacelle';
    NacDir_column2_ControlWT = filtered_data_new.ControlWTPre.DirectionNacelle';
    
    WindDir_column1_TestWT = filtered_data_new.TestWTPre.WindDirection';
    WindDir_column2_ControlWT = filtered_data_new.ControlWTPre.WindDirection';
    
    % Comparing Nacelle Direction from WT1 to WT2
    Table = table(NacDir_column1_TestWT, NacDir_column2_ControlWT);
    Table = sortrows(Table,'NacDir_column2_ControlWT');
    Average_error = wrapTo180(wrapTo360(Table.NacDir_column1_TestWT)-wrapTo360(Table.NacDir_column2_ControlWT));
    Average_error(isnan(Average_error))=[];
    Average_difference_in_NacDir_between_TestWT_and_ControlWT = (sum(Average_error)/length(Table.NacDir_column2_ControlWT));
    
    % Comparing Wind Direction from WT1 to WT2
    Table = table(WindDir_column1_TestWT, WindDir_column2_ControlWT);
    Table = sortrows(Table,'WindDir_column2_ControlWT');
    Average_error = wrapTo360(Table.WindDir_column1_TestWT)-wrapTo360(Table.WindDir_column2_ControlWT);
    Average_error(isnan(Average_error))=[];
    Average_difference_in_WindDir_between_TestWT_and_ControlWT = wrapTo180(sum(Average_error)/length(Table.WindDir_column2_ControlWT));
    
    % Comparing Nacelle Direction and Wind Direction for Test WT
    Table = table(NacDir_column1_TestWT, WindDir_column1_TestWT);
    Table = sortrows(Table,'WindDir_column1_TestWT');
    Average_error = wrapTo360(Table.NacDir_column1_TestWT)-wrapTo360(Table.WindDir_column1_TestWT);
    Average_error(isnan(Average_error))=[];
    Average_difference_between_NacPos_and_WindDir_for_TestWT = wrapTo180(sum(Average_error)/length(Table.WindDir_column1_TestWT));
    
    % Comparing Nacelle Direction and Wind Direction for Control WT
    Table = table(NacDir_column2_ControlWT, WindDir_column2_ControlWT);
    Table = sortrows(Table,'WindDir_column2_ControlWT');
    Average_error = wrapTo360(Table.NacDir_column2_ControlWT)-wrapTo360(Table.WindDir_column2_ControlWT);
    Average_error(isnan(Average_error))=[];
    Average_difference_between_NacPos_and_WindDir_for_ControlWT = wrapTo180(sum(Average_error)/length(Table.WindDir_column2_ControlWT));
    
    PlossTestWT = (1 - cos(deg2rad(Average_difference_between_NacPos_and_WindDir_for_TestWT)))*100;
    
    PlossControlWT = (1 - cos(deg2rad(Average_difference_between_NacPos_and_WindDir_for_ControlWT)))*100;
    
    Prev_calculated__Average_error_sum(IDX)=wrapTo180(Average_error_sum);
    
    % sprintf('Turbine A = (S%d), Turbine B = (S%d), loop %d of %d', TestWT_S_No, ControlWT_S_No, IDX, length(metadata.All_combinations))

end

%% Save main details

IDX_side = sqrt(IDX);
% When doing square matrix
% Error_matrix = reshape(Prev_calculated__Average_error_sum, IDX_side, IDX_side);

% When only coparing to one turbine
Error_matrix = Prev_calculated__Average_error_sum';

% save("Error_matrix.mat","Error_matrix","Combinations")

%% Experimenting with nac pos error impact on wake sector management impact

% Outcome: Minimal impact by wake sector management on energy production, even given the offsets caused by nacelle position error. 

% This is bc the sectors are narrow (40deg) and quite far away from the prevailing wind. So even a large yaw error doesn't infringe on most production.

% clc

% sprintf('TestWT = (S%d), ControlWT = (S%d)', TestWT_S_No, ControlWT_S_No)

degree_separation_per_bin = 5;% degrees
No_threshold_direction = 360/degree_separation_per_bin + 1;
nacelle_pos_edges = linspace(0, 360, No_threshold_direction);


clear idx_TestWTPre_Power idx_TestWTPre_NacPos
for k = 1:(length(nacelle_pos_edges)-1)

    idx_TestWTPre_NacPos{k} = find( ...
        (data.TestWTPre.DirectionNacelle >= nacelle_pos_edges(k)) ...
        & (data.TestWTPre.DirectionNacelle<=nacelle_pos_edges(k + 1)) ...
        );
    
    % % % Debugging
    % figure(1100)
    % plot(DateTimeControlWTPre_New(idx_ControlWTPre_NacPos{k}),data.WT1.DirectionNacelle(idx_ControlWTPre_NacPos{k}),'.')
    % grid on
    % str = sprintf('Nacelle Dir bin from %d to %d ', nacelle_pos_edges(k), nacelle_pos_edges(k + 1));
    % title(str)

    % % % also binning by power. ignore for now
    % for n = 1:(length(power_edges)-1)
    % 
    %     idx_ControlWTPre_Power_temp = find((filtered_data_new.TestWTPre.PowerActive(idx_ControlWTPre_NacPos{k})>=power_edges(n)) & (filtered_data_new.TestWTPre.PowerActive(idx_ControlWTPre_NacPos{k})<=power_edges(n + 1)));
    %     idx_ControlWTPre_Power{n, k}=idx_ControlWTPre_NacPos{k}(idx_ControlWTPre_Power_temp);
    % 
    %     if ~isempty(idx_ControlWTPre_Power{n, k})
    %         if length(idx_ControlWTPre_Power{n, k}) < 15 %%%% Used to be 50 before WF4
    %             idx_ControlWTPre_Power{n, k} = [];
    %         end
    %     end
    % 
    %     % % % Debugging
    %     % figure(1200)
    %     % plot(DateTimeControlWTPre_New(idx_ControlWTPre_Power{n, k}),data.WT1.PowerActive(idx_ControlWTPre_Power{n, k}),'.')
    %     % grid on
    %     % str = sprintf('Power bin from %d to %d ', power_edges(n), power_edges(n + 1));
    %     % title(str)
    % 
    % end

end

% figure(10)
% ax1 = subplot(2, 1, 1);
% plot(data.TestWTPre.DirectionNacelle, data.TestWTPre.WindSpeed,'.')
% grid on 
% grid minor
% ylabel 'Wind Speed [m/s]'
% xlabel 'Nac Pos (uncorrected) [\circ]'
% ax2 = subplot(2, 1, 2);
% plot(data.TestWTPre.DirectionNacelle, data.TestWTPre.PowerActive,'.')
% grid on
% grid minor
% ylabel 'Power [kW]'
% xlabel 'Nac Pos (uncorrected) [\circ]'
% linkaxes([ax1 ax2],'x')


