%% Compare dtw_label_data with ground truth label data
clc;

Time_lat_load  = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ground_truth_label_load.xlsx','label_ego','A:A');
Label_ego_lat_load= xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ground_truth_label_load.xlsx' ,'label_ego','B:B');
save ('gt_lat_data.mat','Time_lat_load','Label_ego_lat_load');

Loop_start_time = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.75_5.4.xlsx','Label_ego','B:B');
Loop_stop_time = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.75_5.4.xlsx','Label_ego','C:C');
dtw_label_ego_lat = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.75_5.4.xlsx','Label_ego','E:E');
save('dtw_lat_data.mat','Loop_start_time','Loop_stop_time','dtw_label_ego_lat');

L1 = length(dtw_label_ego_lat);
L2 = length(Label_ego_lat_load);
m = 1;
k = 1;
nrofrightmatch = 0;                         % number of matched lane change right
nrofleftmatch = 0;                          % number of matched lane change left
nrofdtwright = 0;                           % number of dtw lane change right
nrofdtwleft = 0;                            % number of dtw lane change left 



for m = 1 : L1
    
    dtw_label = load('dtw_lat_data.mat');
    gt_label = load('gt_lat_data.mat');
    dtw_label_m = dtw_label.dtw_label_ego_lat(m,1);
    start_time_m = dtw_label.Loop_start_time(m,1);
    stop_time_m = dtw_label.Loop_stop_time(m,1);

  

    if dtw_label_m == 1
       nrofdtwright = nrofdtwright + 1;
       for k = 1 :L2
          gt_label_k = gt_label.Label_ego_lat_load(k,1);
          gt_Time_k = gt_label.Time_lat_load(k,1);
          if (gt_label_k == 1) && (start_time_m <= gt_Time_k) && (gt_Time_k <= stop_time_m)          
               nrofrightmatch = nrofrightmatch + 1;
               break; 
          end  
       end
      
       
    elseif dtw_label_m == -1
        nrofdtwleft = nrofdtwleft + 1;
        for k = 1 :L2 
          gt_label_k = gt_label.Label_ego_lat_load(k,1);
          gt_Time_k = gt_label.Time_lat_load(k,1);
          if (gt_label_k == -1) && (start_time_m <= gt_Time_k) && (gt_Time_k <= stop_time_m)
               nrofleftmatch = nrofleftmatch + 1;
               break;
          end   
        end
        
    end
        
end

%% Output
 accuracy_ego_lat_right = nrofrightmatch / nrofdtwright;
 accuracy_ego_lat_left = nrofleftmatch / nrofdtwleft;

 str3 = ['D',num2str(3)];
 str4 = ['D',num2str(4)];
 str5 = ['D',num2str(5)];
 str6 = ['D',num2str(6)];
 str7 = ['D',num2str(7)];
 str8 = ['D',num2str(8)];

 results3 = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Accuracy_dtw_slidingwindow.xlsx',nrofdtwright,'accuracy_ego',str3);
 results4 = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Accuracy_dtw_slidingwindow.xlsx',nrofdtwleft,'accuracy_ego',str4);
 results5 = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Accuracy_dtw_slidingwindow.xlsx',nrofrightmatch,'accuracy_ego',str5);
 results6 = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Accuracy_dtw_slidingwindow.xlsx',nrofleftmatch,'accuracy_ego',str6);
 results7 = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Accuracy_dtw_slidingwindow.xlsx',accuracy_ego_lat_right,'accuracy_ego',str7);
 results8 = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Accuracy_dtw_slidingwindow.xlsx',accuracy_ego_lat_left,'accuracy_ego',str8);
 
 