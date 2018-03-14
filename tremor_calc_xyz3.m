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

% 1. gyr opdelen in tijdsstukken

% bijv:
% time_tremor_calc = 25*60 = per minuut berekenen
% gyrfilt_devided = matrix waarin een colom data per minuut is
% aantal colommen = gelijk aan aantal minuten in signaal

timeframe_tremor_calc = fs*no_sec;  
L = length(gyr) - mod(length(gyr),timeframe_tremor_calc);  %  pakt alleen volledige blokken, bijv hele minuten

gyrx = reshape(gyr(1,1:L), timeframe_tremor_calc, []);
gyry = reshape(gyr(2,1:L), timeframe_tremor_calc, []);
gyrz = reshape(gyr(3,1:L), timeframe_tremor_calc, []);

[no_rows , no_columns ] = size(gyrx);
no_samples = no_rows;

% zo kun je alle signalen per timeframe zien
% plot(1:no_samples,gyrx)
% % en zo van een specifiek signaal
% plot(1:no_samples,gyrx(:,160))

% 2. maak powerspectrum gefilterde signalen per timeframe
% GYR geeft complexe getallen

for i = 1:no_columns
    
GYRx(:,i) = fft(gyrx(:,i));
GYRy(:,i) = fft(gyry(:,i));
GYRz(:,i) = fft(gyrz(:,i));

% gyrpowerx geeft de power weer van signalen 
gyrpowerx(:,i) = (abs(GYRx(:,i)).^2) /no_samples;
gyrpowery(:,i) = (abs(GYRy(:,i)).^2) /no_samples;
gyrpowerz(:,i) = (abs(GYRz(:,i)).^2) /no_samples;

end

% gyrpowerx is 160 colommen met daarin de power van verschillende
% frequentie. Nu pakken we voor alle 160 colommen alleen de power waardes
% tussen 4 en 8 Hz en nemen hier het gemiddelde van.

for i = 1:no_columns
powertremorbandx = gyrpowerx(4*(no_samples/12.5):(8*no_samples/12.5),i);
powertremorx(:,i) = powertremorbandx;
powertremorbandy = gyrpowery(4*(no_samples/12.5):(8*no_samples/12.5),i);
powertremory(:,i) = powertremorbandy;
powertremorbandz = gyrpowerz(4*(no_samples/12.5):(8*no_samples/12.5),i);
powertremorz(:,i) = powertremorbandz;

end

meanpowertremorx= mean(powertremorx);
meanpowertremory= mean(powertremory);
meanpowertremorz= mean(powertremorz);

tremormatrix = [meanpowertremorx; meanpowertremory; meanpowertremorz];
meanpowertremortot = mean(tremormatrix);
rmstremorpower = rms(tremormatrix);

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
