% After recording, data was downloaded, digitally filtered to
% include frequencies between 0.2 Hz and 4Hz and analysed
% to produce bradykinesia and dyskinesia scores every two minutes.
% A bradykinesia score (BKS) was produced by establishing
% the maximum acceleration in each 2 minute
% epoch of acceleration recordings and calculating the
% MSP surrounding this peak. The rationale was that
% normal subjects commonly move with higher accelerations
% and energy than bradykinetic subjects

% Mean Spectral Power (MSP) within bands
% of acceleration between 0.2 and 4 Hz

% function according to griffiths = PKG

function brady_calc(dataset,acc,t,start_time)

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

%% 3. take max acceleration of each 2 min epoch = max of each column

% take the max acceleration and the belonging measurement
[maxacc,maxacctime] = max(acc_devided,[],1);

% plot max acceleration of each 2 minutes
figure(2) 
timeaxis_days = t ./ (24 * 60 * 60) + start_time;
timeaxis_days_devided = reshape(timeaxis_days(1:L),timeframe,[]);
plot(timeaxis_days_devided(1,:),maxacc)
datetick('x','HH:MM:SS');
title('max acceleration of acceleration epochs between 0.2-4 Hz')
xlabel('time')
ylabel('acc(g)')

%% 4. calculate mean spectral power in 0.2-4Hz surrounding this peak

% surrounding this peak = 5 samples before and 5 after max acc peak
% for i = 1:length(maxacctime)
% surroundingmaxacc(:,i) = acc_devided([(maxacctime(i) - 3) : (maxacctime(i) +3)])
% end
% ACC = fft(surroundingmaxacc);

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

%% make plot of acc sum and filtered acc

figure(4)
subplot(2,1,1)
plot(timeaxis_days,accsum)
datetick('x','HH:MM:SS');
title('sum acceleration')
xlabel('time')
ylabel('acc(g)')
subplot(2,1,2)
plot(timeaxis_days,accfilt)
datetick('x','HH:MM:SS');
title('filtered acceleration 0.2-4Hz')
xlabel('time')
ylabel('acc(g)')


