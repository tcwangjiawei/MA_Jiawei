function [Lanechange] = Lanechange_label(~)

%% Export labels over time
%write header to file

fid = fopen('F:\MA_Jiawei\Masterarbeit-ITIV\Key Paper\MA_Testing\Lanechange_label.XLS','w'); 
export_array = ['Time', 'label.ego.long','label.ego.lat',' label.T00.long',' label.T00.lat'];
% fprintf(fid,'%s\n',export_array);
flabel = xlswrite(fid,export_array);
% fclose(fid);

% %write data to end of file
% export_array = ['Time', 'label.ego.long' 'label.ego.lat' 'label.T00.long' 'label.T00.lat'];
% % export_array = [Time', label.ego.long' label.ego.lat' label.T00.long' label.T00.lat' label.T1.long' label.T1.lat'];
% dlmwrite('F:\MA_Jiawei\Masterarbeit-ITIV\Key Paper\MA_Testing\Lanechange_label.xlsx',export_array,'-append');

end