% test_windp2p_filterData

%% Generate dummy pre data for testing
data.ControlWTPre.Time = 0:1:400;
data.ControlWTPre.Time = data.ControlWTPre.Time + (rand(size(data.ControlWTPre.Time)) - 0.5) .* 0.1;

% create some gaps in the data
data.ControlWTPre.Time(data.ControlWTPre.Time >= 10 & data.ControlWTPre.Time <= 20) = [];
data.ControlWTPre.Time(data.ControlWTPre.Time >= 50 & data.ControlWTPre.Time <= 70) = [];
data.ControlWTPre.Time(data.ControlWTPre.Time >= 160 & data.ControlWTPre.Time <= 180) = [];

data.ControlWTPre.RPM = 8 .* sin (period2omega(60) .* data.ControlWTPre.Time) + 8;
data.ControlWTPre.PowerActive = 1e6 .* data.ControlWTPre.RPM;
data.ControlWTPre.TemperatureExternal = zeros (size (data.ControlWTPre.Time)) + 10;
data.ControlWTPre.DirectionNacelle = zeros (size (data.ControlWTPre.Time));

data.TestWTPre.Time = 3:1:500;
data.TestWTPre.Time = data.TestWTPre.Time + (rand(size(data.TestWTPre.Time)) -  0.5) .* 0.1;

% create some gaps in the data
data.TestWTPre.Time(data.TestWTPre.Time >= 15 & data.TestWTPre.Time <= 25) = [];
data.TestWTPre.Time(data.TestWTPre.Time >= 80 & data.TestWTPre.Time <= 90) = [];
data.TestWTPre.Time(data.TestWTPre.Time >= 150 & data.TestWTPre.Time <= 170) = [];

data.TestWTPre.RPM = 0.97 .* 8 .* sin (period2omega(60) .* data.TestWTPre.Time) + 8;
data.TestWTPre.PowerActive = 1.03 .* 1e6 .* data.TestWTPre.RPM;
data.TestWTPre.TemperatureExternal = zeros (size (data.TestWTPre.Time)) + 10;
data.TestWTPre.DirectionNacelle = zeros (size (data.TestWTPre.Time));

%% generate dummy post data for testing
data.ControlWTPost.Time = data.ControlWTPre.Time + 10000;
data.ControlWTPost.Time = data.ControlWTPost.Time + (rand(size(data.ControlWTPost.Time)) - 0.5) .* 0.1;

% data.ControlWTPost.Time(data.ControlWTPost.Time >= 10 & data.ControlWTPost.Time <= 20) = [];
% data.ControlWTPost.Time(data.ControlWTPost.Time >= 50 & data.ControlWTPost.Time <= 70) = [];
% data.ControlWTPost.Time(data.ControlWTPost.Time >= 160 & data.ControlWTPost.Time <= 180) = [];

data.ControlWTPost.RPM = 8 .* sin (period2omega(30) .* data.ControlWTPost.Time) + 8;
data.ControlWTPost.PowerActive = 1e6 .* data.ControlWTPost.RPM;
data.ControlWTPost.TemperatureExternal = zeros (size (data.ControlWTPost.Time)) + 10;
data.ControlWTPost.DirectionNacelle = zeros (size (data.ControlWTPost.Time));

data.TestWTPost.Time = data.TestWTPre.Time + 10000;
data.TestWTPost.Time = data.TestWTPost.Time + rand(size(data.TestWTPost.Time))*0.1;

% data.TestWTPost.Time(data.TestWTPost.Time >= 15 & data.TestWTPost.Time <= 25) = [];
% data.TestWTPost.Time(data.TestWTPost.Time >= 80 & data.TestWTPost.Time <= 90) = [];
% data.TestWTPost.Time(data.TestWTPost.Time >= 150 & data.TestWTPost.Time <= 170) = [];
% data.TestWTPost.Time

data.TestWTPost.RPM = 0.97 .* 8 .* sin (period2omega(30) .* data.TestWTPost.Time) + 8;
data.TestWTPost.PowerActive = 1.03 .* 1e6 .* data.TestWTPost.RPM;
data.TestWTPost.TemperatureExternal = zeros (size (data.TestWTPost.Time)) + 10;
data.TestWTPost.DirectionNacelle = zeros (size (data.TestWTPost.Time));

%% 

filtered_data = windp2p.syncAndFilterData (data, 'WindDirectionNumSamplesThresh', 20);

scatter ( data.ControlWTPre.Time, data.ControlWTPre.RPM, ...
          filtered_data.ControlWTPre.Time, filtered_data.ControlWTPre.RPM);

scatter ( data.TestWTPre.Time, data.TestWTPre.RPM, ...
          filtered_data.TestWTPre.Time, filtered_data.TestWTPre.RPM);