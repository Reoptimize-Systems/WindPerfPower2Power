clear;clc % forgive me for my sins!

%%

filtered_data = windp2p.syncAndFilterData(data, 'WindDirectionNumSamplesThresh', 20, 'CurtailedFilterMethod','daily_times_and_durations');

%%

figure(101)
scatter(data.ControlWTPre.Time, data.ControlWTPre.RPM,'*')
hold on
scatter(filtered_data.ControlWTPre.Time, filtered_data.ControlWTPre.RPM);
hold off
grid on
legend 'unfiltered' 'filtered'

figure(102)
scatter(data.TestWTPre.Time, data.TestWTPre.RPM,'*')
hold on
scatter(filtered_data.TestWTPre.Time, filtered_data.TestWTPre.RPM)
hold off
grid on
legend 'unfiltered' 'filtered'

%%

figure(1)
plot(data.ControlWTPre.Time,data.ControlWTPre.RPM,'x')
grid on

figure(1)
plot(data.ControlWTPre.Time,data.ControlWTPre.PowerActive,'x')
grid on

figure(1)
plot(data.ControlWTPre.Time,data.ControlWTPre.TemperatureExternal,'x')
grid on

figure(1)
plot(data.ControlWTPre.Time,data.ControlWTPre.DirectionNacelle,'x')
grid on

figure(1)
plot(data.ControlWTPost.Time,'x')
grid on

test_rand = (rand(size(data.ControlWTPost.Time)) - 0.5) .* 0.1;

figure(1)
plot(data.ControlWTPost.Time,test_rand)
grid on

%% more plots under trial



figure(222)
ax1=subplot(2,1,1)
plot(DateTimeControlWTPre,data.ControlWTPre.PowerActive)
grid on
ax2=subplot(2,1,2)
% plot(DateTimeControlWTPre,data.ControlWTPre.ErrorCode) % ErrorCode seems to corrolate with dips in power
% plot(DateTimeControlWTPre,data.ControlWTPre.WpsStatus) % WpsStatus seems to corrolate with shut downs
% plot(DateTimeControlWTPre,data.ControlWTPre.WTOperationState) % WTOperationState seems to corrolate with dips in power
plot(DateTimeControlWTPre,data.ControlWTPre.ProductionFactor) % ProductionFactor is unclear but much more variable

grid on
linkaxes([ax1 ax2],'x')



