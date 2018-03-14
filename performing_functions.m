function tremor_scores(filenumber)

clc;
clear all;

% als margot de user is voer je deze regels uit 
addpath(genpath('C:\Users\Margot Heijmans\Documents\MATLAB'))
addpath(genpath('C:\Users\Margot Heijmans\Documents\Mox Data'))

[file,starting_time_measurement] = select_MOX_file(filenumber);
% 1 = borst, 2 = rpols, 3 = lpols, 4 = poli1, 5 = poli2

[dataset,acc,gyr,start_time,t] = read_edf_file(file,starting_time_measurement);

no_sec = 60; 

% [tremor_power_per_timeframex,tremor_power_per_timeframey,tremor_power_per_timeframez] = tremor_calc_xyz(dataset,gyr,no_sec);

% tremor_calc2(dataset,gyr,t,no_sec,start_time);

tremor_calc3(dataset,gyr,t,no_sec,start_time);

% dysk_calc2(dataset,acc,t,no_sec,start_time);
% 
% tremor_calc_xyz2(dataset,gyr,t,no_sec,start_time);

tremor_calc_xyz3(dataset,gyr,t,no_sec,start_time);

end
