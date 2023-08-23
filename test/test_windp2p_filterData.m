% test_windp2p_filterData
clear % Sorry Richard will remove this before sharing!
clc

% %% Data selection

% SELECT_DATA = 'dummy'; % 'dummy' 'Cubico' or 'Nordic" (Nordic = Nordic wind tec)
% SELECT_DATA = 'Cubic'; % Cubico Middlewick
% SELECT_DATA = 'Nordi';
SELECT_DATA = 'Lisse'; % Ventient Lisset Airfield

% Note: Cubico has Senvion mm82m, Senvion mm92, and Siemens 2.3 101 turbines

PlotInputData = 0; % To plot input timeseries data = 1

if SELECT_DATA == 'dummy'

    data = FCN_dummy_data(PlotInputData);

elseif SELECT_DATA == 'Cubic'
    
    folder = fullfile(nextcloud_dir(), 'Field-Data', 'wind', 'Cubico');
    
    % Select data fields of interest (Column 1 = new names, Column 2 = nc file names)
    data_mapping = {'Time',                 'TimeStamp'; ...
                    'OmegaRotor',           'Rotor speed';...
                    'RPM',                  'Generator RPM'
                    'PowerActive',          'Power';...
                    'TemperatureExternal',  'Ambient temperature';...
                    'PitchAngleA',          'Blade angle (pitch position) A';...
                    'PitchAngleB',          'Blade angle (pitch position) B';...
                    'PitchAngleC',          'Blade angle (pitch position) C';...
                    'DirectionNacelle',     'Nacelle position';...
                    'WindSpeed',            'Wind speed';...
                    'ErrorCode',            'ErrorCode';... % ErrorCode seems to corrolate with dips in power
                    'WpsStatus',            'WpsStatus';...% WpsStatus seems to corrolate with shut downs
                    'WTOperationState',     'WTOperationState';% WTOperationState seems to corrolate with dips in power
                    'ProductionFactor',     'Production Factor';% ProductionFactor is unclear but much more variable
                    };

    % Names of all available turbines
    WTs = string(['Cubico_Middlewick_WTG_1_10min_2022';...
        'Cubico_Middlewick_WTG_2_10min_2022';...
        'Cubico_Middlewick_WTG_3_10min_2022';...
        'Cubico_Middlewick_WTG_4_10min_2022';...
        'Cubico_Middlewick_WTG_5_10min_2022';...
        'Cubico_Middlewick_WTG_6_10min_2022';...
        'Cubico_Middlewick_WTG_7_10min_2022';...
        'Cubico_Middlewick_WTG_8_10min_2022';...
        'Cubico_Middlewick_WTG_9_10min_2022']);
    
    % Selection of turbine pairs
    SELECT_Control_WT = WTs(3);
    SELECT_Test_WT = WTs(6);

    % Concatonate and separate pre mod and post mod (approx 3/4 of data for pre mod and 1/4 for post mod)
    [data.ControlWTPre, infoCWTpre] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                              'FilePrefix', SELECT_Control_WT, ...
                                              'Ext', ".nc", ...
                                              'Mapping', data_mapping, ...
                                              'Start', datetime(2022,02,08), ...
                                              'Stop', datetime(2022,03,24) ...
                                            );

    [data.TestWTPre, infoTWTpre] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                              'FilePrefix', SELECT_Test_WT, ...
                                              'Ext', ".nc", ...
                                              'Mapping', data_mapping, ...
                                              'Start', datetime(2022,02,08), ...
                                              'Stop', datetime(2022,03,24) ...
                                            ); 
    
    [data.ControlWTPost, infoCWTpost] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                              'FilePrefix', SELECT_Control_WT, ...
                                              'Ext', ".nc", ...
                                              'Mapping', data_mapping, ...
                                              'Start', datetime(2022,03,25), ...
                                              'Stop', datetime(2022,04,06) ...
                                            );

    [data.TestWTPost, infoTWTpost] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                              'FilePrefix', SELECT_Test_WT, ...
                                              'Ext', ".nc", ...
                                              'Mapping', data_mapping, ...
                                              'Start', datetime(2022,03,25), ...
                                              'Stop', datetime(2022,04,06) ...
                                            ); 

    data.ControlWTPre.Time=data.ControlWTPre.Time{1,1}';
    data.ControlWTPost.Time=data.ControlWTPost.Time{1,1}';
    data.TestWTPre.Time=data.TestWTPre.Time{1,1}';
    data.TestWTPost.Time=data.TestWTPost.Time{1,1}';

    data.ControlWTPre.OmegaRotor=data.ControlWTPre.OmegaRotor';
    data.ControlWTPre.RPM=data.ControlWTPre.RPM';
    data.ControlWTPre.PowerActive=data.ControlWTPre.PowerActive';
    data.ControlWTPre.TemperatureExternal=data.ControlWTPre.TemperatureExternal';
    data.ControlWTPre.PitchAngleA=data.ControlWTPre.PitchAngleA';
    data.ControlWTPre.PitchAngleB=data.ControlWTPre.PitchAngleB';
    data.ControlWTPre.PitchAngleC=data.ControlWTPre.PitchAngleC';
    data.ControlWTPre.DirectionNacelle=data.ControlWTPre.DirectionNacelle';
    data.ControlWTPre.WindSpeed=data.ControlWTPre.WindSpeed';
    data.ControlWTPre.ErrorCode=data.ControlWTPre.ErrorCode';
    data.ControlWTPre.WpsStatus=data.ControlWTPre.WpsStatus';
    data.ControlWTPre.WTOperationState=data.ControlWTPre.WTOperationState';
    data.ControlWTPre.ProductionFactor=data.ControlWTPre.ProductionFactor';

    data.ControlWTPost.OmegaRotor=data.ControlWTPost.OmegaRotor';
    data.ControlWTPost.RPM=data.ControlWTPost.RPM';
    data.ControlWTPost.PowerActive=data.ControlWTPost.PowerActive';
    data.ControlWTPost.TemperatureExternal=data.ControlWTPost.TemperatureExternal';
    data.ControlWTPost.PitchAngleA=data.ControlWTPost.PitchAngleA';
    data.ControlWTPost.PitchAngleB=data.ControlWTPost.PitchAngleB';
    data.ControlWTPost.PitchAngleC=data.ControlWTPost.PitchAngleC';
    data.ControlWTPost.DirectionNacelle=data.ControlWTPost.DirectionNacelle';
    data.ControlWTPost.WindSpeed=data.ControlWTPost.WindSpeed';
    data.ControlWTPost.ErrorCode=data.ControlWTPost.ErrorCode';
    data.ControlWTPost.WpsStatus=data.ControlWTPost.WpsStatus';
    data.ControlWTPost.WTOperationState=data.ControlWTPost.WTOperationState';
    data.ControlWTPost.ProductionFactor=data.ControlWTPost.ProductionFactor';

    data.TestWTPre.OmegaRotor=data.TestWTPre.OmegaRotor';
    data.TestWTPre.RPM=data.TestWTPre.RPM';
    data.TestWTPre.PowerActive=data.TestWTPre.PowerActive';
    data.TestWTPre.TemperatureExternal=data.TestWTPre.TemperatureExternal';
    data.TestWTPre.PitchAngleA=data.TestWTPre.PitchAngleA';
    data.TestWTPre.PitchAngleB=data.TestWTPre.PitchAngleB';
    data.TestWTPre.PitchAngleC=data.TestWTPre.PitchAngleC';
    data.TestWTPre.DirectionNacelle=data.TestWTPre.DirectionNacelle';
    data.TestWTPre.WindSpeed=data.TestWTPre.WindSpeed';
    data.TestWTPre.ErrorCode=data.TestWTPre.ErrorCode';
    data.TestWTPre.WpsStatus=data.TestWTPre.WpsStatus';
    data.TestWTPre.WTOperationState=data.TestWTPre.WTOperationState';
    data.TestWTPre.ProductionFactor=data.TestWTPre.ProductionFactor';
    
    data.TestWTPost.OmegaRotor=data.TestWTPost.OmegaRotor';
    data.TestWTPost.RPM=data.TestWTPost.RPM';
    data.TestWTPost.PowerActive=data.TestWTPost.PowerActive';
    data.TestWTPost.TemperatureExternal=data.TestWTPost.TemperatureExternal';
    data.TestWTPost.PitchAngleA=data.TestWTPost.PitchAngleA';
    data.TestWTPost.PitchAngleB=data.TestWTPost.PitchAngleB';
    data.TestWTPost.PitchAngleC=data.TestWTPost.PitchAngleC';
    data.TestWTPost.DirectionNacelle=data.TestWTPost.DirectionNacelle';
    data.TestWTPost.WindSpeed=data.TestWTPost.WindSpeed';
    data.TestWTPost.ErrorCode=data.TestWTPost.ErrorCode';
    data.TestWTPost.WpsStatus=data.TestWTPost.WpsStatus';
    data.TestWTPost.WTOperationState=data.TestWTPost.WTOperationState';
    data.TestWTPost.ProductionFactor=data.TestWTPost.ProductionFactor';

    DateTimeControlWTPre=datetime(1970,1,1,0,0,data.ControlWTPre.Time);
    DateTimeControlWTPost=datetime(1970,1,1,0,0,data.ControlWTPost.Time);


elseif SELECT_DATA == 'Nordi'

    % placeholder

elseif SELECT_DATA == 'Lisse'
    
    folder = 'C:\Users\mkervyn\Documents\MATLAB\Ventient_data';
    
    % Select data fields of interest (Column 1 = new names, Column 2 = nc file names)
    data_mapping = {'Time',                 'TimeStamp'; ...
                    'OmegaRotor',           'Rotor speed';...
                    'RPM',                  'Generator RPM'
                    'PowerActive',          'Power';...
                    'TemperatureExternal',  'Ambient temperature';...
                    'PitchAngleA',          'Blade angle (pitch position) A';...
                    'PitchAngleB',          'Blade angle (pitch position) B';...
                    'PitchAngleC',          'Blade angle (pitch position) C';...
                    'DirectionNacelle',     'Nacelle position';...
                    'WindSpeed',            'Wind speed';...
                    'WindDirection',        'Wind direction';...
                    ...'ErrorCode',            'ErrorCode';... % ErrorCode seems to corrolate with dips in power
                    ...'WpsStatus',            'WpsStatus';...% WpsStatus seems to corrolate with shut downs
                    ...'WTOperationState',     'WTOperationState';% WTOperationState seems to corrolate with dips in power
                    ... 'ProductionFactor',     'Production Factor';% ProductionFactor is unclear but much more variable
                    };

    % Names of all available turbines
    WTs = string(['Ventient_Lissett-Airfield_WTG_103_30s_';...
        'Ventient_Lissett-Airfield_WTG_104_30s_';...
        'Ventient_Lissett-Airfield_WTG_105_30s_';...
        'Ventient_Lissett-Airfield_WTG_106_30s_';...
        'Ventient_Lissett-Airfield_WTG_107_30s_';...
        'Ventient_Lissett-Airfield_WTG_108_30s_';...
        'Ventient_Lissett-Airfield_WTG_109_30s_';...
        'Ventient_Lissett-Airfield_WTG_110_30s_';...
        'Ventient_Lissett-Airfield_WTG_111_30s_';...
        ]);
    
    % Selection of turbine pairs
    SELECT_Control_WT = WTs(2);
    SELECT_Test_WT = WTs(4);

    % Concatonate and separate pre mod and post mod (approx 3/4 of data for pre mod and 1/4 for post mod)
    [data.ControlWTPre, infoCWTpre] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                              'FilePrefix', SELECT_Control_WT, ...
                                              'Ext', ".nc", ...
                                              'Mapping', data_mapping, ...
                                              'Start', datetime(2023,06,23), ...
                                              'Stop', datetime(2023,07,30) ...
                                            );

    [data.TestWTPre, infoTWTpre] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                              'FilePrefix', SELECT_Test_WT, ...
                                              'Ext', ".nc", ...
                                              'Mapping', data_mapping, ...
                                              'Start', datetime(2023,06,23), ...
                                              'Stop', datetime(2023,07,30) ...
                                            ); 
    
    [data.ControlWTPost, infoCWTpost] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                              'FilePrefix', SELECT_Control_WT, ...
                                              'Ext', ".nc", ...
                                              'Mapping', data_mapping, ...
                                              'Start', datetime(2023,08,1), ...
                                              'Stop', datetime(2023,08,30) ...
                                            );

    [data.TestWTPost, infoTWTpost] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                              'FilePrefix', SELECT_Test_WT, ...
                                              'Ext', ".nc", ...
                                              'Mapping', data_mapping, ...
                                              'Start', datetime(2023,08,1), ...
                                              'Stop', datetime(2023,08,30) ...
                                            ); 

    data.ControlWTPre.Time=data.ControlWTPre.Time{1,1}';
    data.ControlWTPost.Time=data.ControlWTPost.Time{1,1}';
    data.TestWTPre.Time=data.TestWTPre.Time{1,1}';
    data.TestWTPost.Time=data.TestWTPost.Time{1,1}';

    data.ControlWTPre.OmegaRotor=data.ControlWTPre.OmegaRotor';
    data.ControlWTPre.RPM=data.ControlWTPre.RPM';
    data.ControlWTPre.PowerActive=data.ControlWTPre.PowerActive';
    data.ControlWTPre.TemperatureExternal=data.ControlWTPre.TemperatureExternal';
    data.ControlWTPre.PitchAngleA=data.ControlWTPre.PitchAngleA';
    data.ControlWTPre.PitchAngleB=data.ControlWTPre.PitchAngleB';
    data.ControlWTPre.PitchAngleC=data.ControlWTPre.PitchAngleC';
    data.ControlWTPre.DirectionNacelle=data.ControlWTPre.DirectionNacelle';
    data.ControlWTPre.WindSpeed=data.ControlWTPre.WindSpeed';
    data.ControlWTPre.WindDirection=data.ControlWTPre.WindDirection';
    % data.ControlWTPre.ErrorCode=data.ControlWTPre.ErrorCode';
    % data.ControlWTPre.WpsStatus=data.ControlWTPre.WpsStatus';
    % data.ControlWTPre.WTOperationState=data.ControlWTPre.WTOperationState';
    % data.ControlWTPre.ProductionFactor=data.ControlWTPre.ProductionFactor';

    data.ControlWTPost.OmegaRotor=data.ControlWTPost.OmegaRotor';
    data.ControlWTPost.RPM=data.ControlWTPost.RPM';
    data.ControlWTPost.PowerActive=data.ControlWTPost.PowerActive';
    data.ControlWTPost.TemperatureExternal=data.ControlWTPost.TemperatureExternal';
    data.ControlWTPost.PitchAngleA=data.ControlWTPost.PitchAngleA';
    data.ControlWTPost.PitchAngleB=data.ControlWTPost.PitchAngleB';
    data.ControlWTPost.PitchAngleC=data.ControlWTPost.PitchAngleC';
    data.ControlWTPost.DirectionNacelle=data.ControlWTPost.DirectionNacelle';
    data.ControlWTPost.WindSpeed=data.ControlWTPost.WindSpeed';
    data.ControlWTPost.WindDirection=data.ControlWTPost.WindDirection';
    % data.ControlWTPost.ErrorCode=data.ControlWTPost.ErrorCode';
    % data.ControlWTPost.WpsStatus=data.ControlWTPost.WpsStatus';
    % data.ControlWTPost.WTOperationState=data.ControlWTPost.WTOperationState';
    % data.ControlWTPost.ProductionFactor=data.ControlWTPost.ProductionFactor';

    data.TestWTPre.OmegaRotor=data.TestWTPre.OmegaRotor';
    data.TestWTPre.RPM=data.TestWTPre.RPM';
    data.TestWTPre.PowerActive=data.TestWTPre.PowerActive';
    data.TestWTPre.TemperatureExternal=data.TestWTPre.TemperatureExternal';
    data.TestWTPre.PitchAngleA=data.TestWTPre.PitchAngleA';
    data.TestWTPre.PitchAngleB=data.TestWTPre.PitchAngleB';
    data.TestWTPre.PitchAngleC=data.TestWTPre.PitchAngleC';
    data.TestWTPre.DirectionNacelle=data.TestWTPre.DirectionNacelle';
    data.TestWTPre.WindSpeed=data.TestWTPre.WindSpeed';
    data.TestWTPre.WindDirection=data.TestWTPre.WindDirection';
    % data.TestWTPre.ErrorCode=data.TestWTPre.ErrorCode';
    % data.TestWTPre.WpsStatus=data.TestWTPre.WpsStatus';
    % data.TestWTPre.WTOperationState=data.TestWTPre.WTOperationState';
    % data.TestWTPre.ProductionFactor=data.TestWTPre.ProductionFactor';

    data.TestWTPost.OmegaRotor=data.TestWTPost.OmegaRotor';
    data.TestWTPost.RPM=data.TestWTPost.RPM';
    data.TestWTPost.PowerActive=data.TestWTPost.PowerActive';
    data.TestWTPost.TemperatureExternal=data.TestWTPost.TemperatureExternal';
    data.TestWTPost.PitchAngleA=data.TestWTPost.PitchAngleA';
    data.TestWTPost.PitchAngleB=data.TestWTPost.PitchAngleB';
    data.TestWTPost.PitchAngleC=data.TestWTPost.PitchAngleC';
    data.TestWTPost.DirectionNacelle=data.TestWTPost.DirectionNacelle';
    data.TestWTPost.WindSpeed=data.TestWTPost.WindSpeed';
    data.TestWTPost.WindDirection=data.TestWTPost.WindDirection';
    % data.TestWTPost.ErrorCode=data.TestWTPost.ErrorCode';
    % data.TestWTPost.WpsStatus=data.TestWTPost.WpsStatus';
    % data.TestWTPost.WTOperationState=data.TestWTPost.WTOperationState';
    % data.TestWTPost.ProductionFactor=data.TestWTPost.ProductionFactor';

    DateTimeTestWTPre=datetime(1970,1,1,0,0,data.TestWTPre.Time);
    DateTimeTestWTPost=datetime(1970,1,1,0,0,data.TestWTPost.Time);
    DateTimeControlWTPre=datetime(1970,1,1,0,0,data.ControlWTPre.Time);
    DateTimeControlWTPost=datetime(1970,1,1,0,0,data.ControlWTPost.Time);

else
    error('Incompatible data selection')
end


%% Plot input data

% Finding values that are sampled at the same time for both turbines
[data.TestWTPre.Time,data.TestWTPre.idx]=intersect(data.TestWTPre.Time,data.ControlWTPre.Time);
[data.ControlWTPre.Time,data.ControlWTPre.idx]=intersect(data.ControlWTPre.Time,data.TestWTPre.Time);

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
% data.ControlWTPre.ErrorCode = data.ControlWTPre.ErrorCode(data.ControlWTPre.idx);
% data.ControlWTPre.WpsStatus = data.ControlWTPre.WpsStatus(data.ControlWTPre.idx);
% data.ControlWTPre.WTOperationState = data.ControlWTPre.WTOperationState(data.ControlWTPre.idx);
% data.ControlWTPre.ProductionFactor = data.ControlWTPre.ProductionFactor(data.ControlWTPre.idx);
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
% data.TestWTPre.ErrorCode = data.TestWTPre.ErrorCode(data.TestWTPre.idx);
% data.TestWTPre.WpsStatus = data.TestWTPre.WpsStatus(data.TestWTPre.idx);
% data.TestWTPre.WTOperationState = data.TestWTPre.WTOperationState(data.TestWTPre.idx);
% data.TestWTPre.ProductionFactor = data.TestWTPre.ProductionFactor(data.TestWTPre.idx);
data.TestWTPre.WindDirection = data.TestWTPre.WindDirection(data.TestWTPre.idx);

DateTimeTestWTPre=datetime(1970,1,1,0,0,data.TestWTPre.Time);
DateTimeTestWTPost=datetime(1970,1,1,0,0,data.TestWTPost.Time);
DateTimeControlWTPre=datetime(1970,1,1,0,0,data.ControlWTPre.Time);
DateTimeControlWTPost=datetime(1970,1,1,0,0,data.ControlWTPost.Time);

clc

figure(1)
ax1=subplot(5,2,1);
plot(DateTimeControlWTPre,data.ControlWTPre.RPM,'*r')
hold on
plot(DateTimeTestWTPre,data.TestWTPre.RPM,'ob')
hold off
grid on
legend ControlWTPre TestWTPre 
ylabel 'RPM'
title 'LHS: Pre modification of control turbine'
ax2=subplot(5,2,2);
plot(DateTimeControlWTPost,data.ControlWTPost.RPM,'+r')
hold on
plot(DateTimeTestWTPost,data.TestWTPost.RPM,'sqb')
hold off
legend ControlWTPost TestWTPost
grid on
title 'RHS: Post modification of control turbine'

ax3=subplot(5,2,3);
plot(DateTimeControlWTPre,data.ControlWTPre.PowerActive,'*r')
hold on
plot(DateTimeTestWTPre,data.TestWTPre.PowerActive,'ob')
hold off
grid on
ylabel 'Active Power [W]'
ax4=subplot(5,2,4);
plot(DateTimeControlWTPost,data.ControlWTPost.PowerActive,'+r')
hold on
plot(DateTimeTestWTPost,data.TestWTPost.PowerActive,'sqb')
hold off
grid on

ax5=subplot(5,2,5);
plot(DateTimeControlWTPre,data.ControlWTPre.TemperatureExternal,'*r')
hold on
plot(DateTimeTestWTPre,data.TestWTPre.TemperatureExternal,'ob')
hold off
grid on
ylabel 'Temp Ext [^{\circ}]'
ylim([0 15])
ax6=subplot(5,2,6);
plot(DateTimeControlWTPost,data.ControlWTPost.TemperatureExternal,'+r')
hold on
plot(DateTimeTestWTPost,data.TestWTPost.TemperatureExternal,'sqb')
hold off
grid on
ylim([0 15])

ax7=subplot(5,2,7);
plot(DateTimeControlWTPre,data.ControlWTPre.DirectionNacelle,'*r')
hold on
plot(DateTimeTestWTPre,data.TestWTPre.DirectionNacelle,'ob')
hold off
grid on
ylabel 'Dir Nacelle [^{\circ}]'
ax8=subplot(5,2,8);
plot(DateTimeControlWTPost,data.ControlWTPost.DirectionNacelle,'+r')
hold on
plot(DateTimeTestWTPost,data.TestWTPost.DirectionNacelle,'sqb')
hold off
grid on

ax9=subplot(5,2,9);
plot(DateTimeControlWTPre,data.ControlWTPre.WindSpeed,'*r')
hold on
plot(DateTimeTestWTPre,data.TestWTPre.WindSpeed,'ob')
hold off
grid on
ylabel 'Wind Sp [m/s]'
ax10=subplot(5,2,10);
plot(DateTimeControlWTPost,data.ControlWTPost.WindSpeed,'+r')
hold on
plot(DateTimeTestWTPost,data.TestWTPost.WindSpeed,'sqb')
hold off
grid on


linkaxes([ax1 ax3 ax5 ax7 ax9],'x')
linkaxes([ax2 ax4 ax6 ax8 ax10],'x')
% xlim([     min([data.ControlWTPost.Time(1) data.TestWTPost.Time(1)]) 
%     max([data.ControlWTPost.Time(end) data.TestWTPost.Time(end)])    ])



sgtitle 'Comparing Control and Test turbines '

%% Consistency of Turbine Settings




%% Northing


degree_separation_per_bin = 4;% degrees
No_threshold_direction = 360/degree_separation_per_bin+1;
nacelle_direction_edges = linspace(0, 360, No_threshold_direction);

dev1 = data.TestWTPre.DirectionNacelle;
dev2 = data.ControlWTPre.DirectionNacelle;

deviation_raw = wrapTo180(dev1-dev2);

for k=1:(length(nacelle_direction_edges)-1)
    idx_ControlWTPre_WindDir{k}=find((data.ControlWTPre.DirectionNacelle>=nacelle_direction_edges(k)) & (data.ControlWTPre.DirectionNacelle<=nacelle_direction_edges(k+1)));
    idx_TestWTPre_WindDir{k}=find((data.TestWTPre.DirectionNacelle>=nacelle_direction_edges(k)) & (data.TestWTPre.DirectionNacelle<=nacelle_direction_edges(k+1)));
    
    Pow_binned_ControlWTpre(k) = mean(data.ControlWTPre.PowerActive(idx_ControlWTPre_WindDir{k}));
    Pow_binned_TestWTpre(k) = mean(data.TestWTPre.PowerActive(idx_TestWTPre_WindDir{k}));

    U_binned_ControlWTpre(k) = mean(data.ControlWTPre.WindSpeed(idx_ControlWTPre_WindDir{k}));
    U_binned_TestWTpre(k) = mean(data.TestWTPre.WindSpeed(idx_TestWTPre_WindDir{k}));

    deviation(k) = mean(deviation_raw(idx_TestWTPre_WindDir{k}));
end

midpoint = 0.5*((nacelle_direction_edges(1:(No_threshold_direction-1)))+(nacelle_direction_edges(2:(No_threshold_direction))));

% % % CLEARLY SOME OF THIS MEASUREMENTS MUST BE MADE WITH BINNED DATAPOINTS
figure(4)
ax1=subplot(1,2,1);
% plot(data.ControlWTPre.DirectionNacelle,(data.ControlWTPre.PowerActive./data.TestWTPre.PowerActive),'sqr')
plot(midpoint,Pow_binned_ControlWTpre./Pow_binned_TestWTpre,'-sqr')
hold on
% plot(data.ControlWTPre.DirectionNacelle,(data.ControlWTPre.WindSpeed./data.TestWTPre.WindSpeed),'ob')
plot(midpoint,U_binned_ControlWTpre./U_binned_TestWTpre,'-ob')
hold off
grid on
ylabel 'P(control)/P(test), v(control)/v(test)'
% ylim([-0.5 14])
xlabel 'Nacelle Pos [^{\circ}]'
%
ax2=subplot(1,2,2);
yyaxis left
plot(data.TestWTPre.DirectionNacelle,data.ControlWTPre.DirectionNacelle,'xb')
ylim([0 360])
ylabel 'Nacelle Pos Control WT [^{\circ}]'
yyaxis right
% plot(data.TestWTPre.DirectionNacelle,(data.TestWTPre.DirectionNacelle-data.ControlWTPre.DirectionNacelle),'xr')
plot(midpoint,deviation,'-r')
ylim([-30 30]+30)
ylabel 'deviation [^{\circ}]'
grid on
xlabel 'Nacelle Pos Test WT [^{\circ}]'
sgtitle 'Northing (tbc)'
xlim([0 360])

%% Run sync and filter function

% Set out parameters for filtering
% 1) Power
Max_power = max([max(data.ControlWTPre.PowerActive) max(data.ControlWTPost.PowerActive)...
    max(data.TestWTPre.PowerActive) max(data.TestWTPost.PowerActive)]);

% 2) Set out ata Gap Infill Threshold
Datagap_inFill = 3;
Mean_timestep = mean(diff(data.ControlWTPre.Time));

% 3) Set out lower threshold of RPM
lower_threshold_rpm_per_unit = 0.1; 
Max_gen_rpm = max([max(data.ControlWTPre.RPM) max(data.ControlWTPost.RPM)...
    max(data.TestWTPre.RPM) max(data.TestWTPost.RPM)]);

% Set out nacelle direction binning
degree_separation_per_bin = 20;%5;% degrees
No_threshold_direction = 360/degree_separation_per_bin+1;

No_bins = 15;%50;
P_per_bin = Max_power/No_bins;

if SELECT_DATA == 'dummy'
    filtered_data = windp2p.syncAndFilterData(data, 'WindDirectionNumSamplesThresh', 20,'PowerRangeThreshBinSize',500000);
elseif SELECT_DATA == 'Cubic'
    filtered_data = windp2p.syncAndFilterData(data, 'WindDirectionNumSamplesThresh', 50,...
        'WindDirectionThreshNBins',No_threshold_direction,...
        'PowerRangeThreshBinSize',P_per_bin,...
        'SyncronisedTimeStepSize',Mean_timestep,...
        'DataGapInfillThreshold',Mean_timestep*Datagap_inFill,...
        'OperationalRPMThreshold',lower_threshold_rpm_per_unit*Max_gen_rpm);
elseif SELECT_DATA == 'Lisse'
    filtered_data = windp2p.syncAndFilterData(data, 'WindDirectionNumSamplesThresh', 50,...
        'WindDirectionThreshNBins',No_threshold_direction,...
        'PowerRangeThreshBinSize',P_per_bin,...
        'SyncronisedTimeStepSize',Mean_timestep,...
        'DataGapInfillThreshold',Mean_timestep*Datagap_inFill,...
        'OperationalRPMThreshold',lower_threshold_rpm_per_unit*Max_gen_rpm);
end

% Plot results (unfiltered and filtered)



figure(201)
ax1=subplot(4,4,1);
plot(data.ControlWTPre.Time,data.ControlWTPre.RPM,'*r')
hold on
plot(filtered_data.ControlWTPre.Time,filtered_data.ControlWTPre.RPM,'ob')
hold off
grid minor
legend Unfiltered Filtered 
ylabel 'RPM'
% xlim([0 500])
title 'ControlWTPre'
ax5=subplot(4,4,5);
plot(data.ControlWTPre.Time,data.ControlWTPre.PowerActive,'*r')
hold on
plot(filtered_data.ControlWTPre.Time,filtered_data.ControlWTPre.PowerActive,'ob')
hold off
grid minor
ylabel 'P'
% xlim([0 500])
% % % % % 
ax2=subplot(4,4,2);
plot(data.TestWTPre.Time,data.TestWTPre.RPM,'*r')
hold on
plot(filtered_data.TestWTPre.Time,filtered_data.TestWTPre.RPM,'ob')
hold off
grid minor
ylabel 'RPM'
% xlim([0 500])
title 'TestWTPre'
ax6=subplot(4,4,6);
plot(data.TestWTPre.Time,data.TestWTPre.PowerActive,'*r')
hold on
plot(filtered_data.TestWTPre.Time,filtered_data.TestWTPre.PowerActive,'ob')
hold off
grid minor
ylabel 'P'
% xlim([0 500])
% % % % % 
ax3=subplot(4,4,3);
plot(data.ControlWTPost.Time,data.ControlWTPost.RPM,'*r')
hold on
plot(filtered_data.ControlWTPost.Time,filtered_data.ControlWTPost.RPM,'ob')
hold off
grid minor
ylabel 'RPM'
% xlim([0 500]+10000)
title 'ControlWTPost'
ax7=subplot(4,4,7);
plot(data.ControlWTPost.Time,data.ControlWTPost.PowerActive,'*r')
hold on
plot(filtered_data.ControlWTPost.Time,filtered_data.ControlWTPost.PowerActive,'ob')
hold off
grid minor
ylabel 'P'
% xlim([0 500]+10000)
% % % % % 
ax4=subplot(4,4,4);
plot(data.TestWTPost.Time,data.TestWTPost.RPM,'*r')
hold on
plot(filtered_data.TestWTPost.Time,filtered_data.TestWTPost.RPM,'ob')
hold off
grid minor
ylabel 'RPM'
% xlim([0 500]+10000)
title 'TestWTPost'
ax8=subplot(4,4,8);
plot(data.TestWTPost.Time,data.TestWTPost.PowerActive,'*r')
hold on
plot(filtered_data.TestWTPost.Time,filtered_data.TestWTPost.PowerActive,'ob')
hold off
grid minor
ylabel 'P'
% xlim([0 500]+10000)
%
%
ax9=subplot(4,4,9);
plot(data.ControlWTPre.Time,data.ControlWTPre.TemperatureExternal,'*r')
hold on
plot(filtered_data.ControlWTPre.Time,filtered_data.ControlWTPre.TemperatureExternal,'ob')
hold off
grid minor
legend Unfiltered Filtered 
ylabel 'Temp Ext'
% xlim([0 500])
ylim([-5 20])
ax13=subplot(4,4,13);
plot(data.ControlWTPre.Time,data.ControlWTPre.DirectionNacelle,'*r')
hold on
plot(filtered_data.ControlWTPre.Time,filtered_data.ControlWTPre.DirectionNacelle,'ob')
hold off
grid minor
ylabel 'Dir Nacelle'
% xlim([0 500])
% % % % % 
ax10=subplot(4,4,10);
plot(data.TestWTPre.Time,data.TestWTPre.TemperatureExternal,'*r')
hold on
plot(filtered_data.TestWTPre.Time,filtered_data.TestWTPre.TemperatureExternal,'ob')
hold off
grid minor
ylabel 'Temp Ext'
% xlim([0 500])
ylim([-5 20])
ax14=subplot(4,4,14);
plot(data.TestWTPre.Time,data.TestWTPre.DirectionNacelle,'*r')
hold on
plot(filtered_data.TestWTPre.Time,filtered_data.TestWTPre.DirectionNacelle,'ob')
hold off
grid minor
ylabel 'Dir Nacelle'
% xlim([0 500])
% % % % % 
ax11=subplot(4,4,11);
plot(data.ControlWTPost.Time,data.ControlWTPost.TemperatureExternal,'*r')
hold on
plot(filtered_data.ControlWTPost.Time,filtered_data.ControlWTPost.TemperatureExternal,'ob')
hold off
grid minor
ylabel 'Temp Ext'
% xlim([0 500]+10000)
ylim([-5 20])
ax15=subplot(4,4,15);
plot(data.ControlWTPost.Time,data.ControlWTPost.DirectionNacelle,'*r')
hold on
plot(filtered_data.ControlWTPost.Time,filtered_data.ControlWTPost.DirectionNacelle,'ob')
hold off
grid minor
ylabel 'Dir Nacelle'
% xlim([0 500]+10000)
% % % % % 
ax12=subplot(4,4,12);
plot(data.TestWTPost.Time,data.TestWTPost.TemperatureExternal,'*r')
hold on
plot(filtered_data.TestWTPost.Time,filtered_data.TestWTPost.TemperatureExternal,'ob')
hold off
grid minor
ylabel 'Temp Ext'
% xlim([0 500]+10000)
ylim([-5 20])
ax16=subplot(4,4,16);
plot(data.TestWTPost.Time,data.TestWTPost.DirectionNacelle,'*r')
hold on
plot(filtered_data.TestWTPost.Time,filtered_data.TestWTPost.DirectionNacelle,'ob')
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




%%  Northing filtered data

% Finding values that are sampled at the same time for both turbines
[filtered_data_new.TestWTPre.Time,filtered_data_new.TestWTPre.idx]=intersect(filtered_data.TestWTPre.Time,filtered_data.ControlWTPre.Time);
[filtered_data_new.ControlWTPre.Time,filtered_data_new.ControlWTPre.idx]=intersect(filtered_data.ControlWTPre.Time,filtered_data.TestWTPre.Time);

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
filtered_data_new.TestWTPre.WindDirection = filtered_data.TestWTPre.WindDirection(filtered_data_new.ControlWTPre.idx);
% filtered_data_new.TestWTPre.ErrorCode = filtered_data.TestWTPre.ErrorCode(filtered_data_new.TestWTPre.idx);
% filtered_data_new.TestWTPre.WpsStatus = filtered_data.TestWTPre.WpsStatus(filtered_data_new.TestWTPre.idx);
% filtered_data_new.TestWTPre.WTOperationState = filtered_data.TestWTPre.WTOperationState(filtered_data_new.TestWTPre.idx);
% filtered_data_new.TestWTPre.ProductionFactor = filtered_data.TestWTPre.ProductionFactor(filtered_data_new.TestWTPre.idx);

DateTimeTestWTPreNew=datetime(1970,1,1,0,0,filtered_data_new.TestWTPre.Time);
DateTimeControlWTPre_New=datetime(1970,1,1,0,0,filtered_data_new.ControlWTPre.Time);


degree_separation_per_bin = 4;% degrees
No_threshold_direction = 360/degree_separation_per_bin+1;
nacelle_direction_edges = linspace(0, 360, No_threshold_direction);


% % % % % % % % % % Correcting Nacelle Direction Error Start % % % % % % %

% Make a table where each column is the
% sequencial nacelle direction of each turbine. Then sort for one of the
% turbines. Then compare and calculate error

NacDir_column1_TestWTPre=filtered_data_new.TestWTPre.DirectionNacelle';
NacDir_column2_ControlWTPre=filtered_data_new.ControlWTPre.DirectionNacelle';
Table_NacDir = table(NacDir_column1_TestWTPre,NacDir_column2_ControlWTPre);

Table_NacDir = sortrows(Table_NacDir,'NacDir_column2_ControlWTPre');

Average_error = wrapTo360(Table_NacDir.NacDir_column1_TestWTPre-Table_NacDir.NacDir_column2_ControlWTPre);
Average_error_sum = sum(Average_error)/length(Table_NacDir.NacDir_column2_ControlWTPre);

New_shifted_NacDir_column1 = wrapTo360(Table_NacDir.NacDir_column1_TestWTPre - Average_error_sum);

figure(8)
plot(Table_NacDir.NacDir_column1_TestWTPre,'.')
hold on
plot(New_shifted_NacDir_column1,'.')
plot(Table_NacDir.NacDir_column2_ControlWTPre,'.')
plot(Average_error,'.')
hold off
legend Column1Test 'Column1Test-AverageError' Column2Control Error 
title 'Error in Nacelle Position between two WTs'

filtered_data_new.ControlWTPre.DirectionNacelleCorrected = wrapTo360(filtered_data_new.ControlWTPre.DirectionNacelle + Average_error_sum);

% % % % % % % % % % Correcting Nacelle Direction Error End % % % % % % % %

clear midpoint deviation
midpoint = 0.5*((nacelle_direction_edges(1:(No_threshold_direction-1)))+(nacelle_direction_edges(2:(No_threshold_direction))));

dev1 = filtered_data_new.TestWTPre.DirectionNacelle;
dev2 = filtered_data_new.ControlWTPre.DirectionNacelleCorrected;

deviation_raw = wrapTo180(dev1-dev2);

figure(9)
plot(DateTimeTestWTPreNew,deviation_raw,'.')
ylabel 'Deviation in nacelle direction between WTs'
xlabel DateTime
grid minor

clear Pow_binned_ControlWTpre Pow_binned_TestWTpre U_binned_ControlWTpre U_binned_TestWTpre idx_ControlWTPre_WindDir idx_TestWTPre_WindDir

for k=1:(length(nacelle_direction_edges)-1)
    idx_ControlWTPre_WindDir{k}=find((filtered_data_new.ControlWTPre.DirectionNacelleCorrected>=nacelle_direction_edges(k)) & (filtered_data_new.ControlWTPre.DirectionNacelleCorrected<=nacelle_direction_edges(k+1)));
    idx_TestWTPre_WindDir{k}=find((filtered_data_new.TestWTPre.DirectionNacelle>=nacelle_direction_edges(k)) & (filtered_data_new.TestWTPre.DirectionNacelle<=nacelle_direction_edges(k+1)));
    
    Pow_binned_ControlWTpre(k) = mean(filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_WindDir{k}));
    Pow_binned_TestWTpre(k) = mean(filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_WindDir{k}));

    U_binned_ControlWTpre(k) = mean(filtered_data_new.ControlWTPre.WindSpeed(idx_ControlWTPre_WindDir{k}));
    U_binned_TestWTpre(k) = mean(filtered_data_new.TestWTPre.WindSpeed(idx_TestWTPre_WindDir{k}));

    deviation(k) = mean(deviation_raw(idx_TestWTPre_WindDir{k}));
end


figure(5)
ax1=subplot(1,2,1);
% plot(data.ControlWTPre.DirectionNacelle,(data.ControlWTPre.PowerActive./data.TestWTPre.PowerActive),'sqr')
plot(midpoint,Pow_binned_ControlWTpre./Pow_binned_TestWTpre,'-sqr')
hold on
% plot(data.ControlWTPre.DirectionNacelle,(data.ControlWTPre.WindSpeed./data.TestWTPre.WindSpeed),'ob')
plot(midpoint,U_binned_ControlWTpre./U_binned_TestWTpre,'-ob')
hold off
grid on
ylabel 'P(control)/P(test), v(control)/v(test)'
ylim([-0.5 14])
xlabel 'Nacelle Pos [^{\circ}]'
%
ax2=subplot(1,2,2);
yyaxis left
plot(filtered_data_new.TestWTPre.DirectionNacelle,filtered_data_new.ControlWTPre.DirectionNacelleCorrected,'xb')
ylim([0 360])
ylabel 'Nacelle Pos Control WT [^{\circ}]'
yyaxis right
% plot(data.TestWTPre.DirectionNacelle,(data.TestWTPre.DirectionNacelle-data.ControlWTPre.DirectionNacelle),'xr')
plot(midpoint,deviation,'-r')
ylim([-40 40])
ylabel 'deviation [^{\circ}]'
grid on
xlabel 'Nacelle Pos Test WT [^{\circ}]'
sgtitle 'Northing with filtered data (tbc)'
xlim([0 360])

%% Wind Direction versus Active Power

% % % % % % % % % % Correcting Wind Direction Error Start % % % % % % %

% Make a table where each column is the
% sequencial wind direction of each turbine. Then sort for one of the
% turbines. Then compare and calculate error

WindDir_column1_TestWTPre=filtered_data_new.TestWTPre.WindDirection';
WindDir_column2_ControlWTPre=filtered_data_new.ControlWTPre.WindDirection';
Table_WindDir = table(WindDir_column1_TestWTPre,WindDir_column2_ControlWTPre);

Table_WindDir = sortrows(Table_WindDir,'WindDir_column2_ControlWTPre');

Average_error = wrapTo360(Table_WindDir.WindDir_column1_TestWTPre-Table_WindDir.WindDir_column2_ControlWTPre);
Average_error_wind_sum = sum(Average_error)/length(Table_WindDir.WindDir_column2_ControlWTPre);

New_shifted_WindDir_column1 = wrapTo360(Table_WindDir.WindDir_column1_TestWTPre - Average_error_wind_sum);

figure(10)
plot(Table_WindDir.WindDir_column1_TestWTPre,'.')
hold on
plot(New_shifted_WindDir_column1,'.')
plot(Table_WindDir.WindDir_column2_ControlWTPre,'.')
plot(Average_error,'.')
hold off
legend Column1Test 'Column1Test-AverageError' Column2Control Error 
title 'Error in Wind Direction between two WTs'

filtered_data_new.ControlWTPre.WindDirectionCorrected = wrapTo360(filtered_data_new.ControlWTPre.WindDirection...
    + Average_error_wind_sum); % Wind Direction Error
    ...+ Average_error_sum); % Nacelle Position Error

% % % % % % % % % % Correcting Nacelle Direction Error End % % % % % % % %

degree_separation_per_bin = 2;% degrees

if floor(360/degree_separation_per_bin)==ceil(360/degree_separation_per_bin)
    % do nothing
else
    error ('The size of bins must be a multiple of 360.')
end

No_threshold_direction = 360/degree_separation_per_bin+1;
wind_direction_edges = linspace(0, 360, No_threshold_direction);

clear midpoint_wind deviation
midpoint_wind = 0.5*((wind_direction_edges(1:(No_threshold_direction-1)))+(wind_direction_edges(2:(No_threshold_direction))));

clear Pow_binned_ControlWTpre Pow_binned_TestWTpre ...
    Pow_binned_ControlWTpre_mean ...
    Pow_binned_TestWTpre_mean ...
    U_binned_ControlWTpre U_binned_TestWTpre ...
    idx_ControlWTPre_WindDir idx_TestWTPre_WindDir ...
    Pow_binned_ControlWTpre_min Pow_binned_TestWTpre_min ...
    Pow_binned_ControlWTpre_max Pow_binned_TestWTpre_max ...
    lower_error_ControlWTpre lower_error_TestWTpre ...
    upper_error_ControlWTpre upper_error_TestWTpre

for k=1:(length(wind_direction_edges)-1)
    idx_ControlWTPre_WindDir{k}=find((filtered_data_new.ControlWTPre.WindDirectionCorrected>=wind_direction_edges(k)) & (filtered_data_new.ControlWTPre.WindDirectionCorrected<=wind_direction_edges(k+1)));
    idx_TestWTPre_WindDir{k}=find((filtered_data_new.TestWTPre.WindDirection>=wind_direction_edges(k)) & (filtered_data_new.TestWTPre.WindDirection<=wind_direction_edges(k+1)));
    
    Pow_binned_ControlWTpre_mean(k) = mean(filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_WindDir{k}));
    Pow_binned_TestWTpre_mean(k) = mean(filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_WindDir{k}));

    Pow_binned_ControlWTpre_min(k) = min(filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_WindDir{k}));
    Pow_binned_TestWTpre_min(k) = min(filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_WindDir{k}));

    Pow_binned_ControlWTpre_max(k) = max(filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_WindDir{k}));
    Pow_binned_TestWTpre_max(k) = max(filtered_data_new.TestWTPre.PowerActive(idx_TestWTPre_WindDir{k}));

    % U_binned_ControlWTpre(k) = mean(filtered_data.ControlWTPre.WindSpeed(idx_ControlWTPre_WindDir{k}));
    % U_binned_TestWTpre(k) = mean(filtered_data.TestWTPre.WindSpeed(idx_TestWTPre_WindDir{k}));

    % deviation(k) = mean(deviation_raw(idx_TestWTPre_WindDir{k}));

    lower_error_ControlWTpre(k) = Pow_binned_ControlWTpre_mean(k) - Pow_binned_ControlWTpre_min(k);
    lower_error_TestWTpre(k) = Pow_binned_TestWTpre_mean(k) - Pow_binned_TestWTpre_min(k);

    upper_error_ControlWTpre(k) = Pow_binned_ControlWTpre_max(k) - Pow_binned_ControlWTpre_mean(k);
    upper_error_TestWTpre(k) = Pow_binned_TestWTpre_max(k) - Pow_binned_TestWTpre_mean(k);


end


base_kW = 2500;

figure(6)
errorbar(midpoint_wind,Pow_binned_ControlWTpre_mean/base_kW,lower_error_ControlWTpre/base_kW,upper_error_ControlWTpre/base_kW)
hold on
errorbar(midpoint_wind,Pow_binned_TestWTpre_mean/base_kW,lower_error_TestWTpre/base_kW,upper_error_TestWTpre/base_kW)
hold off
grid on
xlabel 'Wind Direction [^{\circ}]'
ylabel 'Active Power [pu]'
legend 'ControlWTpre' 'TestWTpre'

figure(7)
errorbar(midpoint_wind,Pow_binned_ControlWTpre_mean./Pow_binned_TestWTpre_mean,lower_error_ControlWTpre./upper_error_TestWTpre,upper_error_ControlWTpre./lower_error_TestWTpre)
grid on
xlabel 'Wind Direction [^{\circ}]'
ylabel 'Active Power Ratio [pu]'
title 'Check wind direction with large wake interaction'

%% Power to power relation (wind guard)
clc
degree_separation_per_bin = 10;% degrees

if floor(360/degree_separation_per_bin)==ceil(360/degree_separation_per_bin)
    % do nothing
else
    error ('The size of direction bins must be a multiple of 360.')
end

No_threshold_direction = 360/degree_separation_per_bin+1;
nacelle_pos_edges = linspace(0, 360, No_threshold_direction);

clear midpoint_wind deviation
midpoint_wind = 0.5*((nacelle_pos_edges(1:(No_threshold_direction-1)))+(nacelle_pos_edges(2:(No_threshold_direction))));

clear Pow_binned_ControlWTpre Pow_binned_TestWTpre ...
    Pow_binned_ControlWTpre_mean ...
    Pow_binned_TestWTpre_mean ...
    U_binned_ControlWTpre U_binned_TestWTpre ...
    idx_ControlWTPre_WindDir idx_TestWTPre_WindDir ...
    Pow_binned_ControlWTpre_min Pow_binned_TestWTpre_min ...
    Pow_binned_ControlWTpre_max Pow_binned_TestWTpre_max ...
    lower_error_ControlWTpre lower_error_TestWTpre ...
    upper_error_ControlWTpre upper_error_TestWTpre

base_kW = 2500;

pow_separation_per_bin = 500;% kW

if floor(base_kW/pow_separation_per_bin)==ceil(base_kW/pow_separation_per_bin)
    % do nothing
else
    error ('The size of power bins must be a multiple of 2500.')
end

No_threshold_direction_kW = base_kW/pow_separation_per_bin+1;
power_edges = linspace(0, base_kW, No_threshold_direction_kW);

% add additional bin
power_edges(length(power_edges)+1)=power_edges(end)+pow_separation_per_bin;

% clear midpoint_power
% midpoint_power = 0.5*((power_edges(1:(No_threshold_direction_kW-1)))+(power_edges(2:(No_threshold_direction_kW))));

clear idx_ControlWTPre_Power idx_ControlWTPre_NacPos
for k=1:(length(nacelle_pos_edges)-1)

    idx_ControlWTPre_NacPos{k}=find((filtered_data_new.ControlWTPre.DirectionNacelleCorrected>=nacelle_pos_edges(k)) & (filtered_data_new.ControlWTPre.DirectionNacelleCorrected<=nacelle_pos_edges(k+1)));
    
    % figure(11)
    % plot(DateTimeControlWTPre_New(idx_ControlWTPre_NacPos{k}),filtered_data_new.ControlWTPre.DirectionNacelleCorrected(idx_ControlWTPre_NacPos{k}),'.')
    % grid on
    % str = sprintf('Nacelle Dir bin from %d to %d ', nacelle_pos_edges(k), nacelle_pos_edges(k+1));
    % title(str)

    for n = 1:(length(power_edges)-1)

        idx_ControlWTPre_Power_temp=find((filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_NacPos{k})>=power_edges(n)) & (filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_NacPos{k})<=power_edges(n+1)));
        idx_ControlWTPre_Power{n,k}=idx_ControlWTPre_NacPos{k}(idx_ControlWTPre_Power_temp);

        if ~isempty(idx_ControlWTPre_Power{n,k})
            if length(idx_ControlWTPre_Power{n,k}) < 50
                idx_ControlWTPre_Power{n,k} = [];
            end
        end


        % figure(12)
        % plot(DateTimeControlWTPre_New(idx_ControlWTPre_Power{n,k}),filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_Power{n,k}),'.')
        % grid on
        % str = sprintf('Power bin from %d to %d ', power_edges(n), power_edges(n+1));
        % title(str)

    end

end

%% Testing results

clc
row=6;% power bins
column=20;% nacelle direction bins

Ptest=filtered_data_new.ControlWTPre.PowerActive...
    (idx_ControlWTPre_Power{row,column});

PTEST = [min(Ptest) max(Ptest)]

DirNactest=filtered_data_new.ControlWTPre.DirectionNacelleCorrected...
    (idx_ControlWTPre_Power{row,column});

DNTEST = [min(DirNactest) max(DirNactest)]

%% Now plotting Power-to-power according to WindGuard

for column=1:(length(nacelle_pos_edges)-1)% nacelle direction bins

    for row=1:(length(power_edges)-1)% power bins

    PmeanControlWT(row,column)=mean(filtered_data_new.ControlWTPre.PowerActive(idx_ControlWTPre_Power{row,column}));
    NDmeanControlWT(row,column)=mean(filtered_data_new.ControlWTPre.DirectionNacelleCorrected(idx_ControlWTPre_Power{row,column}));
    PmeanTestWT(row,column)=mean(filtered_data_new.TestWTPre.PowerActive(idx_ControlWTPre_Power{row,column}));
    NDmeanTestWT(row,column)=mean(filtered_data_new.TestWTPre.DirectionNacelle(idx_ControlWTPre_Power{row,column}));

    end

end

% find empty cells
emptyCells = cellfun(@isempty,idx_ControlWTPre_Power);

% ignore columns with empty cells
Column_Sum = sum(emptyCells);
Columns_of_interest=find(Column_Sum==0);


NDmeanControlWT(:,Columns_of_interest)
NDmeanTestWT(:,Columns_of_interest(1))


for k=1:length(Columns_of_interest)
    x=PmeanControlWT(:,Columns_of_interest(k));
    y=PmeanTestWT(:,Columns_of_interest(k));
    
    coefficients = polyfit(x, y, 1);
    xFit = linspace(0, base_kW, 1000);
    yFit = polyval(coefficients , xFit);
    Coef{k}=coefficients;
end

x_axis=[0 3000];

figure(12)
plot(PmeanControlWT(:,Columns_of_interest(1)),PmeanTestWT(:,Columns_of_interest(1)),'.')
hold on
for column=2:length(Columns_of_interest)
    plot(PmeanControlWT(:,Columns_of_interest(column)),PmeanTestWT(:,Columns_of_interest(column)),'.')
end
set(gca,'ColorOrderIndex',1)
plot(x_axis,( x_axis*Coef{1}(1)+Coef{1}(2) )       )
for column=2:length(Columns_of_interest)
    plot(x_axis,( x_axis*Coef{column}(1)+Coef{column}(2) )       )
end
legend 18 19 20 25 26 27 28 29 30 31 32 33
hold off
grid on
xlabel Pcontrol
ylabel Ptest

%% Plot power curve using control turbine pre and post data (ie training and testing data)

Prevailing_wind_column = 28; % ie 270 - 280 degrees











