function tremor_scores(filenumber)

[file,starting_time_measurement] = select_MOX_file(filenumber);
% 1 = borst, 2 = rpols, 3 = lpols, 4 = poli1, 5 = poli2

[dataset,acc,gyr,start_time,t] = read_edf_file(file,starting_time_measurement);

no_sec = 60; 

dysk_calc3(dataset,acc,t,no_sec,start_time);
% tremor_calc3(dataset,gyr,t,no_sec,start_time);
% 
% tremor_calc_xyz3(dataset,gyr,t,no_sec,start_time);

end
