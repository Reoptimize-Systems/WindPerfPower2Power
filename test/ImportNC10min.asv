function Sim = ImportNC10min(FileName)
% function to import CUBICO 10 minute SCADA data from .nc files

    gearboxRatio = 90.842;
    dat1.Time = ncread(FileName, 'TimeStamp');


    try
        dat1.windSpeed = double(ncread(FileName,'Wind speed'));
    catch
        dat1.windSpeed = nan(length(dat1.Time), 1);
    end

    % try
    %     dat1.windSpeed2 = double(ncread(FileName,'Wind Speed 2'));
    % catch
    %     dat1.windSpeed2 = nan(length(dat1.Time), 1);
    % end

    % try
    %     dat1.windAvailable = double(ncread(FileName,'Available wind speed'));
    % catch
    %     dat1.windAvailable = nan(length(dat1.Time), 1);
    % end
    
    % % % % Wind Direction not available for Cubico wind turbines, but
    % Nacelle position available
    try
        dat1.windDirection = double(ncread(FileName,'Wind Direction'));
    catch
        dat1.windDirection = nan(length(dat1.Time), 1);
    end

    try
        dat1.rpmGen = double(ncread(FileName,'Generator RPM'));
    catch
        dat1.rpmGen = nan(length(dat1.Time), 1);
    end

    try
        dat1.rpmEnc = dat1.rpmGen / gearboxRatio;
    catch
        dat1.rpmEnc = nan(length(dat1.Time), 1);
    end

    try
        dat1.pitchAngle1 = double(ncread(FileName,'Blade angle (pitch position) A'));
    catch
        try
            dat1.pitchAngle1 = double(ncread(FileName,'Pitch Angle, Blade 1'));
        catch
            dat1.pitchAngle1 = nan(length(dat1.Time), 1);
        end

    end

    try
        dat1.pitchAngle2 = double(ncread(FileName,'Blade angle (pitch position) B'));
    catch
        try
            dat1.pitchAngle2 = double(ncread(FileName,'Pitch Angle, Blade 2'));
        catch
            dat1.pitchAngle2 = nan(length(dat1.Time), 1);
        end
    end

    try
        dat1.pitchAngle3 = double(ncread(FileName,'Blade angle (pitch position) C'));
    catch
        try
            dat1.pitchAngle3 = double(ncread(FileName,'Pitch Angle, Blade 3'));
        catch
            dat1.pitchAngle3 = nan(length(dat1.Time), 1);
        end
    end

    try
        dat1.pitchAngle = 1/3 * (dat1.pitchAngle1 + dat1.pitchAngle2 + dat1.pitchAngle3);
    catch
        dat1.pitchAngle = nan(length(dat1.Time), 1);
    end

    try
        dat1.NacelleDirection = double(ncread(FileName, 'Nacelle position'));
    catch
        dat1.NacelleDirection = nan(length(dat1.Time), 1);
    end

    try
        dat1.activePower = double(ncread(FileName, 'Power'));
    catch
        try
            dat1.activePower = double(ncread(FileName, 'Power, Active'));
        catch
            dat1.activePower = nan(length(dat1.Time), 1);
        end
    end

    try
        dat1.gridActivePower = double(-1 * ncread(FileName, 'Grid active power (3 phase) measured at grid inverter [Alstom nr. 5106]'));
    catch
        dat1.gridActivePower = nan(length(dat1.Time), 1);
    end

    try
        dat1.PowerSet = double(ncread(FileName, 'Turbine Power setpoint'));
    catch
        try 
            dat1.PowerSet = double(ncread(FileName, 'Power, Setpoint'));
        catch
            dat1.PowerSet = nan(length(dat1.Time), 1);
        end
    end

    try
        dat1.rho = double(ncread(FileName, 'Air Density'));
    catch
        dat1.rho = nan(length(dat1.Time), 1);
    end

    try
        dat1.TempExt = double(ncread(FileName, 'Ambient temperature'));
    catch
        try
            dat1.TempExt = double(ncread(FileName, 'Temperature, Outdoor'));
        catch
            dat1.TempExt = nan(length(dat1.Time), 1);
        end
    end

    Sim = dat1;

    %% check all data there
    % fill missing NaN and replace them using linear interpolation
    Sim = struct2table(Sim);

    % need to indicate is the time row
    Sim.Time = seconds(Sim.Time);

    % remove any duplicate time entrys
    [~, ind] = unique(Sim.Time);
    Sim = Sim(ind, :);
    
    % % % % refDate = datenum('1/1/1970 00:00:00');
    % % % % % fill in missing times with nan values
    % % % % if length(Sim.Time) < 86400
    % % % %     % check first reading is at start of day
    % % % %     Start_Time = datenum(Sim.Time(1)) + refDate;
    % % % %     Start_Time = datetime(Start_Time,'ConvertFrom','datenum', 'Format', 'dd/MM/yyyy HH:mm:ss');
    % % % %     Start_Time = Start_Time - hours(hour(Start_Time)) - minutes(minute(Start_Time)) - seconds(second(Start_Time));
    % % % %     Start_Time = seconds(convertTo(Start_Time, 'posixtime'));
    % % % %     tn = round((Sim.Time-Start_Time)/seconds(1))+1;
    % % % % 
    % % % %     if tn(1) ~= 1
    % % % %         row1 = Sim(1, :);
    % % % %         row1.Time = Start_Time;
    % % % %         row1(:, 2:end) = {nan};
    % % % %         Sim = [row1; Sim];
    % % % %         tn = round((Sim.Time-Start_Time)/seconds(1))+1;
    % % % %     end
    % % % % 
    % % % %     ti = linspace(1, 86400, 86400);
    % % % %     InterpSim = Sim;
    % % % %     InterpSim.Time = tn;
    % % % %     InterpSim = table2array(InterpSim);
    % % % %     InterpSim = interp1(tn, InterpSim, ti);
    % % % %     InterpSim = array2table(InterpSim);
    % % % %     InterpSim.Properties.VariableNames = Sim.Properties.VariableNames;
    % % % %     InterpSim.Time = seconds(InterpSim.Time) + Start_Time - seconds(1);
    % % % %     Sim = InterpSim;
    % % % % end
    % % % % 
    % % % % %% Convert to Sim format used traditionally in our simulations
    % % % % Sim = table2struct(Sim,'ToScalar',true);
    % % % % Sim_Time = datenum(Sim.Time) + refDate;
    % % % % Sim_Time = datetime(Sim_Time,'ConvertFrom','datenum', 'Format', 'dd/MM/yyyy HH:mm:ss');
    % % % % 
    % % % % Sim.Time = Sim_Time;
end