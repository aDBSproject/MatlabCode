% After recording, data was downloaded, digitally filtered to
% include frequencies between 0.2 Hz and 4Hz and analysed
% to produce bradykinesia and dyskinesia scores every two minutes.

% Every 2 minutes, the average acceleration and mean spectral power 
% is calculated. Dyskinesia results in higher mean spectral power in 
% movements which are slower than average, and spent more time in making
% movements with higher acceleration than average. 


function dysk_calc_grif(dataset,acc,t,start_time)

fs = getfield(dataset,'fsample');
N = length(acc);
k = [0:N-1];
dt = 1/fs;
f = k*(1/(N*dt));

%% 1. add accelerometer signals and filter between 0.2 and 4 Hz. 
accsum = sqrt(acc(1,:).^2+ acc(2,:).^2+acc(3,:).^2);


% filter
Wn = [0.2 4]/(fs/2);
[B,A] = butter(2,Wn);

% filter
accfilt = filtfilt(B,A,accsum);

%% 2. devide accelerometer signal in timeframes

% for example:
% time_tremor_calc = fs*60 = devide in minutes
% gyr_devided = matrix in which each column represents data of one minute
% number of columns is therefore equal to the number of complete minutes in the signal

no_sec = 120;
timeframe = fs*no_sec;  
L = length(accfilt) - mod(length(accfilt),timeframe);  %  only takes complete blocks
acc_devided = reshape(accfilt(1:L),timeframe,[]);

[no_rows , no_columns ] = size(acc_devided);
no_samples = no_rows;

%% 3. take average acceleration over 2 min epoch

meanacc = mean(abs(acc_devided));

% plot mean acceleration of each 2 minutes
figure(2) 
timeaxis_days = t ./ (24 * 60 * 60) + start_time;
timeaxis_days_devided = reshape(timeaxis_days(1:L),timeframe,[]);
plot(timeaxis_days_devided(1,:),meanacc)
datetick('x','HH:MM:SS');
title('mean acceleration between 0.2-4 Hz of acceleration epochs')
xlabel('time')
ylabel('acc(g)')

%% 4. calculate mean spectral power 0.2-4Hz in 2 min epoch

ACC = fft(acc_devided);
% fft is applied to each column, so per timeframe

accpower = (abs(ACC).^2) /no_samples;

% % an example to plot 1 of the power spectra
% test = accpower(:,1);
% N = length(test);
% k = [0:N-1];
% dt = 1/fs;
% f = k*(1/(N*dt));
% plot(f(1:(N/2)), test(1:(N/2)));


for i = 1:no_columns
powerbradyband(:,i) = accpower(0.2*(no_samples/12.5):(4*no_samples/12.5),i);
end

% take average of samples representing power at 0.2-4Hz
meanpowerbradyband = mean(powerbradyband);

% plot the mean power between 0.2-4Hz for every timeframe
figure(3)
plot(timeaxis_days_devided(1,:), meanpowerbradyband);
datetick('x','HH:MM:SS');
title('mean power of acceleration epochs between 0.2-4 Hz')
xlabel('time')
ylabel('p^2')



