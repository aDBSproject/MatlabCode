function [file, starting_time_measurement] = select_MOX_file(filenumber)

if filenumber == 1
    file  = 'C:\Users\Margot Heijmans\Documents\Mox Data\13337_20180203_094429.bdf';
    starting_time_measurement = '09:44:29';
elseif filenumber == 2
    file   = 'C:\Users\Margot Heijmans\Documents\Mox Data\13337_20180209_070919.bdf';
    starting_time_measurement = '07:09:19';
elseif filenumber == 3
    file = 'C:\Users\Margot Heijmans\Documents\Mox Data\13337_20180214_092645.bdf'
    starting_time_measurement = '09:26:45';
elseif filenumber == 4
    % dataset poli ochtend 22-02
    file = 'C:\Users\Margot Heijmans\Documents\Mox Data\13337_20180222_084905.bdf'
    starting_time_measurement = '08:49:05';
elseif filenumber == 5
    % dataset poli ochtend 1-03
    file = 'C:\Users\Margot Heijmans\Documents\Mox Data\13337_20180301_084331.bdf'
    starting_time_measurement = '08:43:31';
else disp('deze file bestaat niet')
    
end

end
