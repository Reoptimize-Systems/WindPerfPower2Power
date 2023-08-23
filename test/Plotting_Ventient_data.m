clear;clc

% Info
% This script is written to help identify which turbines within Cubico's 
% wind farm are the most similar for P2P comparison.


folder = 'C:\Users\mkervyn\Documents\MATLAB\Ventient_data';

WTs = string(['Ventient_Lissett-Airfield_WTG_103_30s_';...
        'Ventient_Lissett-Airfield_WTG_104_30s_';...
        'Ventient_Lissett-Airfield_WTG_105_30s_';...
        'Ventient_Lissett-Airfield_WTG_106_30s_';...
        ...'Ventient_Lissett-Airfield_WTG_107_30s_';...
        ...'Ventient_Lissett-Airfield_WTG_108_30s_';...
        ...'Ventient_Lissett-Airfield_WTG_109_30s_';...
        ...'Ventient_Lissett-Airfield_WTG_110_30s_';...
        ...'Ventient_Lissett-Airfield_WTG_111_30s_'
        ]);
    
% Select data fields of interest (Column 1 = new names, Column 2 = nc file names)
    data_mapping = {'Time',                 'TimeStamp'; ...
                    'OmegaRotor',           'Rotor speed';...
                    'RPM',                  'Generator RPM'
                    'PowerActive',          'Power';...
                    'TemperatureExternal',  'Ambient temperature';...
                    'PitchAngleA',          'Blade angle (pitch position) A';...
                    % 'PitchAngleB',          'Blade angle (pitch position) B';...
                    % 'PitchAngleC',          'Blade angle (pitch position) C';...
                    'DirectionNacelle',     'Nacelle position';...
                    'WindSpeed',            'Wind speed';...
                    'WindDirection',        'Wind direction';...
                    ...'ErrorCode',            'ErrorCode';... % ErrorCode seems to corrolate with dips in power
                    ...'WpsStatus',            'WpsStatus';...% WpsStatus seems to corrolate with shut downs
                    ...'WTOperationState',     'WTOperationState';% WTOperationState seems to corrolate with dips in power
                    ... 'ProductionFactor',     'Production Factor';% ProductionFactor is unclear but much more variable
                    };

% Concatonate
clc
[WT1, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(1), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2023,06,23), ...
                                          'Stop', datetime(2023,08,30) ...
                                        );

[WT2, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(2), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2023,06,23), ...
                                          'Stop', datetime(2023,08,30) ...
                                        );

[WT3, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(3), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2023,06,23), ...
                                          'Stop', datetime(2023,08,30) ...
                                        );

[WT4, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(4), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2023,06,23), ...
                                          'Stop', datetime(2023,08,30) ...
                                        ); 
%%
% [WT5, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                           'FilePrefix', WTs(5), ...
%                                           'Ext', ".nc", ...
%                                           'Mapping', data_mapping, ...
%                                           'Start', datetime(2022,02,08), ...
%                                           'Stop', datetime(2022,04,06) ...
%                                         );
% 
% [WT6, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                           'FilePrefix', WTs(6), ...
%                                           'Ext', ".nc", ...
%                                           'Mapping', data_mapping, ...
%                                           'Start', datetime(2022,02,08), ...
%                                           'Stop', datetime(2022,04,06) ...
%                                         );   
% 
% [WT7, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                           'FilePrefix', WTs(7), ...
%                                           'Ext', ".nc", ...
%                                           'Mapping', data_mapping, ...
%                                           'Start', datetime(2022,02,08), ...
%                                           'Stop', datetime(2022,04,06) ...
%                                         );
% 
% [WT8, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                           'FilePrefix', WTs(8), ...
%                                           'Ext', ".nc", ...
%                                           'Mapping', data_mapping, ...
%                                           'Start', datetime(2022,02,08), ...
%                                           'Stop', datetime(2022,04,06) ...
%                                         );   
% 
% [WT9, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
%                                           'FilePrefix', WTs(9), ...
%                                           'Ext', ".nc", ...
%                                           'Mapping', data_mapping, ...
%                                           'Start', datetime(2022,02,08), ...
%                                           'Stop', datetime(2022,04,06) ...
%                                         );


%% Replace zeros with NaN

WT1.PowerActive(isnan(WT1.PowerActive))=0;
WT1.OmegaRotor(isnan(WT1.OmegaRotor))=0;
WT1.PitchAngleA(isnan(WT1.PitchAngleA))=0;
WT1.DirectionNacelle(isnan(WT1.DirectionNacelle))=0;
%
WT2.PowerActive(isnan(WT2.PowerActive))=0;
WT2.OmegaRotor(isnan(WT2.OmegaRotor))=0;
WT2.PitchAngleA(isnan(WT2.PitchAngleA))=0;
WT2.DirectionNacelle(isnan(WT2.DirectionNacelle))=0;
%
WT3.PowerActive(isnan(WT3.PowerActive))=0;
WT3.OmegaRotor(isnan(WT3.OmegaRotor))=0;
WT3.PitchAngleA(isnan(WT3.PitchAngleA))=0;
WT3.DirectionNacelle(isnan(WT3.DirectionNacelle))=0;
%
WT4.PowerActive(isnan(WT4.PowerActive))=0;
WT4.OmegaRotor(isnan(WT4.OmegaRotor))=0;
WT4.PitchAngleA(isnan(WT4.PitchAngleA))=0;
WT4.DirectionNacelle(isnan(WT4.DirectionNacelle))=0;
%
% WT5.PowerActive(isnan(WT5.PowerActive))=0;
% WT5.OmegaRotor(isnan(WT5.OmegaRotor))=0;
% WT5.PitchAngleA(isnan(WT5.PitchAngleA))=0;
% WT5.DirectionNacelle(isnan(WT5.DirectionNacelle))=0;
% %
% WT6.PowerActive(isnan(WT6.PowerActive))=0;
% WT6.OmegaRotor(isnan(WT6.OmegaRotor))=0;
% WT6.PitchAngleA(isnan(WT6.PitchAngleA))=0;
% WT6.DirectionNacelle(isnan(WT6.DirectionNacelle))=0;
% %
% WT7.PowerActive(isnan(WT7.PowerActive))=0;
% WT7.OmegaRotor(isnan(WT7.OmegaRotor))=0;
% WT7.PitchAngleA(isnan(WT7.PitchAngleA))=0;
% WT7.DirectionNacelle(isnan(WT7.DirectionNacelle))=0;
% %
% WT8.PowerActive(isnan(WT8.PowerActive))=0;
% WT8.OmegaRotor(isnan(WT8.OmegaRotor))=0;
% WT8.PitchAngleA(isnan(WT8.PitchAngleA))=0;
% WT8.DirectionNacelle(isnan(WT8.DirectionNacelle))=0;
% %
% WT9.PowerActive(isnan(WT9.PowerActive))=0;
% WT9.OmegaRotor(isnan(WT9.OmegaRotor))=0;
% WT9.PitchAngleA(isnan(WT9.PitchAngleA))=0;
% WT9.DirectionNacelle(isnan(WT9.DirectionNacelle))=0;


%% Time domain plots

Time1=datetime(1970,1,1,0,0,WT1.Time{1,1});
Time2=datetime(1970,1,1,0,0,WT2.Time{1,1});
Time3=datetime(1970,1,1,0,0,WT3.Time{1,1});
Time4=datetime(1970,1,1,0,0,WT4.Time{1,1});
% Time5=datetime(1970,1,1,0,0,WT5.Time{1,1});
% Time6=datetime(1970,1,1,0,0,WT6.Time{1,1});
% Time7=datetime(1970,1,1,0,0,WT7.Time{1,1});
% Time8=datetime(1970,1,1,0,0,WT8.Time{1,1});
% Time9=datetime(1970,1,1,0,0,WT9.Time{1,1});


figure(1)
ax1=subplot(4,1,1);
plot(Time1,WT1.PowerActive)
hold on
plot(Time2,WT2.PowerActive)
plot(Time3,WT3.PowerActive)
plot(Time4,WT4.PowerActive)
% plot(Time5,WT5.PowerActive)
% plot(Time6,WT6.PowerActive)
% plot(Time7,WT7.PowerActive)
% plot(Time8,WT8.PowerActive)
% plot(Time9,WT9.PowerActive)
hold off
grid on
xlabel 'Time [s]'
ylabel 'P [W]'
legend WT1 WT2 WT3 WT4 WT5 WT6 WT7 WT8 WT9
title 'Power'
%
ax2=subplot(4,1,2);
plot(Time1,WT1.OmegaRotor)
hold on
plot(Time2,WT2.OmegaRotor)
plot(Time3,WT3.OmegaRotor)
plot(Time4,WT4.OmegaRotor)
% plot(Time5,WT5.OmegaRotor)
% plot(Time6,WT6.OmegaRotor)
% plot(Time7,WT7.OmegaRotor)
% plot(Time8,WT8.OmegaRotor)
% plot(Time9,WT9.OmegaRotor)
hold off
grid on
xlabel 'Time [s]'
ylabel 'Gen Sp [rpm]'
title 'Generator Speed'
%
ax3=subplot(4,1,3);
plot(Time1,WT1.PitchAngleA)
hold on
plot(Time2,WT2.PitchAngleA)
plot(Time3,WT3.PitchAngleA)
plot(Time4,WT4.PitchAngleA)
% plot(Time5,WT5.PitchAngleA)
% plot(Time6,WT6.PitchAngleA)
% plot(Time7,WT7.PitchAngleA)
% plot(Time8,WT8.PitchAngleA)
% plot(Time9,WT9.PitchAngleA)
hold off
grid on
xlabel 'Time [s]'
ylabel 'Pitch [^{\circ}]'
title 'Pitch'
%
ax4=subplot(4,1,4);
plot(Time1,unwrap(WT1.DirectionNacelle))
hold on
plot(Time2,unwrap(WT2.DirectionNacelle))
plot(Time3,unwrap(WT3.DirectionNacelle))
plot(Time4,unwrap(WT4.DirectionNacelle))
% plot(Time5,unwrap(WT5.DirectionNacelle))
% plot(Time6,unwrap(WT6.DirectionNacelle))
% plot(Time7,unwrap(WT7.DirectionNacelle))
% plot(Time8,unwrap(WT8.DirectionNacelle))
% plot(Time9,unwrap(WT9.DirectionNacelle))
hold off
grid on
xlabel 'Time [s]'
ylabel 'Nac Pos [^{\circ}]'
title 'Nacelle Position'
sgtitle ' Time domain plots'

linkaxes([ax1 ax2 ax3 ax4],'x')

%% Plotting integrals


figure(2)
ax1=subplot(2,2,1);
plot(Time1,cumtrapz(WT1.PowerActive),'LineWidth',2) 
hold on
plot(Time2,cumtrapz(WT2.PowerActive),'LineWidth',2)
plot(Time3,cumtrapz(WT3.PowerActive),'LineWidth',2)
plot(Time4,cumtrapz(WT4.PowerActive),'LineWidth',2)
% plot(Time5,cumtrapz(WT5.PowerActive),'LineWidth',2)
% plot(Time6,cumtrapz(WT6.PowerActive),'LineWidth',2)
% plot(Time7,cumtrapz(WT7.PowerActive),'LineWidth',2) 
% plot(Time8,cumtrapz(WT8.PowerActive),'LineWidth',2)
% plot(Time9,cumtrapz(WT9.PowerActive),'LineWidth',2) 
hold off
grid on
xlabel 'Time [s]'
ylabel 'P [W]'
legend WT1 WT2 WT3 WT4 WT5 WT6 WT7 WT8 WT9
title 'Power'
%
ax2=subplot(2,2,2);
plot(Time1,cumtrapz(WT1.OmegaRotor),'LineWidth',2)
hold on
plot(Time2,cumtrapz(WT2.OmegaRotor),'LineWidth',2)
plot(Time3,cumtrapz(WT3.OmegaRotor),'LineWidth',2)
plot(Time4,cumtrapz(WT4.OmegaRotor),'LineWidth',2)
% plot(Time5,cumtrapz(WT5.OmegaRotor),'LineWidth',2)
% plot(Time6,cumtrapz(WT6.OmegaRotor),'LineWidth',2)
% plot(Time7,cumtrapz(WT7.OmegaRotor),'LineWidth',2)
% plot(Time8,cumtrapz(WT8.OmegaRotor),'LineWidth',2)
% plot(Time9,cumtrapz(WT9.OmegaRotor),'LineWidth',2)
hold off
grid on
xlabel 'Time [s]'
ylabel 'Gen Sp [rpm]'
title 'Generator Speed'
%
ax3=subplot(2,2,3);
plot(Time1,cumtrapz(WT1.PitchAngleA),'LineWidth',2)
hold on
plot(Time2,cumtrapz(WT2.PitchAngleA),'LineWidth',2)
plot(Time3,cumtrapz(WT3.PitchAngleA),'LineWidth',2)
plot(Time4,cumtrapz(WT4.PitchAngleA),'LineWidth',2)
% plot(Time5,cumtrapz(WT5.PitchAngleA),'LineWidth',2)
% plot(Time6,cumtrapz(WT6.PitchAngleA),'LineWidth',2)
% plot(Time7,cumtrapz(WT7.PitchAngleA),'LineWidth',2)
% plot(Time8,cumtrapz(WT8.PitchAngleA),'LineWidth',2)
% plot(Time9,cumtrapz(WT9.PitchAngleA),'LineWidth',2)
hold off
grid on
xlabel 'Time [s]'
ylabel 'Pitch [^{\circ}]'
title 'Pitch'
%
ax4=subplot(2,2,4);
plot(Time1,cumtrapz(unwrap(WT1.DirectionNacelle) ) ,'LineWidth',2)
hold on
plot(Time2,cumtrapz(unwrap(WT2.DirectionNacelle) ) ,'LineWidth',2)
plot(Time3,cumtrapz(unwrap(WT3.DirectionNacelle) ) ,'LineWidth',2)
plot(Time4,cumtrapz(unwrap(WT4.DirectionNacelle) ) ,'LineWidth',2)
% plot(Time5,cumtrapz(unwrap(WT5.DirectionNacelle) ) ,'LineWidth',2)
% plot(Time6,cumtrapz(unwrap(WT6.DirectionNacelle) ) ,'LineWidth',2)
% plot(Time7,cumtrapz(unwrap(WT7.DirectionNacelle) ) ,'LineWidth',2)
% plot(Time8,cumtrapz(unwrap(WT8.DirectionNacelle) ) ,'LineWidth',2)
% plot(Time9,cumtrapz(unwrap(WT9.DirectionNacelle) ) ,'LineWidth',2)
hold off
grid on
xlabel 'Time [s]'
ylabel 'Nac Pos [^{\circ}]'
title 'Nacelle Position'
sgtitle 'Integration of time domain signals'

linkaxes([ax1 ax2 ax3 ax4],'x')


%% Substract integrals.......


figure(3)
ax1=subplot(4,1,1);
plot(Time1,abs(cumtrapz(WT1.PowerActive)-cumtrapz(WT2.PowerActive)),'LineWidth',2) % Best
hold on
plot(Time1,abs(cumtrapz(WT1.PowerActive)-cumtrapz(WT3.PowerActive)),'LineWidth',2) 
plot(Time1,abs(cumtrapz(WT1.PowerActive)-cumtrapz(WT4.PowerActive)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.PowerActive)-cumtrapz(WT5.PowerActive)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.PowerActive)-cumtrapz(WT6.PowerActive)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.PowerActive)-cumtrapz(WT7.PowerActive)),'LineWidth',2) 
plot(Time1,abs(cumtrapz(WT2.PowerActive)-cumtrapz(WT3.PowerActive)),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT2.PowerActive)-cumtrapz(WT4.PowerActive)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.PowerActive)-cumtrapz(WT5.PowerActive)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.PowerActive)-cumtrapz(WT6.PowerActive)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.PowerActive)-cumtrapz(WT7.PowerActive)),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT3.PowerActive)-cumtrapz(WT4.PowerActive)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT3.PowerActive)-cumtrapz(WT5.PowerActive)),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT3.PowerActive)-cumtrapz(WT6.PowerActive)),':','LineWidth',2)  % Best
% plot(Time1,abs(cumtrapz(WT3.PowerActive)-cumtrapz(WT7.PowerActive)),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT4.PowerActive)-cumtrapz(WT5.PowerActive)),':','LineWidth',2)  % Best
% plot(Time1,abs(cumtrapz(WT4.PowerActive)-cumtrapz(WT6.PowerActive)),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT4.PowerActive)-cumtrapz(WT7.PowerActive)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT5.PowerActive)-cumtrapz(WT6.PowerActive)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT5.PowerActive)-cumtrapz(WT7.PowerActive)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT6.PowerActive)-cumtrapz(WT7.PowerActive)),'-.','LineWidth',2) 
hold off
grid on
xlabel 'Time [s]'
ylabel 'P [W]'
legend 'abs(WT1-WT2)' 'abs(WT3-WT6)' 'abs(WT4-WT5)'
title 'Power'
%
ax2=subplot(4,1,2);
plot(Time1,abs(cumtrapz(WT1.OmegaRotor)-cumtrapz(WT2.OmegaRotor)),'LineWidth',2)
hold on
plot(Time1,abs(cumtrapz(WT1.OmegaRotor)-cumtrapz(WT3.OmegaRotor)),'LineWidth',2) 
plot(Time1,abs(cumtrapz(WT1.OmegaRotor)-cumtrapz(WT4.OmegaRotor)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.OmegaRotor)-cumtrapz(WT5.OmegaRotor)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.OmegaRotor)-cumtrapz(WT6.OmegaRotor)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.OmegaRotor)-cumtrapz(WT7.OmegaRotor)),'LineWidth',2) 
plot(Time1,abs(cumtrapz(WT2.OmegaRotor)-cumtrapz(WT3.OmegaRotor)),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT2.OmegaRotor)-cumtrapz(WT4.OmegaRotor)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.OmegaRotor)-cumtrapz(WT5.OmegaRotor)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.OmegaRotor)-cumtrapz(WT6.OmegaRotor)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.OmegaRotor)-cumtrapz(WT7.OmegaRotor)),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT3.OmegaRotor)-cumtrapz(WT4.OmegaRotor)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT3.OmegaRotor)-cumtrapz(WT5.OmegaRotor)),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT3.OmegaRotor)-cumtrapz(WT6.OmegaRotor)),':','LineWidth',2) % Best
% plot(Time1,abs(cumtrapz(WT3.OmegaRotor)-cumtrapz(WT7.OmegaRotor)),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT4.OmegaRotor)-cumtrapz(WT5.OmegaRotor)),':','LineWidth',2)  % Best
% plot(Time1,abs(cumtrapz(WT4.OmegaRotor)-cumtrapz(WT6.OmegaRotor)),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT4.OmegaRotor)-cumtrapz(WT7.OmegaRotor)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT5.OmegaRotor)-cumtrapz(WT6.OmegaRotor)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT5.OmegaRotor)-cumtrapz(WT7.OmegaRotor)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT6.OmegaRotor)-cumtrapz(WT7.OmegaRotor)),'-.','LineWidth',2) 
hold off
grid on
xlabel 'Time [s]'
ylabel 'Gen Sp [rpm]'
title 'Generator Speed'
%
ax3=subplot(4,1,3);
plot(Time1,abs(cumtrapz(WT1.PitchAngleA)-cumtrapz(WT2.PitchAngleA)),'LineWidth',2)
hold on
plot(Time1,abs(cumtrapz(WT1.PitchAngleA)-cumtrapz(WT3.PitchAngleA)),'LineWidth',2) 
plot(Time1,abs(cumtrapz(WT1.PitchAngleA)-cumtrapz(WT4.PitchAngleA)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.PitchAngleA)-cumtrapz(WT5.PitchAngleA)),'LineWidth',2) % good
% plot(Time1,abs(cumtrapz(WT1.PitchAngleA)-cumtrapz(WT6.PitchAngleA)),'LineWidth',2) % good
% plot(Time1,abs(cumtrapz(WT1.PitchAngleA)-cumtrapz(WT7.PitchAngleA)),'LineWidth',2) 
plot(Time1,abs(cumtrapz(WT2.PitchAngleA)-cumtrapz(WT3.PitchAngleA)),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT2.PitchAngleA)-cumtrapz(WT4.PitchAngleA)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.PitchAngleA)-cumtrapz(WT5.PitchAngleA)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.PitchAngleA)-cumtrapz(WT6.PitchAngleA)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.PitchAngleA)-cumtrapz(WT7.PitchAngleA)),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT3.PitchAngleA)-cumtrapz(WT4.PitchAngleA)),'--','LineWidth',2) % good
% plot(Time1,abs(cumtrapz(WT3.PitchAngleA)-cumtrapz(WT5.PitchAngleA)),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT3.PitchAngleA)-cumtrapz(WT6.PitchAngleA)),':','LineWidth',2)  
% plot(Time1,abs(cumtrapz(WT3.PitchAngleA)-cumtrapz(WT7.PitchAngleA)),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT4.PitchAngleA)-cumtrapz(WT5.PitchAngleA)),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT4.PitchAngleA)-cumtrapz(WT6.PitchAngleA)),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT4.PitchAngleA)-cumtrapz(WT7.PitchAngleA)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT5.PitchAngleA)-cumtrapz(WT6.PitchAngleA)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT5.PitchAngleA)-cumtrapz(WT7.PitchAngleA)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT6.PitchAngleA)-cumtrapz(WT7.PitchAngleA)),'-.','LineWidth',2) 
hold off
grid on
xlabel 'Time [s]'
ylabel 'Pitch [^{\circ}]'
title 'Pitch'
%
ax4=subplot(4,1,4);
plot(Time1,abs(cumtrapz(unwrap(WT1.DirectionNacelle))-cumtrapz(unwrap(WT2.DirectionNacelle))),'LineWidth',2) 
hold on
plot(Time1,abs(cumtrapz(unwrap(WT1.DirectionNacelle))-cumtrapz(unwrap(WT3.DirectionNacelle))),'LineWidth',2) 
plot(Time1,abs(cumtrapz(unwrap(WT1.DirectionNacelle))-cumtrapz(unwrap(WT4.DirectionNacelle))),'LineWidth',2) % good
% plot(Time1,abs(cumtrapz(unwrap(WT1.DirectionNacelle))-cumtrapz(unwrap(WT5.DirectionNacelle))),'LineWidth',2)
% plot(Time1,abs(cumtrapz(unwrap(WT1.DirectionNacelle))-cumtrapz(unwrap(WT6.DirectionNacelle))),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT1.DirectionNacelle))-cumtrapz(unwrap(WT7.DirectionNacelle))),'LineWidth',2) % good
plot(Time1,abs(cumtrapz(unwrap(WT2.DirectionNacelle))-cumtrapz(unwrap(WT3.DirectionNacelle))),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(unwrap(WT2.DirectionNacelle))-cumtrapz(unwrap(WT4.DirectionNacelle))),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT2.DirectionNacelle))-cumtrapz(unwrap(WT5.DirectionNacelle))),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT2.DirectionNacelle))-cumtrapz(unwrap(WT6.DirectionNacelle))),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT2.DirectionNacelle))-cumtrapz(unwrap(WT7.DirectionNacelle))),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(unwrap(WT3.DirectionNacelle))-cumtrapz(unwrap(WT4.DirectionNacelle))),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT3.DirectionNacelle))-cumtrapz(unwrap(WT5.DirectionNacelle))),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT3.DirectionNacelle))-cumtrapz(unwrap(WT6.DirectionNacelle))),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT3.DirectionNacelle))-cumtrapz(unwrap(WT7.DirectionNacelle))),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT4.DirectionNacelle))-cumtrapz(unwrap(WT5.DirectionNacelle))),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT4.DirectionNacelle))-cumtrapz(unwrap(WT6.DirectionNacelle))),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT4.DirectionNacelle))-cumtrapz(unwrap(WT7.DirectionNacelle))),'-.','LineWidth',2) % best
% plot(Time1,abs(cumtrapz(unwrap(WT5.DirectionNacelle))-cumtrapz(unwrap(WT6.DirectionNacelle))),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT5.DirectionNacelle))-cumtrapz(unwrap(WT7.DirectionNacelle))),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT6.DirectionNacelle))-cumtrapz(unwrap(WT7.DirectionNacelle))),'-.','LineWidth',2) 
hold off
grid on
legend 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
xlabel 'Time [s]'
ylabel 'Nac Pos [^{\circ}]'
title 'Nacelle Position'
sgtitle 'Substraction of integrals'

linkaxes([ax1 ax2 ax3 ax4],'x')

