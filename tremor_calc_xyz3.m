function tremor_calc_xyz3(dataset,gyr,t,no_sec,start_time)
% The function tremor_calc_xyz requires a dataset, the gyroscope signal,
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

%% 1. divide the x,y,z gyroscope signals into timeframes

% for example:
% time_tremor_calc = fs*60 = devide in minutes
% gyr_devided = matrix in which each column represents data of one minute
% number of columns is therefore equal to the number of complete minutes in the signal

timeframe_tremor_calc = fs*no_sec;  
L = length(gyr) - mod(length(gyr),timeframe_tremor_calc);  %  only takes complete blocks

gyrx = reshape(gyr(1,1:L), timeframe_tremor_calc, []);
gyry = reshape(gyr(2,1:L), timeframe_tremor_calc, []);
gyrz = reshape(gyr(3,1:L), timeframe_tremor_calc, []);

[no_rows , no_columns ] = size(gyrx);
no_samples = no_rows;

% % plotting signals of all timeframes
% plot(1:no_samples,gyr_devided)
% % plotting a specific signal f.e. timeframe 160
% plot(1:no_samples,gyr_devided(:,160))

%% 2. make a power spectrum per timeframe
% GYR consists of complex numbers

for i = 1:no_columns
    
GYRx(:,i) = fft(gyrx(:,i));
GYRy(:,i) = fft(gyry(:,i));
GYRz(:,i) = fft(gyrz(:,i));

% gyrpowerx represents the power for the frequencies 
gyrpowerx(:,i) = (abs(GYRx(:,i)).^2) /no_samples;
gyrpowery(:,i) = (abs(GYRy(:,i)).^2) /no_samples;
gyrpowerz(:,i) = (abs(GYRz(:,i)).^2) /no_samples;

end

% gyrpower consists of 160 columns including the power of the various frequencies.
% Now we take the power between 4 and 8 Hz for each column.

for i = 1:no_columns
powertremorbandx = gyrpowerx(4*(no_samples/12.5):(8*no_samples/12.5),i);
powertremorx(:,i) = powertremorbandx;
powertremorbandy = gyrpowery(4*(no_samples/12.5):(8*no_samples/12.5),i);
powertremory(:,i) = powertremorbandy;
powertremorbandz = gyrpowerz(4*(no_samples/12.5):(8*no_samples/12.5),i);
powertremorz(:,i) = powertremorbandz;

end

% Calculate the mean tremor power between 4-8 Hz for x,y,z
meanpowertremorx= mean(powertremorx);
meanpowertremory= mean(powertremory);
meanpowertremorz= mean(powertremorz);

%% 3. combine x,y,z

% Make a matrix with the x,y,z components and calculate the ean and rms
tremormatrix = [meanpowertremorx; meanpowertremory; meanpowertremorz];
meanpowertremortot = mean(tremormatrix);
rmstremorpower = rms(tremormatrix);

%% 4. plot

figure(4)

timeaxis_days = t ./ (24 * 60 * 60) + start_time;
timeaxis_days_devided = reshape(timeaxis_days(1:L),timeframe_tremor_calc,[]);

plot(timeaxis_days_devided(1,:),meanpowertremorx,timeaxis_days_devided(1,:),meanpowertremory,timeaxis_days_devided(1,:),meanpowertremorz,timeaxis_days_devided(1,:),meanpowertremortot,timeaxis_days_devided(1,:),rmstremorpower)
datetick('x','HH:MM:SS');
ylim([0 12000]);
title(['Tremor power per ' num2str(no_sec) ' seconds'])
xlabel('time(h:m:s)')
ylabel('mean power between 4-8Hz')
legend('x','y','z','mean xyz', 'rms xyz')


% plot(1:no_columns,meanpowertremorx,1:no_columns,meanpowertremory,1:no_columns,meanpowertremorz,1:no_columns,meanpowertremortot,1:no_columns,rmstremorpower)
% title(['Tremor power per ' num2str(no_sec) ' seconds'])
% xlabel(['specified timeframe (' num2str(no_sec) ' seconds)'])
% ylabel('mean power between 4-8Hz')
% legend('x','y','z','mean xyz', 'rms xyz')

end
