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

% 1. gyr samennemen. x+y+z
gyrsum = sqrt(gyr(1,:).^2+ gyr(2,:).^2+gyr(3,:).^2);

% 2. gyr opdelen in tijdsstukken

% bijv:
% time_tremor_calc = fs*60 = per minuut berekenen
% gyr_devided = matrix waarin een kolom data per minuut is
% aantal colommen = gelijk aan aantal (complete) minuten in signaal

timeframe_tremor_calc = fs*no_sec;  
L = length(gyrsum) - mod(length(gyrsum),timeframe_tremor_calc);  %  pakt alleen volledige blokken, bijv hele minuten
gyr_devided = reshape(gyrsum(1:L),timeframe_tremor_calc,[]);

[no_rows , no_columns ] = size(gyr_devided);
no_samples = no_rows;

% % zo kun je alle signalen per timeframe zien
% plot(1:no_samples,gyr_devided)
% % en zo van een specifiek signaal
% plot(1:no_samples,gyr_devided(:,160))

% 3. maak powerspectrum gefilterde signalen per timeframe
% GYR geeft complexe getallen
 
GYR = fft(gyr_devided);
% fft is applied to each column, dus per tijdsbestek
gyrpower = (abs(GYR).^2) /no_samples;

% gyrpower is 160 kolommen met daarin de power van verschillende
% frequentie. Nu pakken we voor alle 160 kolommen alleen de power waardes
% tussen 4 en 8 Hz en nemen hier het gemiddelde van.

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



