function tremor_calc3(dataset,gyr,t,no_sec,start_time)
% The function tremor_calc requires a dataset, the gyroscope signal, 
% the number of seconds and the start_time. The FFT will
% be applied to obtain power of the signal between 4 and 8 Hz.
% Total_tremor_power is the mean power in 4-8 Hz band of whole signal
% Tremor_power_per_timeframe is the mean power in 4-8 Hz band in timeframe
% which is specified by no_sec.

fs = getfield(dataset,'fsample');
N = length(gyr);
k = [0:N-1];
dt = 1/fs;
f = k*(1/(N*dt));

%% 1. add gyroscope signals. 
gyrsum = sqrt(gyr(1,:).^2+ gyr(2,:).^2+gyr(3,:).^2);

%% 2. devide gyroscope signal in timeframes

% for example:
% time_tremor_calc = fs*60 = devide in minutes
% gyr_devided = matrix in which each column represents data of one minute
% number of columns is therefore equal to the number of complete minutes in the signal

timeframe_tremor_calc = fs*no_sec;  
L = length(gyrsum) - mod(length(gyrsum),timeframe_tremor_calc);  %  only takes complete blocks
gyr_devided = reshape(gyrsum(1:L),timeframe_tremor_calc,[]);

[no_rows , no_columns ] = size(gyr_devided);
no_samples = no_rows;

% % plotting signals of all timeframes
% plot(1:no_samples,gyr_devided)
% % plotting a specific signal f.e. timeframe 160
% plot(1:no_samples,gyr_devided(:,160))

%% 3. make a power spectrum per timeframe
% GYR consists of complex numbers
 
GYR = fft(gyr_devided);
% fft is applied to each column, so per timeframe

gyrpower = (abs(GYR).^2) /no_samples;

% gyrpower consists of 160 columns including the power of the various frequencies.
% Now we take the average power between 4 and 8 Hz for each column.

for i = 1:no_columns
powertremorband = gyrpower(4*(no_samples/12.5):(8*no_samples/12.5),i);
powertremor(:,i) = powertremorband;
end

meanpowertremor = mean(powertremor);

figure(2)
timeaxis_days = t ./ (24 * 60 * 60) + start_time;
timeaxis_days_devided = reshape(timeaxis_days(1:L),timeframe_tremor_calc,[]);
plot(timeaxis_days_devided(1,:),meanpowertremor)
datetick('x','HH:MM:SS');
ylim([0 12000]);
% plot(1:no_columns,meanpowertremor)
% title(['Tremor power per ' num2str(no_sec) ' seconds'])
% xlabel(['specified timeframe (' num2str(no_sec) ' seconds)'])
title(['Tremor power per ' num2str(no_sec) ' seconds'])
xlabel('time(h:m:s)');
ylabel('mean power between 4-8Hz');

end



