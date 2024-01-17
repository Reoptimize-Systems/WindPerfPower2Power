
% test_windp2p_filterData by Mathieu Kervyn

% clc

%% Data selection (internal function used to protect sensitive IP)

clear data_info

% % % Select Wind Farm

% SELECT_DATA = 'WF0';
% SELECT_DATA = 'WF1';
% SELECT_DATA = 'WF2';
SELECT_DATA = 'WF3';
% SELECT_DATA = 'WF4';

folder_data_linking = fullfile ( ...
    reos_shared_nextcloud_dir(), ...
    'REOS - SHARED', ...
    'Projects', ...
    'INTERNAL--Power_to_Power_Comparison', ...
    'MATLAB_code' ...
    );

addpath(folder_data_linking)

%% Load data (internal function used to protect sensitive IP)

% % % Original P2P data loading - making this into a function now. Delete in a few months when clearly no longer needed. 
% if SELECT_DATA == 'WF0'
% 
%     PlotInputData = 0; % To plot input timeseries data = 1
%     data = windp2p_dummy_data(PlotInputData);
% 
% elseif SELECT_DATA == 'WF1'
% 
%     folder = fullfile(nextcloud_dir(), 'Field - Data', 'wind', 'Cubico');
% 
%     % Select data fields of interest (Column 1 = new names, Column 2 = nc file names)
%     data_mapping = {'Time',                 'TimeStamp'; ...
%                     'OmegaRotor',           'Rotor speed';...
%                     'RPM',                  'Generator RPM'
%                     'PowerActive',          'Power';...
%                     'TemperatureExternal',  'Ambient temperature';...
%                     'PitchAngleA',          'Blade angle (pitch position) A';...
%                     'PitchAngleB',          'Blade angle (pitch position) B';...
%                     'PitchAngleC',          'Blade angle (pitch position) C';...
%                     'DirectionNacelle',     'Nacelle position';...
%                     'WindSpeed',            'Wind speed';...
%                     ...'WindDirection',        'Wind direction';...
%                     'ErrorCode',            'ErrorCode';... % ErrorCode seems to corrolate with dips in power
%                     'WpsStatus',            'WpsStatus';...% WpsStatus seems to corrolate with shut downs
%                     'WTOperationState',     'WTOperationState';% WTOperationState seems to corrolate with dips in power
%                     'ProductionFactor',     'Production Factor';% ProductionFactor is unclear but much more variable
%                    };
% 
%     % Names of all available turbines
%     WTs = string(['Cubico_Middlewick_WTG_1_10min_2022';...
%         'Cubico_Middlewick_WTG_2_10min_2022';...
%         'Cubico_Middlewick_WTG_3_10min_2022';...
%         'Cubico_Middlewick_WTG_4_10min_2022';...
%         'Cubico_Middlewick_WTG_5_10min_2022';...
%         'Cubico_Middlewick_WTG_6_10min_2022';...
%         'Cubico_Middlewick_WTG_7_10min_2022';...
%         'Cubico_Middlewick_WTG_8_10min_2022';...
%         'Cubico_Middlewick_WTG_9_10min_2022']);
% 
%     % Selection of turbine pairs
%     SELECT_Control_WT = WTs(3);
%     SELECT_Test_WT = WTs(6);
% 
%     % Concatonate and separate pre mod and post mod (approx 3/4 of data for pre mod and 1/4 for post mod)
%     [data.ControlWTPre, infoCWTpre] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                               'FilePrefix', SELECT_Control_WT, ...
%                                               'Ext', ".nc", ...
%                                               'Mapping', data_mapping, ...
%                                               'Start', datetime(2022, 02, 08), ...
%                                               'Stop', datetime(2022, 03, 24) ...
%                                             );
% 
%     [data.TestWTPre, infoTWTpre] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                               'FilePrefix', SELECT_Test_WT, ...
%                                               'Ext', ".nc", ...
%                                               'Mapping', data_mapping, ...
%                                               'Start', datetime(2022, 02, 08), ...
%                                               'Stop', datetime(2022, 03, 24) ...
%                                             ); 
% 
%     [data.ControlWTPost, infoCWTpost] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                               'FilePrefix', SELECT_Control_WT, ...
%                                               'Ext', ".nc", ...
%                                               'Mapping', data_mapping, ...
%                                               'Start', datetime(2022, 03, 25), ...
%                                               'Stop', datetime(2022, 04, 06) ...
%                                             );
% 
%     [data.TestWTPost, infoTWTpost] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                               'FilePrefix', SELECT_Test_WT, ...
%                                               'Ext', ".nc", ...
%                                               'Mapping', data_mapping, ...
%                                               'Start', datetime(2022, 03, 25), ...
%                                               'Stop', datetime(2022, 04, 06) ...
%                                             ); 
% 
%     data.ControlWTPre.Time = data.ControlWTPre.Time{1, 1}';
%     data.ControlWTPost.Time = data.ControlWTPost.Time{1, 1}';
%     data.TestWTPre.Time = data.TestWTPre.Time{1, 1}';
%     data.TestWTPost.Time = data.TestWTPost.Time{1, 1}';
% 
%     data.ControlWTPre.OmegaRotor = data.ControlWTPre.OmegaRotor';
%     data.ControlWTPre.RPM = data.ControlWTPre.RPM';
%     data.ControlWTPre.PowerActive = data.ControlWTPre.PowerActive';
%     data.ControlWTPre.TemperatureExternal = data.ControlWTPre.TemperatureExternal';
%     data.ControlWTPre.PitchAngleA = data.ControlWTPre.PitchAngleA';
%     data.ControlWTPre.PitchAngleB = data.ControlWTPre.PitchAngleB';
%     data.ControlWTPre.PitchAngleC = data.ControlWTPre.PitchAngleC';
%     data.ControlWTPre.DirectionNacelle = data.ControlWTPre.DirectionNacelle';
%     data.ControlWTPre.WindSpeed = data.ControlWTPre.WindSpeed';
%     data.ControlWTPre.WindDirection = data.ControlWTPre.DirectionNacelle'; % No actual wind direction...
%     data.ControlWTPre.ErrorCode = data.ControlWTPre.ErrorCode';
%     data.ControlWTPre.WpsStatus = data.ControlWTPre.WpsStatus';
%     data.ControlWTPre.WTOperationState = data.ControlWTPre.WTOperationState';
%     data.ControlWTPre.ProductionFactor = data.ControlWTPre.ProductionFactor';
% 
%     data.ControlWTPost.OmegaRotor = data.ControlWTPost.OmegaRotor';
%     data.ControlWTPost.RPM = data.ControlWTPost.RPM';
%     data.ControlWTPost.PowerActive = data.ControlWTPost.PowerActive';
%     data.ControlWTPost.TemperatureExternal = data.ControlWTPost.TemperatureExternal';
%     data.ControlWTPost.PitchAngleA = data.ControlWTPost.PitchAngleA';
%     data.ControlWTPost.PitchAngleB = data.ControlWTPost.PitchAngleB';
%     data.ControlWTPost.PitchAngleC = data.ControlWTPost.PitchAngleC';
%     data.ControlWTPost.DirectionNacelle = data.ControlWTPost.DirectionNacelle';
%     data.ControlWTPost.WindSpeed = data.ControlWTPost.WindSpeed';
%     data.ControlWTPost.WindDirection = data.ControlWTPost.DirectionNacelle';
%     data.ControlWTPost.ErrorCode = data.ControlWTPost.ErrorCode';
%     data.ControlWTPost.WpsStatus = data.ControlWTPost.WpsStatus';
%     data.ControlWTPost.WTOperationState = data.ControlWTPost.WTOperationState';
%     data.ControlWTPost.ProductionFactor = data.ControlWTPost.ProductionFactor';
% 
%     data.TestWTPre.OmegaRotor = data.TestWTPre.OmegaRotor';
%     data.TestWTPre.RPM = data.TestWTPre.RPM';
%     data.TestWTPre.PowerActive = data.TestWTPre.PowerActive';
%     data.TestWTPre.TemperatureExternal = data.TestWTPre.TemperatureExternal';
%     data.TestWTPre.PitchAngleA = data.TestWTPre.PitchAngleA';
%     data.TestWTPre.PitchAngleB = data.TestWTPre.PitchAngleB';
%     data.TestWTPre.PitchAngleC = data.TestWTPre.PitchAngleC';
%     data.TestWTPre.DirectionNacelle = data.TestWTPre.DirectionNacelle';
%     data.TestWTPre.WindSpeed = data.TestWTPre.WindSpeed';
%     data.TestWTPre.WindDirection = data.TestWTPre.DirectionNacelle';
%     data.TestWTPre.ErrorCode = data.TestWTPre.ErrorCode';
%     data.TestWTPre.WpsStatus = data.TestWTPre.WpsStatus';
%     data.TestWTPre.WTOperationState = data.TestWTPre.WTOperationState';
%     data.TestWTPre.ProductionFactor = data.TestWTPre.ProductionFactor';
% 
%     data.TestWTPost.OmegaRotor = data.TestWTPost.OmegaRotor';
%     data.TestWTPost.RPM = data.TestWTPost.RPM';
%     data.TestWTPost.PowerActive = data.TestWTPost.PowerActive';
%     data.TestWTPost.TemperatureExternal = data.TestWTPost.TemperatureExternal';
%     data.TestWTPost.PitchAngleA = data.TestWTPost.PitchAngleA';
%     data.TestWTPost.PitchAngleB = data.TestWTPost.PitchAngleB';
%     data.TestWTPost.PitchAngleC = data.TestWTPost.PitchAngleC';
%     data.TestWTPost.DirectionNacelle = data.TestWTPost.DirectionNacelle';
%     data.TestWTPost.WindSpeed = data.TestWTPost.WindSpeed';
%     data.TestWTPost.WindDirection = data.TestWTPost.DirectionNacelle';
%     data.TestWTPost.ErrorCode = data.TestWTPost.ErrorCode';
%     data.TestWTPost.WpsStatus = data.TestWTPost.WpsStatus';
%     data.TestWTPost.WTOperationState = data.TestWTPost.WTOperationState';
%     data.TestWTPost.ProductionFactor = data.TestWTPost.ProductionFactor';
% 
%     DateTimeControlWTPre = datetime(1970, 1, 1, 0, 0, data.ControlWTPre.Time);
%     DateTimeControlWTPost = datetime(1970, 1, 1, 0, 0, data.ControlWTPost.Time);
% 
% 
%     base_kW = 2300;
% 
% elseif SELECT_DATA == 'WF2'
% 
%     % placeholder
% 
% elseif SELECT_DATA == 'WF3'
% 
%     folder = 'C:\Users\mkervyn\Documents\MATLAB\Ventient_data';
% 
%     % Select data fields of interest (Column 1 = new names, Column 2 = nc file names)
%     data_mapping = {'Time',                 'TimeStamp'; ...
%                     'OmegaRotor',           'Rotor speed';...
%                     'RPM',                  'Generator RPM'
%                     'PowerActive',          'Power';...
%                     'TemperatureExternal',  'Ambient temperature';...
%                     'PitchAngleA',          'Blade angle (pitch position) A';...
%                     'PitchAngleB',          'Blade angle (pitch position) B';...
%                     'PitchAngleC',          'Blade angle (pitch position) C';...
%                     'DirectionNacelle',     'Nacelle position';...
%                     'WindSpeed',            'Wind speed';...
%                     'WindDirection',        'Wind direction';...
%                     ...'ErrorCode',            'ErrorCode';... % ErrorCode seems to corrolate with dips in power
%                     ...'WpsStatus',            'WpsStatus';...% WpsStatus seems to corrolate with shut downs
%                     ...'WTOperationState',     'WTOperationState';% WTOperationState seems to corrolate with dips in power
%                     ... 'ProductionFactor',     'Production Factor';% ProductionFactor is unclear but much more variable
%                     };
% 
%     % Names of all available turbines
%     WTs = string(['Ventient_Lissett - Airfield_WTG_103_30s_';...
%         'Ventient_Lissett - Airfield_WTG_104_30s_';...
%         'Ventient_Lissett - Airfield_WTG_105_30s_';...
%         'Ventient_Lissett - Airfield_WTG_106_30s_';...
%         'Ventient_Lissett - Airfield_WTG_107_30s_';...
%         'Ventient_Lissett - Airfield_WTG_108_30s_';...
%         'Ventient_Lissett - Airfield_WTG_109_30s_';...
%         'Ventient_Lissett - Airfield_WTG_110_30s_';...
%         'Ventient_Lissett - Airfield_WTG_111_30s_';...
%         ]);
% 
%     % Selection of turbine pairs
%     SELECT_Control_WT = WTs(2); % default: WTs(2);
%     SELECT_Test_WT = WTs(4); % default: WTs(4);
% 
%     % Concatonate and separate pre mod and post mod (approx 3/4 of data for pre mod and 1/4 for post mod)
%     [data.ControlWTPre, infoCWTpre] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                               'FilePrefix', SELECT_Control_WT, ...
%                                               'Ext', ".nc", ...
%                                               'Mapping', data_mapping, ...
%                                               'Start', datetime(2023, 06, 23), ...
%                                               'Stop', datetime(2023, 07, 30) ...
%                                             );
% 
%     [data.TestWTPre, infoTWTpre] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                               'FilePrefix', SELECT_Test_WT, ...
%                                               'Ext', ".nc", ...
%                                               'Mapping', data_mapping, ...
%                                               'Start', datetime(2023, 06, 23), ...
%                                               'Stop', datetime(2023, 07, 30) ...
%                                             ); 
% 
%     [data.ControlWTPost, infoCWTpost] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                               'FilePrefix', SELECT_Control_WT, ...
%                                               'Ext', ".nc", ...
%                                               'Mapping', data_mapping, ...
%                                               'Start', datetime(2023, 08, 1), ...
%                                               'Stop', datetime(2023, 08, 30) ...
%                                             );
% 
%     [data.TestWTPost, infoTWTpost] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                               'FilePrefix', SELECT_Test_WT, ...
%                                               'Ext', ".nc", ...
%                                               'Mapping', data_mapping, ...
%                                               'Start', datetime(2023, 08, 1), ...
%                                               'Stop', datetime(2023, 08, 30) ...
%                                             ); 
% 
%     data.ControlWTPre.Time = data.ControlWTPre.Time{1, 1}';
%     data.ControlWTPost.Time = data.ControlWTPost.Time{1, 1}';
%     data.TestWTPre.Time = data.TestWTPre.Time{1, 1}';
%     data.TestWTPost.Time = data.TestWTPost.Time{1, 1}';
% 
%     data.ControlWTPre.OmegaRotor = data.ControlWTPre.OmegaRotor';
%     data.ControlWTPre.RPM = data.ControlWTPre.RPM';
%     data.ControlWTPre.PowerActive = data.ControlWTPre.PowerActive';
%     data.ControlWTPre.TemperatureExternal = data.ControlWTPre.TemperatureExternal';
%     data.ControlWTPre.PitchAngleA = data.ControlWTPre.PitchAngleA';
%     data.ControlWTPre.PitchAngleB = data.ControlWTPre.PitchAngleB';
%     data.ControlWTPre.PitchAngleC = data.ControlWTPre.PitchAngleC';
%     data.ControlWTPre.DirectionNacelle = data.ControlWTPre.DirectionNacelle';
%     data.ControlWTPre.WindSpeed = data.ControlWTPre.WindSpeed';
%     data.ControlWTPre.WindDirection = data.ControlWTPre.WindDirection';
%     % Not that useful data
%     % data.ControlWTPre.ErrorCode = data.ControlWTPre.ErrorCode';
%     % data.ControlWTPre.WpsStatus = data.ControlWTPre.WpsStatus';
%     % data.ControlWTPre.WTOperationState = data.ControlWTPre.WTOperationState';
%     % data.ControlWTPre.ProductionFactor = data.ControlWTPre.ProductionFactor';
% 
%     data.ControlWTPost.OmegaRotor = data.ControlWTPost.OmegaRotor';
%     data.ControlWTPost.RPM = data.ControlWTPost.RPM';
%     data.ControlWTPost.PowerActive = data.ControlWTPost.PowerActive';
%     data.ControlWTPost.TemperatureExternal = data.ControlWTPost.TemperatureExternal';
%     data.ControlWTPost.PitchAngleA = data.ControlWTPost.PitchAngleA';
%     data.ControlWTPost.PitchAngleB = data.ControlWTPost.PitchAngleB';
%     data.ControlWTPost.PitchAngleC = data.ControlWTPost.PitchAngleC';
%     data.ControlWTPost.DirectionNacelle = data.ControlWTPost.DirectionNacelle';
%     data.ControlWTPost.WindSpeed = data.ControlWTPost.WindSpeed';
%     data.ControlWTPost.WindDirection = data.ControlWTPost.WindDirection';
%     % Not that useful data
%     % data.ControlWTPost.ErrorCode = data.ControlWTPost.ErrorCode';
%     % data.ControlWTPost.WpsStatus = data.ControlWTPost.WpsStatus';
%     % data.ControlWTPost.WTOperationState = data.ControlWTPost.WTOperationState';
%     % data.ControlWTPost.ProductionFactor = data.ControlWTPost.ProductionFactor';
% 
%     data.TestWTPre.OmegaRotor = data.TestWTPre.OmegaRotor';
%     data.TestWTPre.RPM = data.TestWTPre.RPM';
%     data.TestWTPre.PowerActive = data.TestWTPre.PowerActive';
%     data.TestWTPre.TemperatureExternal = data.TestWTPre.TemperatureExternal';
%     data.TestWTPre.PitchAngleA = data.TestWTPre.PitchAngleA';
%     data.TestWTPre.PitchAngleB = data.TestWTPre.PitchAngleB';
%     data.TestWTPre.PitchAngleC = data.TestWTPre.PitchAngleC';
%     data.TestWTPre.DirectionNacelle = data.TestWTPre.DirectionNacelle';
%     data.TestWTPre.WindSpeed = data.TestWTPre.WindSpeed';
%     data.TestWTPre.WindDirection = data.TestWTPre.WindDirection';
%     % Not that useful data
%     % data.TestWTPre.ErrorCode = data.TestWTPre.ErrorCode';
%     % data.TestWTPre.WpsStatus = data.TestWTPre.WpsStatus';
%     % data.TestWTPre.WTOperationState = data.TestWTPre.WTOperationState';
%     % data.TestWTPre.ProductionFactor = data.TestWTPre.ProductionFactor';
% 
%     data.TestWTPost.OmegaRotor = data.TestWTPost.OmegaRotor';
%     data.TestWTPost.RPM = data.TestWTPost.RPM';
%     data.TestWTPost.PowerActive = data.TestWTPost.PowerActive';
%     data.TestWTPost.TemperatureExternal = data.TestWTPost.TemperatureExternal';
%     data.TestWTPost.PitchAngleA = data.TestWTPost.PitchAngleA';
%     data.TestWTPost.PitchAngleB = data.TestWTPost.PitchAngleB';
%     data.TestWTPost.PitchAngleC = data.TestWTPost.PitchAngleC';
%     data.TestWTPost.DirectionNacelle = data.TestWTPost.DirectionNacelle';
%     data.TestWTPost.WindSpeed = data.TestWTPost.WindSpeed';
%     data.TestWTPost.WindDirection = data.TestWTPost.WindDirection';
%     % Not that useful data
%     % data.TestWTPost.ErrorCode = data.TestWTPost.ErrorCode';
%     % data.TestWTPost.WpsStatus = data.TestWTPost.WpsStatus';
%     % data.TestWTPost.WTOperationState = data.TestWTPost.WTOperationState';
%     % data.TestWTPost.ProductionFactor = data.TestWTPost.ProductionFactor';
% 
%     DateTimeTestWTPre = datetime(1970, 1, 1, 0, 0, data.TestWTPre.Time);
%     DateTimeTestWTPost = datetime(1970, 1, 1, 0, 0, data.TestWTPost.Time);
%     DateTimeControlWTPre = datetime(1970, 1, 1, 0, 0, data.ControlWTPre.Time);
%     DateTimeControlWTPost = datetime(1970, 1, 1, 0, 0, data.ControlWTPost.Time);
% 
%     base_kW = 2500;
% 
% 
% elseif SELECT_DATA == 'WF4'
% 
%     % Load JP's version of .mat files
%     % folder = 'C:\Users\mkervyn\Nextcloud\REOS - SHARED\Projects\Sonnedix - -El - Arrayan\SCADA\matlab_files'; % Location of data " 'scada_wps_....." data
%     % addpath(folder) 
%     % load('scada_wps_2020_08_sonnedix.mat')
%     % load ('scada_wps_2020_09_sonnedix.mat')
%     % load('scada_wps_2020_12_sonnedix.mat') % much shorter than the rest
%     % load ('scada_wps_2022_01_sonnedix.mat')
%     % load('scada_wps_2022_09_sonnedix.mat')
%     % load('scada_wps_2023_01_sonnedix.mat')
% 
%     % % Location of MK's concatenated data, and load only if you have to
%     if ~exist('tblSCTurbine','var') 
%         addpath('C:\Users\mkervyn\Documents\MATLAB\Sonnedix\Concatenated_data_MK') % Concatenated data in this folder
%         open('tblSCTurbine_part1.mat');
%         tblSCTurbine_part1 = ans.tblSCTurbine_part1;
%         tblSCTurbine_part1.TimeStamp = tblSCTurbine_part1.TimeStamp + datenum(['01/01/2000 00:00:00']);
%         open('tblSCTurbine_part2.mat');
%         tblSCTurbine_part2 = ans.tblSCTurbine_part2;
%         tblSCTurbine_part2.TimeStamp = tblSCTurbine_part2.TimeStamp + datenum(['01/01/2000 00:00:00']);
%         open('tblSCturbineGrid.mat');
%         tblSCTurGrid = ans.tblSCturbineGrid;
%         tblSCTurGrid.TimeStamp = tblSCTurGrid.TimeStamp + datenum(['01/01/2000 00:00:00']);
%         clear ans
%         Zeros_table = array2table([zeros(height(tblSCTurbine_part1),(Width(tblSCTurbine_part2)-Width(tblSCTurbine_part1)))]);
% 
%         allVars = 1:width(Zeros_table);
%         newNames = ["wtc_BoostAct_min" "wtc_BoostAct_max" "wtc_BoostAct_mean" "wtc_BoostAct_stddev" "wtc_ActualWindDirection_min" "wtc_ActualWindDirection_max" "wtc_ActualWindDirection_mean" "wtc_ActualWindDirection_stddev" "wtc_WTOperSt_min" "wtc_WTOperSt_max" "wtc_WTOperSt_endvalue" ];
%         Zeros_table = renamevars(Zeros_table, allVars, newNames);
% 
%         tblSCTurbine = [tblSCTurbine_part1 Zeros_table; tblSCTurbine_part2];%(:,(1:85))]; 
%     end
% 
%     WTs = tblSCTurbine_part2.StationId(1:100);
% 
%     S_no_to_station_ID =  [07 2307284; 08 2307285; 09 2307286; 10 2307287; 11 2307288; 12 2307289; 13 2307290;...
%                            14 2307291; 15 2307292; 16 2307293; 17 2307294; 18 2307295; 19 2307296; 20 2307297;...
%                            21 2307298; 22 2307299; 23 2307300; 25 2307301; 26 2307302; 27 2307303; 28 2307304;...
%                            29 2307305; 30 2307306; 31 2307307; 32 2307308; 33 2307309; 34 2307310; 35 2307311;...
%                            36 2307312; 37 2307313; 38 2307314; 39 2307315; 40 2307316; 41 2307317; 42 2307318;...
%                            43 2307319; 44 2307320; 45 2307321; 46 2307322; 47 2307323; 48 2307324; 49 2307325;...
%                            50 2307326; 51 2307327; 52 2307328; 53 2307329; 54 2307330; 55 2307331; 56 2307332;...
%                            57 2307333];
% 
%     % JP wants to try S07 & S08, S51 & S50, S39 & S38
% 
%     ControlWT_S_No = 51; % turbine B <<<<<<<<<<<<<<<<<<<<<< INPUT HERE               ie 07 = S07
%     TestWT_S_No = 50; % turbine A <<<<<<<<<<<<<<<<<<<<<< INPUT HERE 
% 
%     ControlWT_ID = S_no_to_station_ID((find(S_no_to_station_ID(:,1)==ControlWT_S_No)),2);
%     TestWT_ID = S_no_to_station_ID((find(S_no_to_station_ID(:,1)==TestWT_S_No)),2);
% 
%     % if ControlWT_S_No == 39 & TestWT_S_No == 38
%     %     % SHIFT = -30;
%     % elseif ControlWT_S_No == 38 & TestWT_S_No == 39
%     %     % SHIFT = -30;
%     % else
%     %     SHIFT = 0;
%     % end
% 
% 
%     Initial_datetime = datetime(1970, 1, 1, 0, 0, 0);
% 
%     % filter for selected test and control turbine, and also for date
%     idx_Control_WT_tbl_Turb = find(tblSCTurbine.StationId==ControlWT_ID & datenum(tblSCTurbine.TimeStamp)>datenum(['01/01/1023 00:00:00'])); % the year is stored in a weird way... ie the code is correct but the Timestamp mat files are not
%     idx_Test_WT_tbl_Turb = find(tblSCTurbine.StationId==TestWT_ID & datenum(tblSCTurbine.TimeStamp)>datenum(['01/01/1023 00:00:00']));
%     idx_Control_WT_tbl_TurGrid = find(tblSCTurGrid.StationId==ControlWT_ID & datenum(tblSCTurGrid.TimeStamp)>datenum(['01/01/1023 00:00:00']));
%     idx_Test_WT_tbl_TurGrid = find(tblSCTurGrid.StationId==TestWT_ID & datenum(tblSCTurGrid.TimeStamp)>datenum(['01/01/1023 00:00:00']));
% 
%     % Select only temporally matching variables from both datasets for control turbine
%     [Time_common_control, idx_control_tbl_turbine1, idx_control_tbl_grid1] = intersect(tblSCTurbine.TimeStamp(idx_Control_WT_tbl_Turb),tblSCTurGrid.TimeStamp(idx_Control_WT_tbl_TurGrid));
%     idx_control_tbl_turbine = idx_Control_WT_tbl_Turb(idx_control_tbl_turbine1);
%     idx_control_tbl_grid = idx_Control_WT_tbl_TurGrid(idx_control_tbl_grid1);
% 
%     % Obtain indexes for the tblSCTurbine dataset, pre and post mod, for control turbine
%     idx_control_tbl_turbine_PRE = idx_control_tbl_turbine(1:round(3/4*length(idx_control_tbl_turbine)));
%     idx_control_tbl_turbine_POST = idx_control_tbl_turbine((round(3/4*length(idx_control_tbl_turbine))+1):length(idx_control_tbl_turbine));
% 
%     % Obtain indexes for the tblSCTurGrid dataset, pre and post mod, for control turbine
%     idx_control_tbl_grid_PRE = idx_control_tbl_grid(1:round(3/4*length(idx_control_tbl_grid)));
%     idx_control_tbl_grid_POST = idx_control_tbl_grid((round(3/4*length(idx_control_tbl_grid))+1):length(idx_control_tbl_grid));
% 
%     % Select only temporally matching variables from both datasets for test turbine
%     [Time_common_test, idx_test_tbl_turbine1, idx_test_tbl_grid1] = intersect(tblSCTurbine.TimeStamp(idx_Test_WT_tbl_Turb),tblSCTurGrid.TimeStamp(idx_Test_WT_tbl_TurGrid));
%     idx_test_tbl_turbine = idx_Test_WT_tbl_Turb(idx_test_tbl_turbine1);
%     idx_test_tbl_grid = idx_Test_WT_tbl_TurGrid(idx_test_tbl_grid1);
% 
%     % Obtain indexes for the tblSCTurbine dataset, pre and post mod, for test turbine
%     idx_test_tbl_turbine_PRE = idx_test_tbl_turbine(1:round(3/4*length(idx_test_tbl_turbine)));
%     idx_test_tbl_turbine_POST = idx_test_tbl_turbine((round(3/4*length(idx_test_tbl_turbine))+1):length(idx_test_tbl_turbine));
% 
%     % Obtain indexes for the tblSCTurGrid dataset, pre and post mod, for test turbine
%     idx_test_tbl_grid_PRE = idx_test_tbl_grid(1:round(3/4*length(idx_test_tbl_grid)));
%     idx_test_tbl_grid_POST = idx_test_tbl_grid((round(3/4*length(idx_test_tbl_grid))+1):length(idx_test_tbl_grid));
% 
%     gearbox_ratio = 119;% <<<<<<<<<<<<<<<< obviously not quite correct, but doesn't matter for now
% 
%     data.ControlWTPre.OmegaRotor = tblSCTurbine.wtc_GenRpm_mean(idx_control_tbl_turbine_PRE)'/gearbox_ratio;
%     data.ControlWTPre.RPM = tblSCTurbine.wtc_GenRpm_mean(idx_control_tbl_turbine_PRE)';
%     data.ControlWTPre.PowerActive = tblSCTurGrid.wtc_ActPower_mean(idx_control_tbl_grid_PRE)';
%     data.ControlWTPre.TemperatureExternal = ones(length(idx_control_tbl_turbine_PRE),1)'*20; %%%%%%%%%%% made up value
%     data.ControlWTPre.PitchAngleA = tblSCTurbine.wtc_PitchRef_BladeA_mean(idx_control_tbl_turbine_PRE)';
%     data.ControlWTPre.PitchAngleB = tblSCTurbine.wtc_PitchRef_BladeB_mean(idx_control_tbl_turbine_PRE)';
%     data.ControlWTPre.PitchAngleC = tblSCTurbine.wtc_PitchRef_BladeC_mean(idx_control_tbl_turbine_PRE)';
%     data.ControlWTPre.DirectionNacelle = tblSCTurbine.wtc_NacelPos_mean(idx_control_tbl_turbine_PRE)';
%     data.ControlWTPre.WindDirection = tblSCTurbine.wtc_ActualWindDirection_mean(idx_control_tbl_turbine_PRE)';
%     data.ControlWTPre.WindSpeed = tblSCTurbine.wtc_AcWindSp_mean (idx_control_tbl_turbine_PRE)';
%     data.ControlWTPre.Time = tblSCTurbine.TimeStamp(idx_control_tbl_turbine_PRE)';
%     data.ControlWTPre.Time = seconds(data.ControlWTPre.Time - Initial_datetime);
% 
%     data.ControlWTPost.OmegaRotor = tblSCTurbine.wtc_GenRpm_mean(idx_control_tbl_turbine_POST)'/gearbox_ratio;
%     data.ControlWTPost.RPM = tblSCTurbine.wtc_GenRpm_mean(idx_control_tbl_turbine_POST)';
%     data.ControlWTPost.PowerActive = tblSCTurGrid.wtc_ActPower_mean(idx_control_tbl_grid_POST)';
%     data.ControlWTPost.TemperatureExternal = ones(length(idx_control_tbl_turbine_POST),1)'*20; %%%%%%%%%%% made up value
%     data.ControlWTPost.PitchAngleA = tblSCTurbine.wtc_PitchRef_BladeA_mean(idx_control_tbl_turbine_POST)';
%     data.ControlWTPost.PitchAngleB = tblSCTurbine.wtc_PitchRef_BladeB_mean(idx_control_tbl_turbine_POST)';
%     data.ControlWTPost.PitchAngleC = tblSCTurbine.wtc_PitchRef_BladeC_mean(idx_control_tbl_turbine_POST)';
%     data.ControlWTPost.DirectionNacelle = tblSCTurbine.wtc_NacelPos_mean(idx_control_tbl_turbine_POST)';
%     data.ControlWTPost.WindDirection = tblSCTurbine.wtc_ActualWindDirection_mean(idx_control_tbl_turbine_POST)';
%     data.ControlWTPost.WindSpeed = tblSCTurbine.wtc_AcWindSp_mean(idx_control_tbl_turbine_POST)';
%     data.ControlWTPost.Time = tblSCTurbine.TimeStamp(idx_control_tbl_turbine_POST)';
%     data.ControlWTPost.Time = seconds(data.ControlWTPost.Time - Initial_datetime);
% 
%     data.TestWTPre.OmegaRotor = tblSCTurbine.wtc_GenRpm_mean(idx_test_tbl_turbine_PRE)'/gearbox_ratio;
%     data.TestWTPre.RPM = tblSCTurbine.wtc_GenRpm_mean(idx_test_tbl_turbine_PRE)';
%     data.TestWTPre.PowerActive = tblSCTurGrid.wtc_ActPower_mean(idx_test_tbl_grid_PRE)';
%     data.TestWTPre.TemperatureExternal = ones(length(idx_test_tbl_turbine_PRE),1)'*20; %%%%%%%%%%% made up value
%     data.TestWTPre.PitchAngleA = tblSCTurbine.wtc_PitchRef_BladeA_mean(idx_test_tbl_turbine_PRE)';
%     data.TestWTPre.PitchAngleB = tblSCTurbine.wtc_PitchRef_BladeB_mean(idx_test_tbl_turbine_PRE)';
%     data.TestWTPre.PitchAngleC = tblSCTurbine.wtc_PitchRef_BladeC_mean(idx_test_tbl_turbine_PRE)';
%     data.TestWTPre.DirectionNacelle = tblSCTurbine.wtc_NacelPos_mean(idx_test_tbl_turbine_PRE)';
%     data.TestWTPre.WindDirection = tblSCTurbine.wtc_ActualWindDirection_mean(idx_test_tbl_turbine_PRE)';
%     data.TestWTPre.WindSpeed = tblSCTurbine.wtc_AcWindSp_mean(idx_test_tbl_turbine_PRE)';
%     data.TestWTPre.Time = tblSCTurbine.TimeStamp(idx_test_tbl_turbine_PRE)';
%     data.TestWTPre.Time = seconds(data.TestWTPre.Time - Initial_datetime);
% 
%     data.TestWTPost.OmegaRotor = tblSCTurbine.wtc_GenRpm_mean(idx_test_tbl_turbine_POST)'/gearbox_ratio;
%     data.TestWTPost.RPM = tblSCTurbine.wtc_GenRpm_mean(idx_test_tbl_turbine_POST)';
%     data.TestWTPost.PowerActive = tblSCTurGrid.wtc_ActPower_mean(idx_test_tbl_grid_POST)';
%     data.TestWTPost.TemperatureExternal = ones(length(idx_test_tbl_turbine_POST),1)'*20; %%%%%%%%%%% made up value
%     data.TestWTPost.PitchAngleA = tblSCTurbine.wtc_PitchRef_BladeA_mean(idx_test_tbl_turbine_POST)';
%     data.TestWTPost.PitchAngleB = tblSCTurbine.wtc_PitchRef_BladeB_mean(idx_test_tbl_turbine_POST)';
%     data.TestWTPost.PitchAngleC = tblSCTurbine.wtc_PitchRef_BladeC_mean(idx_test_tbl_turbine_POST)';
%     data.TestWTPost.DirectionNacelle = tblSCTurbine.wtc_NacelPos_mean(idx_test_tbl_turbine_POST)';
%     data.TestWTPost.WindDirection = tblSCTurbine.wtc_ActualWindDirection_mean(idx_test_tbl_turbine_POST)';
%     data.TestWTPost.WindSpeed = tblSCTurbine.wtc_AcWindSp_mean(idx_test_tbl_turbine_POST)';
%     data.TestWTPost.Time = tblSCTurbine.TimeStamp(idx_test_tbl_turbine_POST)';
%     data.TestWTPost.Time = seconds(data.TestWTPost.Time - Initial_datetime);
% 
%     base_kW = 2300;
% 
%     % data.ControlWTPre.DirectionNacelle = wrapTo360(data.ControlWTPre.DirectionNacelle + SHIFT);
%     % data.ControlWTPost.DirectionNacelle = wrapTo360(data.ControlWTPost.DirectionNacelle + SHIFT);
%     % data.TestWTPre.DirectionNacelle = wrapTo360(data.TestWTPre.DirectionNacelle + SHIFT);
%     % data.TestWTPost.DirectionNacelle = wrapTo360(data.TestWTPost.DirectionNacelle + SHIFT);
% 
% 
% else
%     error('Incompatible data selection')
% end

[data, base_kW, ControlWT_S_No, TestWT_S_No] = windp2p_load_test_data(SELECT_DATA);

% Note: ControlWT_S_No and TestWT_S_No useful for WF4.

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
% Not that useful data
% data.ControlWTPre.ErrorCode = data.ControlWTPre.ErrorCode(data.ControlWTPre.idx);
% data.ControlWTPre.WpsStatus = data.ControlWTPre.WpsStatus(data.ControlWTPre.idx);
% data.ControlWTPre.WTOperationState = data.ControlWTPre.WTOperationState(data.ControlWTPre.idx);
% data.ControlWTPre.ProductionFactor = data.ControlWTPre.ProductionFactor(data.ControlWTPre.idx);
data.ControlWTPre.WindDirection = data.ControlWTPre.WindDirection(data.ControlWTPre.idx);
data.ControlWTPre.AirPressure = data.ControlWTPre.AirPressure(data.ControlWTPre.idx);

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
% Not that useful data
% data.TestWTPre.ErrorCode = data.TestWTPre.ErrorCode(data.TestWTPre.idx);
% data.TestWTPre.WpsStatus = data.TestWTPre.WpsStatus(data.TestWTPre.idx);
% data.TestWTPre.WTOperationState = data.TestWTPre.WTOperationState(data.TestWTPre.idx);
% data.TestWTPre.ProductionFactor = data.TestWTPre.ProductionFactor(data.TestWTPre.idx);
data.TestWTPre.WindDirection = data.TestWTPre.WindDirection(data.TestWTPre.idx);
data.TestWTPre.AirPressure = data.TestWTPre.AirPressure(data.TestWTPre.idx);

% Get date time
DateTimeTestWTPre = datetime(1970, 1, 1, 0, 0, data.TestWTPre.Time);
% % % DateTimeTestWTPost = datetime(1970, 1, 1, 0, 0, data.TestWTPost.Time);
DateTimeControlWTPre = datetime(1970, 1, 1, 0, 0,data.ControlWTPre.Time);
% % % DateTimeControlWTPost = datetime(1970, 1, 1, 0, 0, data.ControlWTPost.Time);

% figure(1)
% ax1 = subplot(5, 2, 1);
% plot(DateTimeControlWTPre, data.ControlWTPre.RPM,'*r')
% hold on
% plot(DateTimeTestWTPre, data.TestWTPre.RPM,'ob')
% hold off
% grid on
% legend ControlWTPre TestWTPre 
% ylabel 'RPM'
% title 'LHS: Pre modification of control turbine'
% ax2 = subplot(5, 2, 2);
% plot(DateTimeControlWTPost, data.ControlWTPost.RPM,'+r')
% hold on
% plot(DateTimeTestWTPost, data.TestWTPost.RPM,'sqb')
% hold off
% legend ControlWTPost TestWTPost
% grid on
% title 'RHS: Post modification of control turbine'
% 
% ax3 = subplot(5, 2, 3);
% plot(DateTimeControlWTPre, data.ControlWTPre.PowerActive,'*r')
% hold on
% plot(DateTimeTestWTPre, data.TestWTPre.PowerActive,'ob')
% hold off
% grid on
% ylabel 'Active Power [W]'
% ax4 = subplot(5, 2, 4);
% plot(DateTimeControlWTPost, data.ControlWTPost.PowerActive,'+r')
% hold on
% plot(DateTimeTestWTPost, data.TestWTPost.PowerActive,'sqb')
% hold off
% grid on
% 
% ax5 = subplot(5, 2, 5);
% plot(DateTimeControlWTPre, data.ControlWTPre.TemperatureExternal,'*r')
% hold on
% plot(DateTimeTestWTPre, data.TestWTPre.TemperatureExternal,'ob')
% hold off
% grid on
% ylabel 'Temp Ext [^{\circ}]'
% % ylim([0 15])
% ax6 = subplot(5, 2, 6);
% plot(DateTimeControlWTPost, data.ControlWTPost.TemperatureExternal,'+r')
% hold on
% plot(DateTimeTestWTPost, data.TestWTPost.TemperatureExternal,'sqb')
% hold off
% grid on
% % ylim([0 15])
% 
% ax7 = subplot(5, 2, 7);
% plot(DateTimeControlWTPre, data.ControlWTPre.DirectionNacelle,'*r')
% hold on
% plot(DateTimeTestWTPre, data.TestWTPre.DirectionNacelle,'ob')
% hold off
% grid on
% ylabel 'Dir Nacelle [^{\circ}]'
% ax8 = subplot(5, 2, 8);
% plot(DateTimeControlWTPost, data.ControlWTPost.DirectionNacelle,'+r')
% hold on
% plot(DateTimeTestWTPost, data.TestWTPost.DirectionNacelle,'sqb')
% hold off
% grid on
% 
% ax9 = subplot(5, 2, 9);
% plot(DateTimeControlWTPre, data.ControlWTPre.WindSpeed,'*r')
% hold on
% plot(DateTimeTestWTPre, data.TestWTPre.WindSpeed,'ob')
% hold off
% grid on
% ylabel 'Wind Sp [m/s]'
% ax10 = subplot(5, 2, 10);
% plot(DateTimeControlWTPost, data.ControlWTPost.WindSpeed,'+r')
% hold on
% plot(DateTimeTestWTPost, data.TestWTPost.WindSpeed,'sqb')
% hold off
% grid on
% 
% linkaxes([ax1 ax3 ax5 ax7 ax9],'x')
% linkaxes([ax2 ax4 ax6 ax8 ax10],'x')
% sgtitle 'Comparing Control and Test turbines '

% % % % %% WIND SPEED CORRECTION (Based on air density calculations based on temperature and pressure)

% % % rho = pressure / (R * temperature) ; 5 Where R is the glas constant

R_gas_constant = 287.05; % J/(kgK)

data.ControlWTPre.AirDensity = data.ControlWTPre.AirPressure./(R_gas_constant * data.ControlWTPre.TemperatureExternal);
data.TestWTPre.AirDensity = data.TestWTPre.AirPressure./(R_gas_constant * data.TestWTPre.TemperatureExternal);
data.ControlWTPost.AirDensity = data.ControlWTPost.AirPressure./(R_gas_constant * data.ControlWTPost.TemperatureExternal);
data.TestWTPost.AirDensity = data.TestWTPost.AirPressure./(R_gas_constant * data.TestWTPost.TemperatureExternal);

data.ControlWTPre.WindSpeed = data.ControlWTPre.WindSpeed .* (data.ControlWTPre.AirDensity/1.225).^(1/3);
data.TestWTPre.WindSpeed = data.TestWTPre.WindSpeed .* (data.TestWTPre.AirDensity/1.225).^(1/3);
data.ControlWTPost.WindSpeed = data.ControlWTPost.WindSpeed .* (data.ControlWTPost.AirDensity/1.225).^(1/3);
data.TestWTPost.WindSpeed = data.TestWTPost.WindSpeed .* (data.TestWTPost.AirDensity/1.225).^(1/3);

%% Northing (pre filter, for info)
% 
% degree_separation_per_bin = 4;% degrees
% No_threshold_direction = 360/degree_separation_per_bin + 1;
% nacelle_direction_edges = linspace(0, 360, No_threshold_direction);
% 
% dev1 = data.TestWTPre.DirectionNacelle;
% dev2 = data.ControlWTPre.DirectionNacelle;
% 
% deviation_raw = wrapTo180(dev1 - dev2);
% 
% for k = 1:(length(nacelle_direction_edges)-1)
%     idx_ControlWTPre_WindDir{k}=find((data.ControlWTPre.DirectionNacelle>=nacelle_direction_edges(k)) & (data.ControlWTPre.DirectionNacelle<=nacelle_direction_edges(k + 1)));
%     idx_TestWTPre_WindDir{k}=find((data.TestWTPre.DirectionNacelle>=nacelle_direction_edges(k)) & (data.TestWTPre.DirectionNacelle<=nacelle_direction_edges(k + 1)));
% 
%     Pow_binned_ControlWTpre(k) = mean(data.ControlWTPre.PowerActive(idx_ControlWTPre_WindDir{k}));
%     Pow_binned_TestWTpre(k) = mean(data.TestWTPre.PowerActive(idx_TestWTPre_WindDir{k}));
% 
%     U_binned_ControlWTpre(k) = mean(data.ControlWTPre.WindSpeed(idx_ControlWTPre_WindDir{k}));
%     U_binned_TestWTpre(k) = mean(data.TestWTPre.WindSpeed(idx_TestWTPre_WindDir{k}));
% 
%     deviation(k) = mean(deviation_raw(idx_TestWTPre_WindDir{k}));
% end
% 
% midpoint = 0.5*((nacelle_direction_edges(1:(No_threshold_direction - 1)))+(nacelle_direction_edges(2:(No_threshold_direction))));
% 
% % % % CLEARLY SOME OF THIS MEASUREMENTS MUST BE MADE WITH BINNED DATAPOINTS
% figure(4)
% ax1 = subplot(1, 2, 1);
% % plot(data.ControlWTPre.DirectionNacelle,(data.ControlWTPre.PowerActive./data.TestWTPre.PowerActive),'sqr')
% plot(midpoint, Pow_binned_ControlWTpre./Pow_binned_TestWTpre,'-sqr')
% hold on
% % plot(data.ControlWTPre.DirectionNacelle,(data.ControlWTPre.WindSpeed./data.TestWTPre.WindSpeed),'ob')
% plot(midpoint, U_binned_ControlWTpre./U_binned_TestWTpre,'-ob')
% hold off
% grid on
% ylabel 'P(control)/P(test), v(control)/v(test)'
% % ylim([-0.5 14])
% xlabel 'Nacelle Pos [^{\circ}]'
% %
% ax2 = subplot(1, 2, 2);
% yyaxis left
% plot(data.TestWTPre.DirectionNacelle, data.ControlWTPre.DirectionNacelle,'xb')
% ylim([0 360])
% ylabel 'Nacelle Pos Control WT [^{\circ}]'
% yyaxis right
% % plot(data.TestWTPre.DirectionNacelle,(data.TestWTPre.DirectionNacelle - data.ControlWTPre.DirectionNacelle),'xr')
% plot(midpoint, deviation,'-r')
% ylim([-30 30]+30)
% ylabel 'deviation [^{\circ}]'
% grid on
% xlabel 'Nacelle Pos Test WT [^{\circ}]'
% sgtitle 'Northing (tbc)'
% xlim([0 360])

%% Run sync and filter function
clc
% Set out parameters for filtering
% 1) Power
Max_power = max( ...
        [ max(data.ControlWTPre.PowerActive), ...
          max(data.ControlWTPost.PowerActive),...
          max(data.TestWTPre.PowerActive), ...
          max(data.TestWTPost.PowerActive) ] ...
     );

% 2) Set out ata Gap Infill Threshold
Datagap_inFill = 3;
Mean_timestep = mean(diff(data.ControlWTPre.Time));

% 3) Set out lower threshold of RPM
lower_threshold_rpm_per_unit = 0.1; 
Max_gen_rpm = max( ...
        [ max(data.ControlWTPre.RPM), ...
          max(data.ControlWTPost.RPM), ...
          max(data.TestWTPre.RPM), ...
          max(data.TestWTPost.RPM) ] ...
    );

% Set out nacelle direction binning
degree_separation_per_bin = 20;%5;% degrees
No_threshold_direction = 360 / degree_separation_per_bin + 1;

No_bins = 15;%50;
P_per_bin = Max_power / No_bins;

if SELECT_DATA == 'WF0'

    filtered_data = windp2p.syncAndFilterData(data, 'WindDirectionNumSamplesThresh', 20,'PowerRangeThreshBinSize',500000);

elseif SELECT_DATA == 'WF1'

    filtered_data = windp2p.syncAndFilterData(data, 'WindDirectionNumSamplesThresh', 50,...
        'WindDirectionThreshNBins',No_threshold_direction,...
        'PowerRangeThreshBinSize',P_per_bin,...
        'SyncronisedTimeStepSize',Mean_timestep,...
        'DataGapInfillThreshold',Mean_timestep*Datagap_inFill,...
        'OperationalRPMThreshold',lower_threshold_rpm_per_unit*Max_gen_rpm);

elseif SELECT_DATA == 'WF3'

    filtered_data = windp2p.syncAndFilterData(data, 'WindDirectionNumSamplesThresh', 50,...
        'WindDirectionThreshNBins',No_threshold_direction,...
        'PowerRangeThreshBinSize',P_per_bin,...
        'SyncronisedTimeStepSize',Mean_timestep,...
        'DataGapInfillThreshold',Mean_timestep*Datagap_inFill,...
        'OperationalRPMThreshold',lower_threshold_rpm_per_unit*Max_gen_rpm);

elseif SELECT_DATA == 'WF4'

    filtered_data = windp2p.syncAndFilterData(data, 'WindDirectionNumSamplesThresh', 1,...
        'WindDirectionThreshNBins',No_threshold_direction,...
        'PowerRangeThreshBinSize',P_per_bin,...
        'SyncronisedTimeStepSize',Mean_timestep,...
        'DataGapInfillThreshold',Mean_timestep*Datagap_inFill,...
        'OperationalRPMThreshold',lower_threshold_rpm_per_unit*Max_gen_rpm, ...
        'WindDirectionNumSamplesThresh',0);

end

% % % Plot results (unfiltered and filtered)
% figure(13)
% subplot(2, 1, 1)
% plot(filtered_data.ControlWTPre.WindSpeed, filtered_data.ControlWTPre.PowerActive,'.')
% grid on
% xlabel 'Wind Speed [m/s]'
% ylabel 'Power [W]'
% title 'U to P (whole filtered dataset)'
% subplot(2, 1, 2)
% plot(filtered_data.ControlWTPre.RPM, filtered_data.ControlWTPre.PowerActive,'.')
% grid on
% xlabel 'RPM'
% ylabel 'Power [W]'
% title 'RPM to P (whole filtered dataset)'
% sgtitle 'Control WT (pre)'
% 
% figure(201)
% ax1 = subplot(4, 4, 1);
% plot(data.ControlWTPre.Time, data.ControlWTPre.RPM/1.3e3,'*r')
% hold on
% plot(filtered_data.ControlWTPre.Time, filtered_data.ControlWTPre.RPM/1.3e3,'ob')
% hold off
% grid minor
% legend Unfiltered Filtered 
% ylabel 'Gen speed [pu]'
% % xlim([0 500])
% title 'ControlWTPre'
% ax5 = subplot(4, 4, 5);
% plot(data.ControlWTPre.Time, data.ControlWTPre.PowerActive/base_kW,'*r')
% hold on
% plot(filtered_data.ControlWTPre.Time, filtered_data.ControlWTPre.PowerActive/base_kW,'ob')
% hold off
% grid minor
% ylabel 'P [pu]'
% % xlim([0 500])
% % % % % % 
% ax2 = subplot(4, 4, 2);
% plot(data.TestWTPre.Time, data.TestWTPre.RPM/1.3e3,'*r')
% hold on
% plot(filtered_data.TestWTPre.Time, filtered_data.TestWTPre.RPM/1.3e3,'ob')
% hold off
% grid minor
% ylabel 'Gen speed [pu]'
% % xlim([0 500])
% title 'TestWTPre'
% ax6 = subplot(4, 4, 6);
% plot(data.TestWTPre.Time, data.TestWTPre.PowerActive/base_kW,'*r')
% hold on
% plot(filtered_data.TestWTPre.Time, filtered_data.TestWTPre.PowerActive/base_kW,'ob')
% hold off
% grid minor
% ylabel 'P [pu]'
% % xlim([0 500])
% % % % % % 
% ax3 = subplot(4, 4, 3);
% plot(data.ControlWTPost.Time, data.ControlWTPost.RPM/1.3e3,'*r')
% hold on
% plot(filtered_data.ControlWTPost.Time, filtered_data.ControlWTPost.RPM/1.3e3,'ob')
% hold off
% grid minor
% ylabel 'Gen speed [pu]'
% % xlim([0 500]+10000)
% title 'ControlWTPost'
% ax7 = subplot(4, 4, 7);
% plot(data.ControlWTPost.Time, data.ControlWTPost.PowerActive/base_kW,'*r')
% hold on
% plot(filtered_data.ControlWTPost.Time, filtered_data.ControlWTPost.PowerActive/base_kW,'ob')
% hold off
% grid minor
% ylabel 'P [pu]'
% % xlim([0 500]+10000)
% % % % % % 
% ax4 = subplot(4, 4, 4);
% plot(data.TestWTPost.Time, data.TestWTPost.RPM/1.3e3,'*r')
% hold on
% plot(filtered_data.TestWTPost.Time, filtered_data.TestWTPost.RPM/1.3e3,'ob')
% hold off
% grid minor
% ylabel 'Gen speed [pu]'
% % xlim([0 500]+10000)
% title 'TestWTPost'
% ax8 = subplot(4, 4, 8);
% plot(data.TestWTPost.Time, data.TestWTPost.PowerActive/base_kW,'*r')
% hold on
% plot(filtered_data.TestWTPost.Time, filtered_data.TestWTPost.PowerActive/base_kW,'ob')
% hold off
% grid minor
% ylabel 'P [pu]'
% % xlim([0 500]+10000)
% %
% %
% ax9 = subplot(4, 4, 9);
% plot(data.ControlWTPre.Time, data.ControlWTPre.TemperatureExternal,'*r')
% hold on
% plot(filtered_data.ControlWTPre.Time, filtered_data.ControlWTPre.TemperatureExternal,'ob')
% hold off
% grid minor
% legend Unfiltered Filtered 
% ylabel 'Temp Ext'
% % xlim([0 500])
% % ylim([-5 20])
% ax13 = subplot(4, 4, 13);
% plot(data.ControlWTPre.Time, data.ControlWTPre.DirectionNacelle,'*r')
% hold on
% plot(filtered_data.ControlWTPre.Time, filtered_data.ControlWTPre.DirectionNacelle,'ob')
% hold off
% grid minor
% ylabel 'Dir Nacelle'
% xlabel 'Time [s]'
% % xlim([0 500])
% % % % % % 
% ax10 = subplot(4, 4, 10);
% plot(data.TestWTPre.Time, data.TestWTPre.TemperatureExternal,'*r')
% hold on
% plot(filtered_data.TestWTPre.Time, filtered_data.TestWTPre.TemperatureExternal,'ob')
% hold off
% grid minor
% ylabel 'Temp Ext'
% % xlim([0 500])
% % ylim([-5 20])
% ax14 = subplot(4, 4, 14);
% plot(data.TestWTPre.Time, data.TestWTPre.DirectionNacelle,'*r')
% hold on
% plot(filtered_data.TestWTPre.Time, filtered_data.TestWTPre.DirectionNacelle,'ob')
% hold off
% grid minor
% ylabel 'Dir Nacelle'
% xlabel 'Time [s]'
% % xlim([0 500])
% % % % % % 
% ax11 = subplot(4, 4, 11);
% plot(data.ControlWTPost.Time, data.ControlWTPost.TemperatureExternal,'*r')
% hold on
% plot(filtered_data.ControlWTPost.Time, filtered_data.ControlWTPost.TemperatureExternal,'ob')
% hold off
% grid minor
% ylabel 'Temp Ext'
% % xlim([0 500]+10000)
% % ylim([-5 20])
% ax15 = subplot(4, 4, 15);
% plot(data.ControlWTPost.Time, data.ControlWTPost.DirectionNacelle,'*r')
% hold on
% plot(filtered_data.ControlWTPost.Time, filtered_data.ControlWTPost.DirectionNacelle,'ob')
% hold off
% grid minor
% ylabel 'Dir Nacelle'
% xlabel 'Time [s]'
% % xlim([0 500]+10000)
% % % % % % 
% ax12 = subplot(4, 4, 12);
% plot(data.TestWTPost.Time, data.TestWTPost.TemperatureExternal,'*r')
% hold on
% plot(filtered_data.TestWTPost.Time, filtered_data.TestWTPost.TemperatureExternal,'ob')
% hold off
% grid minor
% ylabel 'Temp Ext'
% % xlim([0 500]+10000)
% % ylim([-5 20])
% ax16 = subplot(4, 4, 16);
% plot(data.TestWTPost.Time, data.TestWTPost.DirectionNacelle,'*r')
% hold on
% plot(filtered_data.TestWTPost.Time, filtered_data.TestWTPost.DirectionNacelle,'ob')
% hold off
% grid minor
% ylabel 'Dir Nacelle'
% xlabel 'Time [s]'
% % xlim([0 500]+10000)
% 
% % xlim([     min([data.ControlWTPre.Time(1) data.TestWTPre.Time(1)])...
% %      max([data.ControlWTPre.Time(end) data.TestWTPre.Time(end)])    ])
% 
% linkaxes([ax1 ax2 ax5 ax6 ax9 ax10 ax13 ax14],'x')
% 
% % xlim([     min([data.ControlWTPost.Time(1) data.TestWTPost.Time(1)])...
% %     max([data.ControlWTPost.Time(end) data.TestWTPost.Time(end)])    ])
% 
% % linkaxes([ax3 ax4 ax7 ax8 ax11 ax12 ax15 ax16],'x')

%% Aligning the indexing of the "filtered" data for both WTs

% Finding values that are sampled at the same time for both turbines
[filtered_data_new.TestWTPre.Time, filtered_data_new.TestWTPre.idx] = intersect(filtered_data.TestWTPre.Time, filtered_data.ControlWTPre.Time);
[filtered_data_new.ControlWTPre.Time, filtered_data_new.ControlWTPre.idx] = intersect(filtered_data.ControlWTPre.Time, filtered_data.TestWTPre.Time);

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
% filtered_data_new.ControlWTPre.ErrorCode = filtered_data.ControlWTPre.ErrorCode(filtered_data_new.ControlWTPre.idx);
% filtered_data_new.ControlWTPre.WpsStatus = filtered_data.ControlWTPre.WpsStatus(filtered_data_new.ControlWTPre.idx);
% filtered_data_new.ControlWTPre.WTOperationState = filtered_data.ControlWTPre.WTOperationState(filtered_data_new.ControlWTPre.idx);
% filtered_data_new.ControlWTPre.ProductionFactor = filtered_data.ControlWTPre.ProductionFactor(filtered_data_new.ControlWTPre.idx);

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
% filtered_data_new.TestWTPre.ErrorCode = filtered_data.TestWTPre.ErrorCode(filtered_data_new.TestWTPre.idx);
% filtered_data_new.TestWTPre.WpsStatus = filtered_data.TestWTPre.WpsStatus(filtered_data_new.TestWTPre.idx);
% filtered_data_new.TestWTPre.WTOperationState = filtered_data.TestWTPre.WTOperationState(filtered_data_new.TestWTPre.idx);
% filtered_data_new.TestWTPre.ProductionFactor = filtered_data.TestWTPre.ProductionFactor(filtered_data_new.TestWTPre.idx);

DateTimeTestWTPreNew = datetime(1970, 1, 1, 0, 0, filtered_data_new.TestWTPre.Time);
DateTimeControlWTPreNew = datetime(1970, 1, 1, 0, 0, filtered_data_new.ControlWTPre.Time);

%% Consistency of Turbine Settings

% % % figure(202)
% % % subplot(2, 2, 1)
% % % plot(filtered_data_new.ControlWTPre.PowerActive/base_kW, filtered_data_new.ControlWTPre.RPM/1.3e3,'.r')
% % % hold on
% % % plot(filtered_data.ControlWTPost.PowerActive/base_kW, filtered_data.ControlWTPost.RPM/1.3e3,'.b')
% % % hold off
% % % grid on
% % % xlabel 'Power [pu]'
% % % ylabel 'Gen Speed [pu]'
% % % % title Speed
% % % % ylim([600 1300]/1.3e3)
% % % legend 'Pre' 'Post' location southeast
% % % title 'Control WT'
% % % %
% % % subplot(2, 2, 3)
% % % plot(filtered_data_new.ControlWTPre.PowerActive/base_kW, filtered_data_new.ControlWTPre.PitchAngleA,'.r')
% % % hold on
% % % plot(filtered_data.ControlWTPost.PowerActive/base_kW, filtered_data.ControlWTPost.PitchAngleA,'.b')
% % % hold off
% % % grid on
% % % xlabel 'Power [pu]'
% % % ylabel 'Pitch [deg]'
% % % % title Pitch
% % % ylim([-1 20])
% % % 
% % % % figure(203)
% % % subplot(2, 2, 2)
% % % plot(filtered_data_new.TestWTPre.PowerActive/base_kW, filtered_data_new.TestWTPre.RPM/1.3e3,'.r')
% % % hold on
% % % plot(filtered_data.TestWTPost.PowerActive/base_kW, filtered_data.TestWTPost.RPM/1.3e3,'.b')
% % % hold off
% % % grid on
% % % xlabel 'Power [pu]'
% % % ylabel 'Gen Speed [pu]'
% % % % title Speed
% % % % ylim([600 1300]/1.3e3)
% % % % legend 'Pre' 'Post' location southeast
% % % title 'Test WT'
% % % %
% % % subplot(2, 2, 4)
% % % plot(filtered_data_new.TestWTPre.PowerActive/base_kW, filtered_data_new.TestWTPre.PitchAngleA,'.r')
% % % hold on
% % % plot(filtered_data.TestWTPost.PowerActive/base_kW, filtered_data.TestWTPost.PitchAngleA,'ob')
% % % hold off
% % % grid on
% % % xlabel 'Power [pu]'
% % % ylabel 'Pitch [deg]'
% % % % title Pitch
% % % ylim([-1 20])
% % % % sgtitle 'Test WT'

%% Make new histogram figure 

degree_sep_per_bin = 2;
range = 360;
figure(9)
subplot(1, 2, 1)
histogram(filtered_data_new.TestWTPre.DirectionNacelle, (0:degree_sep_per_bin:range))
grid on
grid minor
xlabel 'Nacelle Position [{\circ}]'
ylabel 'Count'
% title(sprintf('Nacelle Position for Turbine A (S%d)', TestWT_S_No)) % sgtitle 'Nacelle Position between two WTs'
subplot(1, 2, 2)
histogram(filtered_data_new.ControlWTPre.DirectionNacelle, (0:degree_sep_per_bin:range))
grid on
grid minor
xlabel 'Nacelle Position [{\circ}]'
ylabel 'Count'
% title(sprintf('Nacelle Position for Turbine B (S%d)', ControlWT_S_No)) % sgtitle 'Nacelle Position between two WTs'
sgtitle('Uncorrected Nacelle Direction for Turbines A and B')
% % % Figure sizing
% x0 = 1700;
% y0 = -300;
% Width = 900;
% Height = 400;
% set(gcf,'position',[x0, y0, Width, Height])

%%  Obtain average nacelle direction error between two turbines

% Make a table, then sort, then calculate error

NacDir_column1_TestWTPre = filtered_data_new.TestWTPre.DirectionNacelle';
NacDir_column2_ControlWTPre = filtered_data_new.ControlWTPre.DirectionNacelle';
Table_NacDir = table(NacDir_column1_TestWTPre, NacDir_column2_ControlWTPre);

Table_NacDir = sortrows(Table_NacDir,'NacDir_column2_ControlWTPre');

Average_error = wrapTo180(Table_NacDir.NacDir_column1_TestWTPre - Table_NacDir.NacDir_column2_ControlWTPre);
Average_error(isnan(Average_error)) = [];

Average_error_sum = sum(Average_error) / length(Table_NacDir.NacDir_column2_ControlWTPre);

New_shifted_NacDir_column1 = wrapTo360(Table_NacDir.NacDir_column1_TestWTPre - Average_error_sum);

figure(8)
subplot(1, 2, 1)
plot(Table_NacDir.NacDir_column1_TestWTPre, '.')
hold on
plot(New_shifted_NacDir_column1,'.')
plot(Table_NacDir.NacDir_column2_ControlWTPre, '.')
hold off
grid on
grid minor
legend 'Turbine A' 'Turbine A - mean(Error)' 'Turbine B' 'location' 'northoutside' 'Orientation' 'horizontal'
xlabel 'Sample'
ylabel 'Nacelle Position [{\circ}]'
xlim([0 length(Average_error)])
ylim([0 360])
subplot(1, 2, 2)
set(gca,'ColorOrderIndex',4)
hold on % Necessary for colour order index to kick in
plot(Average_error,'.')
box on
txt = ['mean(Error): ' num2str(Average_error_sum) '{\circ}'];
plot([1 length(Average_error)],[Average_error_sum Average_error_sum])
text(5000, - 50, txt)
hold off % Necessary for colour order index to kick in
ylim([-60 60])
legend 'Error = Turbine A - Turbine B' 'mean(Error)' 'location' 'northoutside' 'Orientation' 'horizontal'
grid on
grid minor
xlabel 'Sample'
ylabel '\DeltaPosition = Error [{\circ}]'
xlim([0 length(Average_error)])
% sgtitle(sprintf('Nacelle Position for Turbine A (S%d) and Turbine B (S%d)', TestWT_S_No, ControlWT_S_No)) % sgtitle 'Nacelle Position between two WTs'
% % % Figure sizing
% x0 = 1550;
% y0 = 300;
% Width = 900;
% Height = 400;
% set(gcf,'position',[x0, y0, Width, Height])

filtered_data_new.ControlWTPre.DirectionNacelleCorrected = wrapTo360(filtered_data_new.ControlWTPre.DirectionNacelle + Average_error_sum);

%%  Northing filtered data 

% % % Northing has been separated from P2P. See separate Northing script. 
% degree_separation_per_bin = 4;% degrees
% No_threshold_direction = 360/degree_separation_per_bin + 1;
% nacelle_direction_edges = linspace(0, 360, No_threshold_direction);
% 
% clear midpoint deviation
% midpoint = 0.5*((nacelle_direction_edges(1:(No_threshold_direction - 1)))+(nacelle_direction_edges(2:(No_threshold_direction))));
% 
% dev1 = filtered_data_new.TestWTPre.DirectionNacelle;
% dev2 = filtered_data_new.ControlWTPre.DirectionNacelleCorrected;
% 
% deviation_raw = wrapTo180(dev1 - dev2);
% 
% % figure(9)
% % plot(DateTimeTestWTPreNew, deviation_raw,'.')
% % ylabel 'Deviation in nacelle direction between WTs'
% % xlabel DateTime
% % grid minor
% 
% clear Pow_binned_ControlWTpre Pow_binned_TestWTpre U_binned_ControlWTpre U_binned_TestWTpre idx_ControlWTPre_Dir idx_TestWTPre_Dir
% 
% for k = 1:(length(nacelle_direction_edges)-1)
%     idx_ControlWTPre_Dir{k}=find((filtered_data_new.ControlWTPre.DirectionNacelleCorrected>=nacelle_direction_edges(k)) & (filtered_data_new.ControlWTPre.DirectionNacelleCorrected<=nacelle_direction_edges(k + 1)));
%     idx_TestWTPre_Dir{k}=find((filtered_data_new.TestWTPre.DirectionNacelle>=nacelle_direction_edges(k)) & (filtered_data_new.TestWTPre.DirectionNacelle<=nacelle_direction_edges(k + 1)));
% 
%     Pow_binned_ControlWTpre(k) = mean(filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_Dir{k}));
%     Pow_binned_TestWTpre(k) = mean(filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_Dir{k}));
% 
%     U_binned_ControlWTpre(k) = mean(filtered_data_new.ControlWTPre.WindSpeed(idx_ControlWTPre_Dir{k}));
%     U_binned_TestWTpre(k) = mean(filtered_data_new.TestWTPre.WindSpeed(idx_TestWTPre_Dir{k}));
% 
%     deviation(k) = mean(deviation_raw(idx_TestWTPre_Dir{k}));
% 
%     Mean_NacDir_ControlWTpre(k) = mean(filtered_data_new.ControlWTPre.DirectionNacelleCorrected(idx_ControlWTPre_Dir{k}));
%     Mean_NacDir_TestWTpre(k) = mean(filtered_data_new.TestWTPre.DirectionNacelle(idx_TestWTPre_Dir{k}));
% 
%     Deviation_bins(k) = Mean_NacDir_TestWTpre(k)-Mean_NacDir_ControlWTpre(k);
% 
% end
% 
% figure(5)
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
% % sgtitle(sprintf('Northing of Turbine A (S%d) and Turbine B (S%d)', TestWT_S_No, ControlWT_S_No)) 
% % % % Figure sizing
% % x0 = 2300;
% % y0 = 300;
% % Width = 900;
% % Height = 400;
% % set(gcf,'position',[x0, y0, Width, Height])
% 
% 
% % % % % % % % % % % % % % % % % % % % Testing alternative plot
% 
% figure(10)
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
% % % % % % sgtitle(sprintf('Power and Wind Speed of Turbine A (S%d) and Turbine B (S%d)', TestWT_S_No, ControlWT_S_No)) 
% % ylim([-0.5 14])
% % % % Figure sizing
% x0 = 2450;
% y0 = -300;
% % Width = 700;
% % Height = 900;
% % set(gcf,'position',[x0, y0, Width, Height])
% % 
% % figure(11)
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
% % sgtitle(sprintf('Power of Turbine A (S%d) and Turbine B (S%d)', TestWT_S_No, ControlWT_S_No)) 
% % ylim([-0.5 14])
% % % % Figure sizing
% % x0 = 2800;
% % y0 = 300;
% % Width = 700;
% % % % % % Width = 900;
% % % % % % Height = 900;
% % % % % % set(gcf,'position',[x0, y0, Width, Height])
% 
% 
% 
% 
% % % % Saving Figures
% % Fig_Error_name = "Sonnedix_NacError_S"+TestWT_S_No+"_and_S"+ControlWT_S_No;
% % saveas(figure(8),Fig_Error_name,'jpg')
% % saveas(figure(8),Fig_Error_name,'fig')
% % 
% % Fig_Northing_name = "Sonnedix_Northing_S"+TestWT_S_No+"_and_S"+ControlWT_S_No;
% % saveas(figure(5),Fig_Northing_name,'jpg')
% % saveas(figure(5),Fig_Northing_name,'fig')
% % 
% % Fig_Histogram_name = "Sonnedix_Histogram_S"+TestWT_S_No+"_and_S"+ControlWT_S_No;
% % saveas(figure(9),Fig_Histogram_name,'jpg')
% % saveas(figure(9),Fig_Histogram_name,'fig')
% % 
% % Fig_Pow_WindSp_name = "Sonnedix_Power_and_Wind_Speed_S"+TestWT_S_No+"_and_S"+ControlWT_S_No;
% % saveas(figure(10),Fig_Pow_WindSp_name,'jpg')
% % saveas(figure(10),Fig_Pow_WindSp_name,'fig')

%% Comparing wind and nacelle error... (only works if wind direction is recorded)

% % % Note: also moved to Northing
% clc
% 
% NacDir_column1_TestWT = filtered_data_new.TestWTPre.DirectionNacelle';
% NacDir_column2_ControlWT = filtered_data_new.ControlWTPre.DirectionNacelle';
% 
% WindDir_column1_TestWT = filtered_data_new.TestWTPre.WindDirection';
% WindDir_column2_ControlWT = filtered_data_new.ControlWTPre.WindDirection';
% 
% % Comparing Nacelle Direction from WT1 to WT2
% Table = table(NacDir_column1_TestWT, NacDir_column2_ControlWT);
% Table = sortrows(Table,'NacDir_column2_ControlWT');
% Average_error = wrapTo180(wrapTo360(Table.NacDir_column1_TestWT)-wrapTo360(Table.NacDir_column2_ControlWT));
% Average_error(isnan(Average_error))=[];
% Average_difference_in_NacDir_between_TestWT_and_ControlWT = (sum(Average_error)/length(Table.NacDir_column2_ControlWT))
% 
% % Comparing Wind Direction from WT1 to WT2
% Table = table(WindDir_column1_TestWT, WindDir_column2_ControlWT);
% Table = sortrows(Table,'WindDir_column2_ControlWT');
% Average_error = wrapTo360(Table.WindDir_column1_TestWT)-wrapTo360(Table.WindDir_column2_ControlWT);
% Average_error(isnan(Average_error))=[];
% Average_difference_in_WindDir_between_TestWT_and_ControlWT = wrapTo180(sum(Average_error)/length(Table.WindDir_column2_ControlWT))
% 
% % Comparing Nacelle Direction and Wind Direction for Test WT
% Table = table(NacDir_column1_TestWT, WindDir_column1_TestWT);
% Table = sortrows(Table,'WindDir_column1_TestWT');
% Average_error = wrapTo360(Table.NacDir_column1_TestWT)-wrapTo360(Table.WindDir_column1_TestWT);
% Average_error(isnan(Average_error))=[];
% Average_difference_between_NacPos_and_WindDir_for_TestWT = wrapTo180(sum(Average_error)/length(Table.WindDir_column1_TestWT))
% 
% % Comparing Nacelle Direction and Wind Direction for Control WT
% Table = table(NacDir_column2_ControlWT, WindDir_column2_ControlWT);
% Table = sortrows(Table,'WindDir_column2_ControlWT');
% Average_error = wrapTo360(Table.NacDir_column2_ControlWT)-wrapTo360(Table.WindDir_column2_ControlWT);
% Average_error(isnan(Average_error))=[];
% Average_difference_between_NacPos_and_WindDir_for_ControlWT = wrapTo180(sum(Average_error)/length(Table.WindDir_column2_ControlWT))
% 
% PlossTestWT = (1 - cos(deg2rad(Average_difference_between_NacPos_and_WindDir_for_TestWT)))*100;
% 
% PlossControlWT = (1 - cos(deg2rad(Average_difference_between_NacPos_and_WindDir_for_ControlWT)))*100;
% 
% Prev_calculated__Average_error_sum = wrapTo180(Average_error_sum)

%% Wind Direction versus Active Power (Smart blade paper Figure 1) NOT CURRENTLY USED

% % % Not currently used, not found to be that helpful. 
% % % % % % % % % % % Correcting Wind Direction Error Start % % % % % % %
% 
% % Make a table where each column is the
% % sequencial wind direction of each turbine. Then sort for one of the
% % turbines. Then compare and calculate error
% 
% WindDir_column1_TestWTPre = filtered_data_new.TestWTPre.WindDirection';
% WindDir_column2_ControlWTPre = filtered_data_new.ControlWTPre.WindDirection';
% Table_WindDir = table(WindDir_column1_TestWTPre, WindDir_column2_ControlWTPre);
% 
% Table_WindDir = sortrows(Table_WindDir,'WindDir_column2_ControlWTPre');
% 
% Average_error = wrapTo360(Table_WindDir.WindDir_column1_TestWTPre - Table_WindDir.WindDir_column2_ControlWTPre);
% Average_error_wind_sum = sum(Average_error)/length(Table_WindDir.WindDir_column2_ControlWTPre);
% 
% New_shifted_WindDir_column1 = wrapTo360(Table_WindDir.WindDir_column1_TestWTPre - Average_error_wind_sum);
% 
% figure(10)
% plot(Table_WindDir.WindDir_column1_TestWTPre,'.')
% hold on
% plot(New_shifted_WindDir_column1,'.')
% plot(Table_WindDir.WindDir_column2_ControlWTPre,'.')
% plot(Average_error,'.')
% hold off
% legend Column1Test 'Column1Test - AverageError' Column2Control Error 
% title 'Error in Wind Direction between two WTs'
% 
% filtered_data_new.ControlWTPre.WindDirectionCorrected = wrapTo360(filtered_data_new.ControlWTPre.WindDirection...
%     ... + Average_error_wind_sum); % Wind Direction Error
%     + Average_error_sum); % Nacelle Position Error
% 
% % % % % % % % % % % Correcting Nacelle Direction Error End % % % % % % % %
% 
% degree_separation_per_bin = 2;% degrees
% 
% if floor(360/degree_separation_per_bin)==ceil(360/degree_separation_per_bin)
%     % do nothing
% else
%     error ('The size of bins must be a multiple of 360.')
% end
% 
% No_threshold_direction = 360/degree_separation_per_bin + 1;
% wind_direction_edges = linspace(0, 360, No_threshold_direction);
% 
% clear midpoint_wind deviation
% midpoint_wind = 0.5*((wind_direction_edges(1:(No_threshold_direction - 1)))+(wind_direction_edges(2:(No_threshold_direction))));
% 
% clear Pow_binned_ControlWTpre Pow_binned_TestWTpre ...
%     Pow_binned_ControlWTpre_mean ...
%     Pow_binned_TestWTpre_mean ...
%     U_binned_ControlWTpre U_binned_TestWTpre ...
%     idx_ControlWTPre_WindDir idx_TestWTPre_WindDir ...
%     Pow_binned_ControlWTpre_min Pow_binned_TestWTpre_min ...
%     Pow_binned_ControlWTpre_max Pow_binned_TestWTpre_max ...
%     lower_error_ControlWTpre lower_error_TestWTpre ...
%     upper_error_ControlWTpre upper_error_TestWTpre
% 
% for k = 1:(length(wind_direction_edges)-1)
%     idx_ControlWTPre_WindDir{k}=find((filtered_data_new.ControlWTPre.WindDirectionCorrected>=wind_direction_edges(k)) & (filtered_data_new.ControlWTPre.WindDirectionCorrected<=wind_direction_edges(k + 1)));
%     idx_TestWTPre_WindDir{k}=find((filtered_data_new.TestWTPre.WindDirection>=wind_direction_edges(k)) & (filtered_data_new.TestWTPre.WindDirection<=wind_direction_edges(k + 1)));
% 
%     Pow_binned_ControlWTpre_mean(k) = mean(filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_WindDir{k}));
%     Pow_binned_TestWTpre_mean(k) = mean(filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_WindDir{k}));
% 
%     Pow_binned_ControlWTpre_min(k) = min(filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_WindDir{k}));
%     Pow_binned_TestWTpre_min(k) = min(filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_WindDir{k}));
% 
%     Pow_binned_ControlWTpre_max(k) = max(filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_WindDir{k}));
%     Pow_binned_TestWTpre_max(k) = max(filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_WindDir{k}));
% 
%     % U_binned_ControlWTpre(k) = mean(filtered_data.ControlWTPre.WindSpeed(idx_ControlWTPre_WindDir{k}));
%     % U_binned_TestWTpre(k) = mean(filtered_data.TestWTPre.WindSpeed(idx_TestWTPre_WindDir{k}));
% 
%     % deviation(k) = mean(deviation_raw(idx_TestWTPre_WindDir{k}));
% 
%     lower_error_ControlWTpre(k) = Pow_binned_ControlWTpre_mean(k) - Pow_binned_ControlWTpre_min(k);
%     lower_error_TestWTpre(k) = Pow_binned_TestWTpre_mean(k) - Pow_binned_TestWTpre_min(k);
% 
%     upper_error_ControlWTpre(k) = Pow_binned_ControlWTpre_max(k) - Pow_binned_ControlWTpre_mean(k);
%     upper_error_TestWTpre(k) = Pow_binned_TestWTpre_max(k) - Pow_binned_TestWTpre_mean(k);
% 
% 
% end
% 
% 
% 
% figure(6)
% errorbar(midpoint_wind, Pow_binned_ControlWTpre_mean/base_kW, lower_error_ControlWTpre/base_kW, upper_error_ControlWTpre/base_kW)
% hold on
% errorbar(midpoint_wind, Pow_binned_TestWTpre_mean/base_kW, lower_error_TestWTpre/base_kW, upper_error_TestWTpre/base_kW)
% hold off
% grid on
% xlabel 'Wind Direction [^{\circ}]'
% ylabel 'Active Power [pu]'
% legend 'ControlWTpre' 'TestWTpre'
% 
% figure(7)
% errorbar(midpoint_wind, Pow_binned_ControlWTpre_mean./Pow_binned_TestWTpre_mean, lower_error_ControlWTpre./upper_error_TestWTpre, upper_error_ControlWTpre./lower_error_TestWTpre)
% grid on
% xlabel 'Wind Direction [^{\circ}]'
% ylabel 'Active Power Ratio [pu]'
% title 'Check wind direction with large wake interaction'

%% FILTERING AND NORTHING COMPLETE

% Now onto binning and power to power relationships

%% Power and nacelle direction binning for ***CONTROL*** WT (WindGuard) 

clc
degree_separation_per_bin = 10;% degrees

if floor(360 / degree_separation_per_bin) == ceil(360 / degree_separation_per_bin)
    % do nothing
else
    error ('The size of direction bins must be a multiple of 360.')
end

No_threshold_direction = 360 / degree_separation_per_bin + 1;
nacelle_pos_edges = linspace(0, 360, No_threshold_direction);

clear midpoint_wind deviation
midpoint_wind = 0.5 * ( ...
    (nacelle_pos_edges(1:(No_threshold_direction - 1))) ...
    + (nacelle_pos_edges(2:(No_threshold_direction))) ...
    );

clear Pow_binned_ControlWTpre Pow_binned_TestWTpre ...
    Pow_binned_ControlWTpre_mean ...
    Pow_binned_TestWTpre_mean ...
    U_binned_ControlWTpre U_binned_TestWTpre ...
    idx_ControlWTPre_Dir idx_TestWTPre_Dir ...
    Pow_binned_ControlWTpre_min Pow_binned_TestWTpre_min ...
    Pow_binned_ControlWTpre_max Pow_binned_TestWTpre_max ...
    lower_error_ControlWTpre lower_error_TestWTpre ...
    upper_error_ControlWTpre upper_error_TestWTpre

pow_separation_per_bin = base_kW / 10;% kW %%%% 500 previously for base_kW = 2.5e3

if floor(base_kW/pow_separation_per_bin) == ceil(base_kW/pow_separation_per_bin)
    % do nothing
else
    error ('The size of power bins must be a multiple of base power.')
end

No_threshold_direction_kW = base_kW / pow_separation_per_bin + 1;
power_edges = linspace(0, base_kW, No_threshold_direction_kW);

% add additional bin
power_edges(length(power_edges)+1) = power_edges(end) + pow_separation_per_bin;

% clear midpoint_power
% midpoint_power = 0.5*((power_edges(1:(No_threshold_direction_kW - 1)))+(power_edges(2:(No_threshold_direction_kW))));

clear idx_ControlWTPre_Power idx_ControlWTPre_NacPos
for k = 1:(length(nacelle_pos_edges)-1)

    idx_ControlWTPre_NacPos{k} = find((filtered_data_new.ControlWTPre.DirectionNacelleCorrected>=nacelle_pos_edges(k)) & (filtered_data_new.ControlWTPre.DirectionNacelleCorrected<=nacelle_pos_edges(k + 1)));
    
    % figure(1100)
    % plot(DateTimeControlWTPre_New(idx_ControlWTPre_NacPos{k}),filtered_data_new.ControlWTPre.DirectionNacelleCorrected(idx_ControlWTPre_NacPos{k}),'.')
    % grid on
    % str = sprintf('Nacelle Dir bin from %d to %d ', nacelle_pos_edges(k), nacelle_pos_edges(k + 1));
    % title(str)

    for n = 1:(length(power_edges)-1)

        idx_ControlWTPre_Power_temp = find((filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_NacPos{k})>=power_edges(n)) & (filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_NacPos{k})<=power_edges(n + 1)));
        idx_ControlWTPre_Power{n, k}=idx_ControlWTPre_NacPos{k}(idx_ControlWTPre_Power_temp);

        if ~isempty(idx_ControlWTPre_Power{n, k})
            if length(idx_ControlWTPre_Power{n, k}) < 15 %%%% Used to be 50 before WF4
                idx_ControlWTPre_Power{n, k} = [];
            end
        end

        % % % Plotting for troubleshooting
        % figure(1200)
        % plot(DateTimeControlWTPre_New(idx_ControlWTPre_Power{n, k}),filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_Power{n, k}),'.')
        % grid on
        % str = sprintf('Power bin from %d to %d ', power_edges(n), power_edges(n + 1));
        % title(str)

    end

end

% Clearing any indices that appear in idx_ControlWTPre_NacPos but not in idx_ControlWTPre_Power
for k = 1:(length(nacelle_pos_edges)-1)
    idx_ControlWTPre_NacPos{k}=[]; 

    clear height
    for row = 1:height(idx_ControlWTPre_Power)

    % Remove any index in idx_ControlWTPre_NacPos that isn't also in idx_ControlWTPre_Power_temp 
    idx_ControlWTPre_NacPos{k}=[idx_ControlWTPre_NacPos{k} idx_ControlWTPre_Power{row, k}]; 

    end
end

%% Windguard's slide 11: Power - to - power relationships 

for column = 1:(length(nacelle_pos_edges)-1)% nacelle direction bins

    for row = 1:(length(power_edges)-1)% power bins

        PmeanControlWT(row, column) = mean(filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_Power{row, column}));
        NDmeanControlWT(row, column) = mean(filtered_data_new.ControlWTPre.DirectionNacelleCorrected(idx_ControlWTPre_Power{row, column}));
        PmeanTestWT(row, column) = mean(filtered_data_new.TestWTPre.PowerActive(idx_ControlWTPre_Power{row, column}));
        NDmeanTestWT(row, column) = mean(filtered_data_new.TestWTPre.DirectionNacelle(idx_ControlWTPre_Power{row, column}));

    end

end

% find empty cells
emptyCells = cellfun(@isempty, idx_ControlWTPre_Power);

% ignore columns with empty cells
Column_Sum = sum(emptyCells);
Columns_of_interest = find(Column_Sum==0);

% Making line of best fit (ignore the above rated P bin)
% for k = 1:length(Columns_of_interest)
%     x = PmeanControlWT(1:5, Columns_of_interest(k));
%     y = PmeanTestWT(1:5, Columns_of_interest(k));
% 
%     coefficients = polyfit(x, y, 1);
%     xFit = linspace(0, base_kW, 1000);
%     yFit = polyval(coefficients , xFit);
%     Coef{k}=coefficients;
% end

% Same but go through origin
for k = 1:length(Columns_of_interest)
    x = PmeanControlWT(1:(length(power_edges)-1),Columns_of_interest(k));
    y = PmeanTestWT(1:(length(power_edges)-1),Columns_of_interest(k));
    c(k) = x \ y;            %<<<<<<<<<<<<<<<<<<<<<<<<<<< This is the important part of this section
end

x_axis = [0, 2625];

figure(12)
plot(PmeanControlWT(:,Columns_of_interest(1))/base_kW, PmeanTestWT(:,Columns_of_interest(1))/base_kW,'.')
hold on
for column = 2:length(Columns_of_interest)
    plot(PmeanControlWT(:,Columns_of_interest(column))/base_kW, PmeanTestWT(:,Columns_of_interest(column))/base_kW,'.')
end
set(gca,'ColorOrderIndex',1)
plot(x_axis/base_kW,(x_axis*c(1))/base_kW)
for column = 2:length(Columns_of_interest)
    plot(x_axis/base_kW,(x_axis*c(column))/base_kW)
end
legend 170 - 180 180 - 190 240 - 250 250 - 260 260 - 270 270 - 280 280 - 290 290 - 300 300 - 310 310 - 320 320 - 330 location northwest
hold off
grid minor
xlabel 'P_{control} [pu]'
ylabel 'P_{test} [pu]'

%% Comparing time domain instantaneous estimation of Test WT power relative to Control WT power USING TESTING DATA

clear P_TestWT_Post_estimated n idx_post_total

DateTimeControlWTPost_new = datetime(1970, 1, 1, 0, 0, filtered_data.ControlWTPost.Time);
DateTimeTestWTPost_new = datetime(1970, 1, 1, 0, 0, filtered_data.TestWTPost.Time);

% part 1: bin the individual datapoints into the correct power directional bins

for k = 1:(length(nacelle_pos_edges)-1)

    idx_ControlWTPost_NacPos{k} = find((wrapTo360(filtered_data.ControlWTPost.DirectionNacelle+ Average_error_sum)>=nacelle_pos_edges(k)) & (wrapTo360(filtered_data.ControlWTPost.DirectionNacelle+ Average_error_sum)<=nacelle_pos_edges(k + 1)));
    
end

% part 2: find estimated Ptest as a function of Pcontrol

index_for_plotting = [];
PTestimate_for_plotting = [];
for k = 1:length(Columns_of_interest)
    n = Columns_of_interest(k);
    P_TestWT_Post_estimated{k} = c(k)*filtered_data.ControlWTPost.PowerActive(idx_ControlWTPost_NacPos{n});
    index_for_plotting = [index_for_plotting idx_ControlWTPost_NacPos{n}];
    PTestimate_for_plotting = [PTestimate_for_plotting P_TestWT_Post_estimated{k}];
end

% part 3: superimose estimated Ptest with measured Ptest

% PART 3 NOT DONE

% rearrange by date to allow for time domain plotting
% idx_column1 = index_for_plotting';
% Pest_column2 = Pestimate_for_plotting';
% Table_Pest = table(idx_column1, Pest_column2);
% Table_Pest = sortrows(Table_Pest,'idx_column1');

% Now plot results

figure(15)
ax1 = subplot(3, 1, 1);
plot(DateTimeTestWTPost_new, filtered_data.TestWTPost.PowerActive,'or')
hold on
plot(DateTimeControlWTPost_new, filtered_data.ControlWTPost.PowerActive,'.k')
hold off
grid minor
ylabel 'Power [kW]'
legend 'Test WT (actual)' 'Control WT (actual)'
ax2 = subplot(3, 1, 2);
plot(DateTimeTestWTPost_new, filtered_data.TestWTPost.PowerActive,'or')
hold on
% plot(filtered_data.ControlWTPost.Time(Table_Pest.idx_column1),Pest_column2,'ob')
plot(DateTimeControlWTPost_new(idx_ControlWTPost_NacPos{Columns_of_interest(1)}),P_TestWT_Post_estimated{1},'.b')
for n = 2:length(Columns_of_interest)
    plot(DateTimeControlWTPost_new(idx_ControlWTPost_NacPos{Columns_of_interest(n)}),P_TestWT_Post_estimated{n},'.b')
end
hold off
grid minor
ylabel 'Power [kW]'
legend 'Test WT (actual)' 'Estimated based on Control WT'


ax3 = subplot(3, 1, 3);
plot(DateTimeControlWTPost_new(idx_ControlWTPost_NacPos{Columns_of_interest(1)}),filtered_data.ControlWTPost.DirectionNacelle(idx_ControlWTPost_NacPos{Columns_of_interest(1)}),'.b')
hold on
for n = 2:length(Columns_of_interest)
    plot(DateTimeControlWTPost_new(idx_ControlWTPost_NacPos{Columns_of_interest(n)}),filtered_data.ControlWTPost.DirectionNacelle(idx_ControlWTPost_NacPos{Columns_of_interest(n)}),'.b')
end
for k = 1:(length(nacelle_pos_edges))
    plot([DateTimeControlWTPost_new(1) DateTimeControlWTPost_new(end)],[nacelle_pos_edges(k) nacelle_pos_edges(k)],'m')
end
legend 'Nacelle Position of control WT'
hold off
grid minor
xlabel 'Time'
ylabel 'Nacelle Direction [deg]'
sgtitle 'Estimated power at test turbine POST MOD'
linkaxes([ax1 ax2 ax3],'x')
linkaxes([ax1 ax2],'y')


%% Trying to understand wind curves etc (Ignore, won't be relevant to final solution)

for column = 1:(length(nacelle_pos_edges)-1)% nacelle direction bins

    for row = 1:(length(power_edges)-1)% power bins

    % WindSpControlWT{row, column}=(filtered_data_new.ControlWTPre.WindSpeed(idx_ControlWTPre_Power{row, column}));
    WindSpMeanControlWT(row, column)=mean(filtered_data_new.ControlWTPre.WindSpeed(idx_ControlWTPre_Power{row, column}));

    end

end

v_rated = 13.5;

figure(14)
plot(WindSpMeanControlWT(:,Columns_of_interest(1))/v_rated, PmeanControlWT(:,Columns_of_interest(1))/base_kW,'.-')
hold on
for column = 2:length(Columns_of_interest)
plot(WindSpMeanControlWT(:,Columns_of_interest(column))/v_rated, PmeanControlWT(:,Columns_of_interest(column))/base_kW,'.-')
end
hold off
grid on
xlabel v/vrated
ylabel P/Prated
title 'Using mean values only'

%% Obtain PTestimated from PC for training data

clear P_TestWT_estimated Coef_TestWTindexing VT

% Step 1: choose wind direction bin according to nacelle position
for k = 1:1:length(Columns_of_interest)
    n = Columns_of_interest(k); % ie 270 - 280 degrees
    
    % Step 2: Reproduce power output of test turbine for relevant direction bin.
    P_TestWT_estimated{k} = c(k)*filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_NacPos{n});
   
end

%% Making new bins for the Test WT training data

% The purpose of indexing the test WT training data is that it will be used
% to establish a relationship between wind speed and power using either
% piecewise linear fit OR polymonial relationship. 

clc

% Put each Test turbine (Pre mod) datapoint in the correct bin
clear idx_TestWTPre_Power idx_TestWTPre_NacPos
for k = 1:(length(nacelle_pos_edges)-1)

    idx_TestWTPre_NacPos{k}=find((filtered_data_new.TestWTPre.DirectionNacelle>=nacelle_pos_edges(k)) & (filtered_data_new.TestWTPre.DirectionNacelle<=nacelle_pos_edges(k + 1)));
    
    % figure(1100)
    % plot(DateTimeTestWTPreNew(idx_TestWTPre_NacPos{k}),filtered_data_new.TestWTPre.DirectionNacelle(idx_TestWTPre_NacPos{k}),'.')
    % grid on
    % str = sprintf('Checking that the binning is OK: Nacelle Dir bin from %d to %d ', nacelle_pos_edges(k), nacelle_pos_edges(k + 1));
    % title(str)

    for n = 1:(length(power_edges)-1)

        idx_TestWTPre_Power_temp = find((filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_NacPos{k})>=power_edges(n)) & (filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_NacPos{k})<=power_edges(n + 1)));
        idx_TestWTPre_Power{n, k}=idx_TestWTPre_NacPos{k}(idx_TestWTPre_Power_temp);

        if ~isempty(idx_TestWTPre_Power{n, k})
            if length(idx_TestWTPre_Power{n, k}) < 20 % <<<<<<<<<< being more lenient than previously
                idx_TestWTPre_Power{n, k} = [];
            end
        end


        % figure(1200)
        % plot(DateTimeTestWTPreNew(idx_TestWTPre_Power{n, k}),filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_Power{n, k}),'.')
        % grid on
        % str = sprintf('Checking that the binning is OK: Power bin from %d to %d ', power_edges(n), power_edges(n + 1));
        % title(str)

    end

end


% Clearing any indices that appear in idx_TestWTPre_NacPos but not in idx_TestWTPre_Power
for k = 1:(length(nacelle_pos_edges)-1)
    idx_TestWTPre_NacPos{k}=[]; 

    for row = 1:height(idx_TestWTPre_Power)

    % Remove any index in idx_TestWTPre_NacPos that isn't also in idx_TestWTPre_Power_temp 
    idx_TestWTPre_NacPos{k}=[idx_TestWTPre_NacPos{k} idx_TestWTPre_Power{row, k}]; 

    end
end


%% Getting coefficients for best fit line between ***Test***WT wind and power (training data)

clc

clear U_TestWT_bestfit x y Coef_TestWTindexing

SELECT_Fitting_Technique = 1; % 1 = polyfit, 2 = piecewise linear fit

for k = 1:1:length(Columns_of_interest)
    n = Columns_of_interest(k);

    y = filtered_data_new.TestWTPre.WindSpeed(idx_TestWTPre_NacPos{n})';
    x = filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_NacPos{n})';

    if SELECT_Fitting_Technique == 1

        coefficients_vt2 = polyfit(x, y, 3);
        xFit = linspace(0, base_kW*1.05, 1000);
        yFit = polyval(coefficients_vt2 , xFit);
        Coef_TestWTindexing{k}=coefficients_vt2;

    elseif SELECT_Fitting_Technique == 2

        % slmengine function for piecewise linear
        slm = slmengine(x, y,'plot','off','kn',power_edges(1):pow_separation_per_bin:power_edges(end),'deg',1);
        
        slmcoef_TestWTindexing{k} = slm.coef;
        % slmcoef{k}(end)=25; %%% <<<<<<<<<<<<< MANUAL OVERRIDE OF FINAL "POINT OF BEST FIT"

        % Using interp1 as a lookup table for the xFit and yfits
        xFit = linspace(0, base_kW*1.05, 1000);
        yFit = interp1(power_edges, slmcoef_TestWTindexing{k}',xFit);

    end

    if SELECT_Fitting_Technique == 1
        U_TestWT_bestfit{k} = polyval(Coef_TestWTindexing{k},x);
    elseif SELECT_Fitting_Technique == 2
        U_TestWT_bestfit{k} = interp1(power_edges, slmcoef_TestWTindexing{k}',x);
    end

    figure(17)
    plot(x, filtered_data_new.TestWTPre.WindSpeed(idx_TestWTPre_NacPos{n}),'.')
    hold on
    plot(xFit, yFit,'r','LineWidth',1)
    hold off
    grid on
    ylabel 'U (Control turbine) [m/s]'
    xlabel 'P_T [W]'
    title 'Inverted power curve P_T to U_{TestWT}'
end

figure(18)
plot(U_TestWT_bestfit{1},filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_NacPos{Columns_of_interest(1)})/base_kW,'.')
hold on
for k = 2:length(Columns_of_interest)
    plot(U_TestWT_bestfit{k},filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_NacPos{Columns_of_interest(k)})/base_kW,'.')
end
hold off
grid on
xlabel 'U_{T meas} [m/s]'
ylabel 'P_{T meas} [pu]'
title 'Polyfit'

%% Now find coefficients to link control turbine power to speed

% New onwards from 1/9/23 - having been away from P2P and come back, I
% think there were some errors in my implementation. 

% Basically, by linking the relationship of control turbine to control wind
% speed, it is possible to establish its own power curve. Then, to make it
% relevant to the estimated test turbine power, employ the "c" coefficient.


clc

clear U_ControlWT_bestfit x y Coef_ControlWTindexing

for k = 1:1:length(Columns_of_interest)
    n = Columns_of_interest(k);

    y = filtered_data_new.ControlWTPre.WindSpeed(idx_ControlWTPre_NacPos{n})';
    x = filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_NacPos{n})';

    if SELECT_Fitting_Technique == 1

        coefficients_vt2 = polyfit(x, y, 3);
        xFit = linspace(0, base_kW*1.05, 1000);
        yFit = polyval(coefficients_vt2 , xFit);
        Coef_ControlWTindexing{k}=coefficients_vt2;

    elseif SELECT_Fitting_Technique == 2

        % slmengine function for piecewise linear
        slm = slmengine(x, y,'plot','off','kn',power_edges(1):pow_separation_per_bin:power_edges(end),'deg',1);

        slmcoef_ControlWTindexing{k} = slm.coef;
        % slmcoef{k}(end)=25; %%% <<<<<<<<<<<<< MANUAL OVERRIDE OF FINAL "POINT OF BEST FIT"

        % Using interp1 as a lookup table for the xFit and yfits
        xFit = linspace(0, base_kW*1.05, 1000);
        yFit = interp1(power_edges, slmcoef_ControlWTindexing{k}',xFit);

    end

    if SELECT_Fitting_Technique == 1
        U_ControlWT_bestfit{k} = polyval(Coef_ControlWTindexing{k},x);
    elseif SELECT_Fitting_Technique == 2
        U_ControlWT_bestfit{k} = interp1(power_edges, slmcoef_ControlWTindexing{k}',x);
    end

    figure(17)
    plot(x, filtered_data_new.ControlWTPre.WindSpeed(idx_ControlWTPre_NacPos{n}),'.')
    hold on
    plot(xFit, yFit,'r','LineWidth',1)
    hold off
    grid on
    ylabel 'U (Control turbine) [m/s]'
    xlabel 'P_T [W]'
    title 'Inverted power curve P_T to U_{ControlWT}'
end

figure(18)
plot(U_ControlWT_bestfit{1},filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_NacPos{Columns_of_interest(1)})/base_kW,'.')
hold on
for k = 2:length(Columns_of_interest)
    plot(U_ControlWT_bestfit{k},filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_NacPos{Columns_of_interest(k)})/base_kW,'.')
end
hold off
grid on
xlabel 'U_{T meas} [m/s]'
ylabel 'P_{T meas} [pu]'
title 'Polyfit'


%%


P_plotting = 1:5:2625;

for k = 1:1:length(Columns_of_interest)
    n = Columns_of_interest(k); % ie 270 - 280 degrees

    if SELECT_Fitting_Technique == 1
        VT_for_PTestim{k} = polyval(Coef_ControlWTindexing{k},P_plotting); % Coef_ControlWTindexing
        P_T_estimated{k} = P_plotting*c(k);
        VT_for_PTmeas{k} = polyval(Coef_TestWTindexing{k},P_plotting); % Coef_TestWTindexing
        P_T_meas{k} = P_plotting;    
    elseif SELECT_Fitting_Technique == 2
        VT_for_PTestim{k} = interp1(power_edges, slmcoef_ControlWTindexing{k}',P_plotting);
        P_T_estimated{k} = P_plotting*c(k);
        VT_for_PTmeas{k} = interp1(power_edges, slmcoef_TestWTindexing{k}',P_plotting);
        P_T_meas{k} = P_plotting;  
    end
end


% figure(23)
% plot(VT_for_PTmeas{1},P_T_meas{1},'.') 
% hold on
% for k = 2:1:length(Columns_of_interest)
%     plot(VT_for_PTmeas{k},P_T_meas{k},'.') 
% end
% % % % % 
% set(gca,'ColorOrderIndex',1)
% plot(VT_for_PTestim{1},P_T_estimated{1},'o') 
% for k = 2:1:length(Columns_of_interest)
%     plot(VT_for_PTestim{k},P_T_estimated{k},'o') 
% end
% % % % % 
% hold off
% grid on
% xlabel 'V_T [m/s]'
% ylabel 'P_Testim and P_Tmeas [kW]'
% title 'V_T to P_T for each directional bin'



for k = 1:1:length(Columns_of_interest)


    figure%(24)
    plot(VT_for_PTmeas{k},P_T_meas{k}/base_kW,'--','LineWidth',1)
    hold on
    plot(VT_for_PTestim{k},P_T_estimated{k}/base_kW,'-.','LineWidth',1)
    hold off
    grid on
    xlabel 'VT [m/s]'
    ylabel 'P_{Testim} and P_{Tmeas} [pu]'

    str = sprintf('V_T to P_T for nacelle directional bin %d to %d ', nacelle_pos_edges(Columns_of_interest(k)), nacelle_pos_edges(Columns_of_interest(k)+1));
    title(str)

    % title 'V_T to P_T for each directional bin'
    legend 'PT measured' 'PT estimated' location northwest

end

%% Just checking that 'Yaw Pos' 'Sc yaw Pos' 'Nacelle Dir' are the same (they are)

% clc
% 
%     data.ControlWTPre.Yaw_Pos = tblSCTurbine.wtc_YawPos_mean(idx_control_tbl_turbine_PRE)';
%     data.ControlWTPre.ScYaw_Pos = tblSCTurbine.wtc_ScYawPos_mean(idx_control_tbl_turbine_PRE)';
%     data.ControlWTPost.Yaw_Pos = tblSCTurbine.wtc_YawPos_mean(idx_control_tbl_turbine_POST)';
%     data.ControlWTPost.ScYaw_Pos = tblSCTurbine.wtc_ScYawPos_mean(idx_control_tbl_turbine_POST)';
%     data.TestWTPre.Yaw_Pos = tblSCTurbine.wtc_YawPos_mean(idx_test_tbl_turbine_PRE)';
%     data.TestWTPre.ScYaw_Pos = tblSCTurbine.wtc_ScYawPos_mean(idx_test_tbl_turbine_PRE)';
%     data.TestWTPost.Yaw_Pos = tblSCTurbine.wtc_YawPos_mean(idx_test_tbl_turbine_POST)';
%     data.TestWTPost.ScYaw_Pos = tblSCTurbine.wtc_ScYawPos_mean(idx_test_tbl_turbine_POST)';
% 
% 
% 
% figure(110)
% plot(data.ControlWTPre.Time, wrapTo360(data.ControlWTPre.Yaw_Pos))
% hold on
% plot(data.ControlWTPre.Time, wrapTo360(data.ControlWTPre.ScYaw_Pos),'--')
% plot(data.ControlWTPre.Time, wrapTo360(data.ControlWTPre.DirectionNacelle),':')
% hold off
% grid on
% grid minor
% legend 'Yaw Pos' 'Sc yaw Pos' 'Nacelle Dir'
% title 'Control Pre'

%% 

% Stuff below probably wrong but kept until we can be sure! 

%  Commented out on 1/9/23

%% Baseline power curves VT PT

% % Much the same as the previous section
% 
% clc; clear VT
% 
% PT_clean = 1:2625;
% 
% for k = 1:1:length(Columns_of_interest)
%     n = Columns_of_interest(k); % ie 270 - 280 degrees
% 
%     if SELECT_Fitting_Technique == 1
%         VT_clean{k} = polyval(Coef_TestWTindexing{k} , PT_clean);
%         VT{k} = polyval(Coef_TestWTindexing{k} , P_TestWT_estimated{k});
%     elseif SELECT_Fitting_Technique == 2
%         VT_clean{k} = interp1(power_edges, slmcoef_TestWTindexing{k}',PT_clean);
%         VT{k} = interp1(power_edges, slmcoef_TestWTindexing{k}',P_TestWT_estimated{k});
%     end
% end
% 
% figure(19)
% plot(VT{1},P_TestWT_estimated{1},'o')
% hold on
% for k = 2:length(Columns_of_interest)
% plot(VT{k},P_TestWT_estimated{k},'o')
% end
% % % % 
% set(gca,'ColorOrderIndex',1)
% % % % 
% plot(VT_clean{1},PT_clean,'LineWidth',1)
% for k = 2:length(Columns_of_interest)
% plot(VT_clean{k},PT_clean,'LineWidth',1)
% end
% hold off
% grid on
% xlabel 'VT [m/s]'
% ylabel 'P_T [kW]'
% title 'V_T to P_T for each directional bin'
% 
% 
% %% Replicating figure from WindGuard slide 13 (VT versus PTmeasured) (training period only)
% 
% % PTmeas is extracted using the same indices as VT, that is to say idx_ControlWTPre_NacPos
% 
% clc
% clear x PTmeas VT_new
% 
% for k = 1:1:length(Columns_of_interest)
%     n = Columns_of_interest(k); % ie 270 - 280 degrees
%     PTmeas{k} = filtered_data_new.TestWTPre.PowerActive(idx_ControlWTPre_NacPos{n}); 
% end
% 
% figure(21)
% plot(VT{1},PTmeas{1},'.') 
% hold on
% for k = 2:1:length(Columns_of_interest)
%     plot(VT{k},PTmeas{k},'.') 
% end
% hold off
% grid on
% xlabel 'V_T [m/s]'
% ylabel 'P_{Tmeas} [kW]'
% 
% %% Obtain power curve using both PTmeasured and PTestimated
% 
% % Step 1: Repeat piecewise linear fit for PTmeasured
% % Step 2: Plot power curves for: 
%     % PC reproduced: VT / P_Tmeas (LINE OF BEST FIT)
%     % PC assumed: VT / P_TestWT_estimated{k}
% 
% 
% for k = 1:1:length(Columns_of_interest)
%     n = Columns_of_interest(k);
% 
%     y = VT{k}';
%     x = PTmeas{k}';
% 
%     if SELECT_Fitting_Technique == 1
% 
%         coefficients_vt2 = polyfit(x, y, 3);
%         xFit = linspace(0, base_kW*1.05, 1000);
%         yFit = polyval(coefficients_vt2 , xFit);
%         Coef_VT_PMeas{k}=coefficients_vt2;
% 
%     elseif SELECT_Fitting_Technique == 2
% 
%         % slmengine function for piecewise linear
%         slm = slmengine(x, y,'plot','off','kn',power_edges(1):pow_separation_per_bin:power_edges(end),'deg',1);
% 
%         slmcoef_VT_PMeas{k} = slm.coef;
%         slmcoef_VT_PMeas{k}(end)=25; %%% <<<<<<<<<<<<< MANUAL OVERRIDE OF FINAL "POINT OF BEST FIT"
% 
%         % Using interp1 as a lookup table for the xFit and yfits
%         xFit = linspace(0, base_kW*1.05, 1000);
%         yFit = interp1(power_edges, slmcoef_VT_PMeas{k}',xFit);
% 
%     end
% 
%     if SELECT_Fitting_Technique == 1
%         U_TestWT_bestfit{k} = polyval(Coef_TestWTindexing{k},x);
%     elseif SELECT_Fitting_Technique == 2
%         U_TestWT_bestfit{k} = interp1(power_edges, slmcoef_VT_PMeas{k}',x);
%     end
% 
%     figure(22)
%     plot(x, y,'.')
%     hold on
%     plot(xFit, yFit,'r','LineWidth',1)
%     hold off
%     grid on
%     ylabel 'V_T [m/s]'
%     xlabel 'P_{Tmeas} [kW]'
%     title 'Checking best fit of inverse power curve P_{Tmeas} to V_T'
% 
% end
% 
% %%
% 
% for k = 1:1:length(Columns_of_interest)
%     n = Columns_of_interest(k); % ie 270 - 280 degrees
% 
%     if SELECT_Fitting_Technique == 1
%         VT_for_PTestim_clean{k} = polyval(Coef_TestWTindexing{k},PT_clean);
%         VT_for_PTmeas_clean{k} = polyval(Coef_VT_PMeas{k},PT_clean);
%     elseif SELECT_Fitting_Technique == 2
%         VT_for_PTestim_clean{k} = interp1(power_edges, slmcoef_TestWTindexing{k}',PT_clean);
%         VT_for_PTmeas_clean{k} = interp1(power_edges, slmcoef_VT_PMeas{k}',PT_clean);
%     end
% end
% 
% 
% % figure(23)
% % plot(VT{1},PTmeas{1},'.') 
% % hold on
% % for k = 2:1:length(Columns_of_interest)
% %     plot(VT{k},PTmeas{k},'.') 
% % end
% % % % % % 
% % set(gca,'ColorOrderIndex',1)
% % plot(VT{1},P_TestWT_estimated{1},'.') 
% % for k = 2:1:length(Columns_of_interest)
% %     plot(VT{k},P_TestWT_estimated{k},'.') 
% % end
% % % % % % 
% % hold off
% % grid on
% % xlabel 'V_T [m/s]'
% % ylabel 'P_{T} [kW]'
% 
% 
% 
% figure(23)
% plot(VT_for_PTestim_clean{1},PT_clean,'--','LineWidth',1)
% hold on
% for k = 2:length(Columns_of_interest)
% plot(VT_for_PTestim_clean{k},PT_clean,'--','LineWidth',1)
% end
% % % % % 
% set(gca,'ColorOrderIndex',1)
% % % % % 
% plot(VT_for_PTmeas_clean{1},PT_clean,'-.','LineWidth',1)
% for k = 2:length(Columns_of_interest)
% plot(VT_for_PTmeas_clean{k},PT_clean,'-.','LineWidth',1)
% end
% hold off
% grid on
% xlabel 'VT [m/s]'
% ylabel 'P_Testim and P_Tmeas [kW]'
% title 'V_T to P_T for each directional bin'
% 
% 
% %%
% 
% for k = 1:1:length(Columns_of_interest)
% 
% 
%     figure(24)
%     plot(VT_for_PTestim_clean{k},PT_clean,'--','LineWidth',1)
%     hold on
%     plot(VT_for_PTmeas_clean{k},PT_clean,'-.','LineWidth',1)
%     hold off
%     grid on
%     xlabel 'VT [m/s]'
%     ylabel 'P_{Testim} and P_{Tmeas} [kW]'
% 
%     str = sprintf('V_T to P_T for nacelle directional bin %d to %d ', nacelle_pos_edges(Columns_of_interest(k)), nacelle_pos_edges(Columns_of_interest(k)+1));
%     title(str)
% 
%     % title 'V_T to P_T for each directional bin'
%     legend 'PT estimated' 'PT measured' location northwest
% 
% end
% 
% 

