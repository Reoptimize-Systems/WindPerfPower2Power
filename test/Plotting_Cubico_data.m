clear;clc

% Info
% This script is written to help identify which turbines within Cubico's 
% wind farm are the most similar for P2P comparison.


folder = fullfile(nextcloud_dir(), 'Field-Data', 'wind', 'Cubico');

WTs = string(['Cubico_Middlewick_WTG_1_10min_2022';...
        'Cubico_Middlewick_WTG_2_10min_2022';...
        'Cubico_Middlewick_WTG_3_10min_2022';...
        'Cubico_Middlewick_WTG_4_10min_2022';...
        'Cubico_Middlewick_WTG_5_10min_2022';...
        'Cubico_Middlewick_WTG_6_10min_2022';...
        'Cubico_Middlewick_WTG_7_10min_2022';...
        'Cubico_Middlewick_WTG_8_10min_2022';...
        'Cubico_Middlewick_WTG_9_10min_2022']);
    
% Select data fields of interest (Column 1 = new names, Column 2 = nc file names)
data_mapping = {'Time',                  'TimeStamp'; ...
                'OmegaRotor',           'Rotor speed';...
                'OmegaGen',             'Generator RPM'
                'PowerGenerator',       'Power';...
                'TemperatureExternal',  'Ambient temperature';...
                'PitchAngleA',           'Blade angle (pitch position) A';...
                'PitchAngleB',           'Blade angle (pitch position) B';...
                'PitchAngleC',           'Blade angle (pitch position) C';...
                'NacellePosition',        'Nacelle position';...
        };

% Concatonate
[WT1, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(1), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2022,02,08), ...
                                          'Stop', datetime(2022,04,06) ...
                                        );

[WT2, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(2), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2022,02,08), ...
                                          'Stop', datetime(2022,04,06) ...
                                        );   

[WT3, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(3), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2022,02,08), ...
                                          'Stop', datetime(2022,04,06) ...
                                        );

[WT4, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(4), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2022,02,08), ...
                                          'Stop', datetime(2022,04,06) ...
                                        );   

[WT5, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(5), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2022,02,08), ...
                                          'Stop', datetime(2022,04,06) ...
                                        );

[WT6, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(6), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2022,02,08), ...
                                          'Stop', datetime(2022,04,06) ...
                                        );   

[WT7, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(7), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2022,02,08), ...
                                          'Stop', datetime(2022,04,06) ...
                                        );

[WT8, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(8), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2022,02,08), ...
                                          'Stop', datetime(2022,04,06) ...
                                        );   

[WT9, ~] = reos.sys.flowTurbine.loadRawData ( 'Folder', folder, ...
                                          'FilePrefix', WTs(9), ...
                                          'Ext', ".nc", ...
                                          'Mapping', data_mapping, ...
                                          'Start', datetime(2022,02,08), ...
                                          'Stop', datetime(2022,04,06) ...
                                        );


%% Replace zeros with NaN

WT1.PowerGenerator(isnan(WT1.PowerGenerator))=0;
WT1.OmegaGen(isnan(WT1.OmegaGen))=0;
WT1.PitchAngleA(isnan(WT1.PitchAngleA))=0;
WT1.NacellePosition(isnan(WT1.NacellePosition))=0;
%
WT2.PowerGenerator(isnan(WT2.PowerGenerator))=0;
WT2.OmegaGen(isnan(WT2.OmegaGen))=0;
WT2.PitchAngleA(isnan(WT2.PitchAngleA))=0;
WT2.NacellePosition(isnan(WT2.NacellePosition))=0;
%
WT3.PowerGenerator(isnan(WT3.PowerGenerator))=0;
WT3.OmegaGen(isnan(WT3.OmegaGen))=0;
WT3.PitchAngleA(isnan(WT3.PitchAngleA))=0;
WT3.NacellePosition(isnan(WT3.NacellePosition))=0;
%
WT4.PowerGenerator(isnan(WT4.PowerGenerator))=0;
WT4.OmegaGen(isnan(WT4.OmegaGen))=0;
WT4.PitchAngleA(isnan(WT4.PitchAngleA))=0;
WT4.NacellePosition(isnan(WT4.NacellePosition))=0;
%
WT5.PowerGenerator(isnan(WT5.PowerGenerator))=0;
WT5.OmegaGen(isnan(WT5.OmegaGen))=0;
WT5.PitchAngleA(isnan(WT5.PitchAngleA))=0;
WT5.NacellePosition(isnan(WT5.NacellePosition))=0;
%
WT6.PowerGenerator(isnan(WT6.PowerGenerator))=0;
WT6.OmegaGen(isnan(WT6.OmegaGen))=0;
WT6.PitchAngleA(isnan(WT6.PitchAngleA))=0;
WT6.NacellePosition(isnan(WT6.NacellePosition))=0;
%
WT7.PowerGenerator(isnan(WT7.PowerGenerator))=0;
WT7.OmegaGen(isnan(WT7.OmegaGen))=0;
WT7.PitchAngleA(isnan(WT7.PitchAngleA))=0;
WT7.NacellePosition(isnan(WT7.NacellePosition))=0;
%
WT8.PowerGenerator(isnan(WT8.PowerGenerator))=0;
WT8.OmegaGen(isnan(WT8.OmegaGen))=0;
WT8.PitchAngleA(isnan(WT8.PitchAngleA))=0;
WT8.NacellePosition(isnan(WT8.NacellePosition))=0;
%
WT9.PowerGenerator(isnan(WT9.PowerGenerator))=0;
WT9.OmegaGen(isnan(WT9.OmegaGen))=0;
WT9.PitchAngleA(isnan(WT9.PitchAngleA))=0;
WT9.NacellePosition(isnan(WT9.NacellePosition))=0;


%% Time domain plots

Time1=datetime(1970,1,1,0,0,WT1.Time{1,1});
Time2=datetime(1970,1,1,0,0,WT2.Time{1,1});
Time3=datetime(1970,1,1,0,0,WT3.Time{1,1});
Time4=datetime(1970,1,1,0,0,WT4.Time{1,1});
Time5=datetime(1970,1,1,0,0,WT5.Time{1,1});
Time6=datetime(1970,1,1,0,0,WT6.Time{1,1});
Time7=datetime(1970,1,1,0,0,WT7.Time{1,1});
Time8=datetime(1970,1,1,0,0,WT8.Time{1,1});
Time9=datetime(1970,1,1,0,0,WT9.Time{1,1});


figure(1)
ax1=subplot(4,1,1);
plot(Time1,WT1.PowerGenerator)
hold on
plot(Time2,WT2.PowerGenerator)
plot(Time3,WT3.PowerGenerator)
plot(Time4,WT4.PowerGenerator)
plot(Time5,WT5.PowerGenerator)
plot(Time6,WT6.PowerGenerator)
plot(Time7,WT7.PowerGenerator)
plot(Time8,WT8.PowerGenerator)
plot(Time9,WT9.PowerGenerator)
hold off
grid on
xlabel 'Time [s]'
ylabel 'P [W]'
legend WT1 WT2 WT3 WT4 WT5 WT6 WT7 WT8 WT9
title 'Power'
%
ax2=subplot(4,1,2);
plot(Time1,WT1.OmegaGen)
hold on
plot(Time2,WT2.OmegaGen)
plot(Time3,WT3.OmegaGen)
plot(Time4,WT4.OmegaGen)
plot(Time5,WT5.OmegaGen)
plot(Time6,WT6.OmegaGen)
plot(Time7,WT7.OmegaGen)
plot(Time8,WT8.OmegaGen)
plot(Time9,WT9.OmegaGen)
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
plot(Time5,WT5.PitchAngleA)
plot(Time6,WT6.PitchAngleA)
plot(Time7,WT7.PitchAngleA)
plot(Time8,WT8.PitchAngleA)
plot(Time9,WT9.PitchAngleA)
hold off
grid on
xlabel 'Time [s]'
ylabel 'Pitch [^{\circ}]'
title 'Pitch'
%
ax4=subplot(4,1,4);
plot(Time1,unwrap(WT1.NacellePosition))
hold on
plot(Time2,unwrap(WT2.NacellePosition))
plot(Time3,unwrap(WT3.NacellePosition))
plot(Time4,unwrap(WT4.NacellePosition))
plot(Time5,unwrap(WT5.NacellePosition))
plot(Time6,unwrap(WT6.NacellePosition))
plot(Time7,unwrap(WT7.NacellePosition))
plot(Time8,unwrap(WT8.NacellePosition))
plot(Time9,unwrap(WT9.NacellePosition))
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
plot(Time1,cumtrapz(WT1.PowerGenerator),'LineWidth',2) 
hold on
plot(Time2,cumtrapz(WT2.PowerGenerator),'LineWidth',2)
plot(Time3,cumtrapz(WT3.PowerGenerator),'LineWidth',2)
plot(Time4,cumtrapz(WT4.PowerGenerator),'LineWidth',2)
plot(Time5,cumtrapz(WT5.PowerGenerator),'LineWidth',2)
plot(Time6,cumtrapz(WT6.PowerGenerator),'LineWidth',2)
plot(Time7,cumtrapz(WT7.PowerGenerator),'LineWidth',2) 
plot(Time8,cumtrapz(WT8.PowerGenerator),'LineWidth',2)
plot(Time9,cumtrapz(WT9.PowerGenerator),'LineWidth',2) 
hold off
grid on
xlabel 'Time [s]'
ylabel 'P [W]'
legend WT1 WT2 WT3 WT4 WT5 WT6 WT7 WT8 WT9
title 'Power'
%
ax2=subplot(2,2,2);
plot(Time1,cumtrapz(WT1.OmegaGen),'LineWidth',2)
hold on
plot(Time2,cumtrapz(WT2.OmegaGen),'LineWidth',2)
plot(Time3,cumtrapz(WT3.OmegaGen),'LineWidth',2)
plot(Time4,cumtrapz(WT4.OmegaGen),'LineWidth',2)
plot(Time5,cumtrapz(WT5.OmegaGen),'LineWidth',2)
plot(Time6,cumtrapz(WT6.OmegaGen),'LineWidth',2)
plot(Time7,cumtrapz(WT7.OmegaGen),'LineWidth',2)
plot(Time8,cumtrapz(WT8.OmegaGen),'LineWidth',2)
plot(Time9,cumtrapz(WT9.OmegaGen),'LineWidth',2)
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
plot(Time5,cumtrapz(WT5.PitchAngleA),'LineWidth',2)
plot(Time6,cumtrapz(WT6.PitchAngleA),'LineWidth',2)
plot(Time7,cumtrapz(WT7.PitchAngleA),'LineWidth',2)
plot(Time8,cumtrapz(WT8.PitchAngleA),'LineWidth',2)
plot(Time9,cumtrapz(WT9.PitchAngleA),'LineWidth',2)
hold off
grid on
xlabel 'Time [s]'
ylabel 'Pitch [^{\circ}]'
title 'Pitch'
%
ax4=subplot(2,2,4);
plot(Time1,cumtrapz(unwrap(WT1.NacellePosition) ) ,'LineWidth',2)
hold on
plot(Time2,cumtrapz(unwrap(WT2.NacellePosition) ) ,'LineWidth',2)
plot(Time3,cumtrapz(unwrap(WT3.NacellePosition) ) ,'LineWidth',2)
plot(Time4,cumtrapz(unwrap(WT4.NacellePosition) ) ,'LineWidth',2)
plot(Time5,cumtrapz(unwrap(WT5.NacellePosition) ) ,'LineWidth',2)
plot(Time6,cumtrapz(unwrap(WT6.NacellePosition) ) ,'LineWidth',2)
plot(Time7,cumtrapz(unwrap(WT7.NacellePosition) ) ,'LineWidth',2)
plot(Time8,cumtrapz(unwrap(WT8.NacellePosition) ) ,'LineWidth',2)
plot(Time9,cumtrapz(unwrap(WT9.NacellePosition) ) ,'LineWidth',2)
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
plot(Time1,abs(cumtrapz(WT1.PowerGenerator)-cumtrapz(WT2.PowerGenerator)),'LineWidth',2) % Best
hold on
% plot(Time1,abs(cumtrapz(WT1.PowerGenerator)-cumtrapz(WT3.PowerGenerator)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.PowerGenerator)-cumtrapz(WT4.PowerGenerator)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.PowerGenerator)-cumtrapz(WT5.PowerGenerator)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.PowerGenerator)-cumtrapz(WT6.PowerGenerator)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.PowerGenerator)-cumtrapz(WT7.PowerGenerator)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.PowerGenerator)-cumtrapz(WT3.PowerGenerator)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.PowerGenerator)-cumtrapz(WT4.PowerGenerator)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.PowerGenerator)-cumtrapz(WT5.PowerGenerator)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.PowerGenerator)-cumtrapz(WT6.PowerGenerator)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.PowerGenerator)-cumtrapz(WT7.PowerGenerator)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT3.PowerGenerator)-cumtrapz(WT4.PowerGenerator)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT3.PowerGenerator)-cumtrapz(WT5.PowerGenerator)),':','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT3.PowerGenerator)-cumtrapz(WT6.PowerGenerator)),':','LineWidth',2)  % Best
% plot(Time1,abs(cumtrapz(WT3.PowerGenerator)-cumtrapz(WT7.PowerGenerator)),':','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT4.PowerGenerator)-cumtrapz(WT5.PowerGenerator)),':','LineWidth',2)  % Best
% plot(Time1,abs(cumtrapz(WT4.PowerGenerator)-cumtrapz(WT6.PowerGenerator)),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT4.PowerGenerator)-cumtrapz(WT7.PowerGenerator)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT5.PowerGenerator)-cumtrapz(WT6.PowerGenerator)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT5.PowerGenerator)-cumtrapz(WT7.PowerGenerator)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT6.PowerGenerator)-cumtrapz(WT7.PowerGenerator)),'-.','LineWidth',2) 
hold off
grid on
xlabel 'Time [s]'
ylabel 'P [W]'
legend 'abs(WT1-WT2)' 'abs(WT3-WT6)' 'abs(WT4-WT5)'
title 'Power'
%
ax2=subplot(4,1,2);
% plot(Time1,abs(cumtrapz(WT1.OmegaGen)-cumtrapz(WT2.OmegaGen)),'LineWidth',2)
% plot(Time1,abs(cumtrapz(WT1.OmegaGen)-cumtrapz(WT3.OmegaGen)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.OmegaGen)-cumtrapz(WT4.OmegaGen)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.OmegaGen)-cumtrapz(WT5.OmegaGen)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.OmegaGen)-cumtrapz(WT6.OmegaGen)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT1.OmegaGen)-cumtrapz(WT7.OmegaGen)),'LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.OmegaGen)-cumtrapz(WT3.OmegaGen)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.OmegaGen)-cumtrapz(WT4.OmegaGen)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.OmegaGen)-cumtrapz(WT5.OmegaGen)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.OmegaGen)-cumtrapz(WT6.OmegaGen)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT2.OmegaGen)-cumtrapz(WT7.OmegaGen)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT3.OmegaGen)-cumtrapz(WT4.OmegaGen)),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT3.OmegaGen)-cumtrapz(WT5.OmegaGen)),':','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT3.OmegaGen)-cumtrapz(WT6.OmegaGen)),':','LineWidth',2) % Best
hold on
% plot(Time1,abs(cumtrapz(WT3.OmegaGen)-cumtrapz(WT7.OmegaGen)),':','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT4.OmegaGen)-cumtrapz(WT5.OmegaGen)),':','LineWidth',2)  % Best
% plot(Time1,abs(cumtrapz(WT4.OmegaGen)-cumtrapz(WT6.OmegaGen)),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT4.OmegaGen)-cumtrapz(WT7.OmegaGen)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT5.OmegaGen)-cumtrapz(WT6.OmegaGen)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT5.OmegaGen)-cumtrapz(WT7.OmegaGen)),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(WT6.OmegaGen)-cumtrapz(WT7.OmegaGen)),'-.','LineWidth',2) 
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
plot(Time1,abs(cumtrapz(WT1.PitchAngleA)-cumtrapz(WT5.PitchAngleA)),'LineWidth',2) % good
plot(Time1,abs(cumtrapz(WT1.PitchAngleA)-cumtrapz(WT6.PitchAngleA)),'LineWidth',2) % good
plot(Time1,abs(cumtrapz(WT1.PitchAngleA)-cumtrapz(WT7.PitchAngleA)),'LineWidth',2) 
plot(Time1,abs(cumtrapz(WT2.PitchAngleA)-cumtrapz(WT3.PitchAngleA)),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT2.PitchAngleA)-cumtrapz(WT4.PitchAngleA)),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT2.PitchAngleA)-cumtrapz(WT5.PitchAngleA)),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT2.PitchAngleA)-cumtrapz(WT6.PitchAngleA)),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT2.PitchAngleA)-cumtrapz(WT7.PitchAngleA)),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT3.PitchAngleA)-cumtrapz(WT4.PitchAngleA)),'--','LineWidth',2) % good
plot(Time1,abs(cumtrapz(WT3.PitchAngleA)-cumtrapz(WT5.PitchAngleA)),':','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT3.PitchAngleA)-cumtrapz(WT6.PitchAngleA)),':','LineWidth',2)  
plot(Time1,abs(cumtrapz(WT3.PitchAngleA)-cumtrapz(WT7.PitchAngleA)),':','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT4.PitchAngleA)-cumtrapz(WT5.PitchAngleA)),':','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT4.PitchAngleA)-cumtrapz(WT6.PitchAngleA)),':','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT4.PitchAngleA)-cumtrapz(WT7.PitchAngleA)),'-.','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT5.PitchAngleA)-cumtrapz(WT6.PitchAngleA)),'-.','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT5.PitchAngleA)-cumtrapz(WT7.PitchAngleA)),'-.','LineWidth',2) 
plot(Time1,abs(cumtrapz(WT6.PitchAngleA)-cumtrapz(WT7.PitchAngleA)),'-.','LineWidth',2) 
hold off
grid on
xlabel 'Time [s]'
ylabel 'Pitch [^{\circ}]'
title 'Pitch'
%
ax4=subplot(4,1,4);
plot(Time1,abs(cumtrapz(unwrap(WT1.NacellePosition))-cumtrapz(unwrap(WT2.NacellePosition))),'LineWidth',2) 
hold on
plot(Time1,abs(cumtrapz(unwrap(WT1.NacellePosition))-cumtrapz(unwrap(WT3.NacellePosition))),'LineWidth',2) 
plot(Time1,abs(cumtrapz(unwrap(WT1.NacellePosition))-cumtrapz(unwrap(WT4.NacellePosition))),'LineWidth',2) % good
% plot(Time1,abs(cumtrapz(unwrap(WT1.NacellePosition))-cumtrapz(unwrap(WT5.NacellePosition))),'LineWidth',2)
% plot(Time1,abs(cumtrapz(unwrap(WT1.NacellePosition))-cumtrapz(unwrap(WT6.NacellePosition))),'LineWidth',2) 
plot(Time1,abs(cumtrapz(unwrap(WT1.NacellePosition))-cumtrapz(unwrap(WT7.NacellePosition))),'LineWidth',2) % good
% plot(Time1,abs(cumtrapz(unwrap(WT2.NacellePosition))-cumtrapz(unwrap(WT3.NacellePosition))),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT2.NacellePosition))-cumtrapz(unwrap(WT4.NacellePosition))),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT2.NacellePosition))-cumtrapz(unwrap(WT5.NacellePosition))),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT2.NacellePosition))-cumtrapz(unwrap(WT6.NacellePosition))),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT2.NacellePosition))-cumtrapz(unwrap(WT7.NacellePosition))),'--','LineWidth',2) 
plot(Time1,abs(cumtrapz(unwrap(WT3.NacellePosition))-cumtrapz(unwrap(WT4.NacellePosition))),'--','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT3.NacellePosition))-cumtrapz(unwrap(WT5.NacellePosition))),':','LineWidth',2) 
plot(Time1,abs(cumtrapz(unwrap(WT3.NacellePosition))-cumtrapz(unwrap(WT6.NacellePosition))),':','LineWidth',2) 
plot(Time1,abs(cumtrapz(unwrap(WT3.NacellePosition))-cumtrapz(unwrap(WT7.NacellePosition))),':','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT4.NacellePosition))-cumtrapz(unwrap(WT5.NacellePosition))),':','LineWidth',2) 
plot(Time1,abs(cumtrapz(unwrap(WT4.NacellePosition))-cumtrapz(unwrap(WT6.NacellePosition))),':','LineWidth',2) 
plot(Time1,abs(cumtrapz(unwrap(WT4.NacellePosition))-cumtrapz(unwrap(WT7.NacellePosition))),'-.','LineWidth',2) % best
% plot(Time1,abs(cumtrapz(unwrap(WT5.NacellePosition))-cumtrapz(unwrap(WT6.NacellePosition))),'-.','LineWidth',2) 
% plot(Time1,abs(cumtrapz(unwrap(WT5.NacellePosition))-cumtrapz(unwrap(WT7.NacellePosition))),'-.','LineWidth',2) 
plot(Time1,abs(cumtrapz(unwrap(WT6.NacellePosition))-cumtrapz(unwrap(WT7.NacellePosition))),'-.','LineWidth',2) 
hold off
grid on
legend 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
xlabel 'Time [s]'
ylabel 'Nac Pos [^{\circ}]'
title 'Nacelle Position'
sgtitle 'Substraction of integrals'

linkaxes([ax1 ax2 ax3 ax4],'x')

