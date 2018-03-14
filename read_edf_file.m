function [dataset,acc,gyr,start_time,t] = read_edf_file(file,starting_time_measurement)

% define file and load edf/bdf file
cfg            = [];

cfg.dataset    = file;
cfg.continuous = 'yes';
cfg.channel    = 'all';
dataset        = ft_preprocessing(cfg);

% access the data
dataruw = cell2mat(getfield(dataset,'trial'));

% make timescale for plot
fs = getfield(dataset,'fsample');
t = cell2mat(getfield(dataset,'time'));

% define the different data types
acc1 = dataruw(1:3,:);
acc2 = dataruw(4:6,:);
% dit is degene die in de 6 DOF sensor blijft zitten
gyr = dataruw(7:9,:);

% nu gaan we de begin en eind data er uit halen waarin de sensor niet werd
% gedragen. Hiervoor kijken we naar eerste en laatste data in x,y,z en
% richting kleiner dan -40 of groter dan 40 (gebaseerd op kijken naar data)

index1 = find(gyr(1,:) > 60 | gyr(1,:) < -60, 1, 'first'); % Find left index
index2 = find(gyr(1,:) > 60 | gyr(1,:) < -60, 1, 'last'); % Find right index.
index3 = find(gyr(2,:) > 60 | gyr(1,:) < -60, 1, 'first'); % Find left index
index4 = find(gyr(2,:) > 60 | gyr(1,:) < -60, 1, 'last'); % Find right index.
index5 = find(gyr(3,:) > 60 | gyr(1,:) < -60, 1, 'first'); % Find left index
index6 = find(gyr(3,:) > 60 | gyr(1,:) < -60, 1, 'last'); % Find right index.

first_signal = [index1 index3 index5];
last_signal = [index2 index4 index6];

indexfirst = min(first_signal);
indexlast = max(last_signal);

% nu de signalen vervangen door gecropte signaal
gyr = gyr(:,indexfirst:indexlast);
acc = acc2(:,indexfirst:indexlast);
t = t(indexfirst:indexlast);

restoredefaultpath
rehash toolboxcache

start_time = datenum(starting_time_measurement,'HH:MM:SS');
timeaxis_days = t ./ (24 * 60 * 60) + start_time;

% subbplot the different data types
figure(1)
title('Graph of 6DOF sensor chest')
subplot(2,1,1);
plot(timeaxis_days,acc);
ylim([-4 4]);
xlabel('time(s)')
ylabel('acceleration(g)')
legend('x','y','z')
title('acc');
datetick('x','HH:MM:SS');
subplot(2,1,2);
plot(timeaxis_days,gyr);
xlabel('time(s)');
ylabel('velocity(deg/s)');
title('gyr');
legend('x','y','z')
datetick('x','HH:MM:SS');

end
