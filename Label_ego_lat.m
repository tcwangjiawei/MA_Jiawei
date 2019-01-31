%  Label_ego_lat (lcr = lane change right, lcl = lane change left, lk = lane keeping)
%  S is the orignal signal
%  R_lcr is the reference siggnal for lane change right 
%  R_lcl is the reference siggnal for lane change left
%  Slidiwindow parameter: Shift(0.75 winLen, 0.5 windlen. 0.25 windLen) and Windlen. 
%  th_value_lcr = Threshold value for lane change right classification
%  th_value_lcl = Threshold value for lane change left classification

S = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023','A:A');
R_lcr = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_SWnR','A4:A543');
R_lcl = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_SWnL','A:A');
start_time = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023','B:B');
stop_time = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023','B:B');


M = length(S);                      % M: the length of sequence Q Sampling data
N_lcr = length(R_lcr);              % N: the length of sequence C Reference signal
N_lcl = length(R_lcl); 


%% Sliding window initialization
windLen = N_lcr ;                   % Window length
m = 4 ;                             % Sliding window signal start id A4 (Excel Tabelle)
n = m + windLen ;                   % Sliding window signal end id An
k = 2;                              % Inter for str

start = m ;                         % Slidong window start
shift = round (0.25 * windLen) ;    % Sliding window overlap  
stop = M - N_lcr ;                  % Slidong window stop
nrOfLoop = 1 ;                      % Number of loops

th_value_lcr = 10 ;                 % Threshold value for lane change right classification
th_value_lcl = 10 ;                 % Threshold value for lane change left classification

%%  Sliding Window with DTW Algorithmus

for L = start : shift : stop
    
   str1 = ['A',num2str(m),':','A',num2str(n)]; 
   str2 = ['A',num2str(k)];         % Inter for number of loops% Inter for sliding window start time 
   str3 = ['B',num2str(k)];         % Inter for sliding window start time 
   str4 = ['C',num2str(k)];         % Inter for sliding window stop time 
   str5 = ['D',num2str(k)];         % Inter for  dtw Ergebnis 
   str6 = ['E',num2str(k)];         % Inter for  labeling
   
   S = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023',str1);
   R_lcr = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_SWnR','A4:A543');
   R_lcl = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_SWnL','A:A');
   start_time = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023',['B',num2str(m)]);
   stop_time = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023',['B',num2str(n)]);
   w = 1000;
   M = length(S);
   N_lcr = length(R_lcr);
   N_lcl = length(R_lcl);
   
%% DTW algorithm (lane change right)   
     % DTW initiation
   
     DTW = zeros(M+1,N_lcr+1);
     w = max([w,abs(M-N_lcr)]);

     for i = 2:M+1
         for j =2:N_lcr+1
             DTW(i,j) = inf;
         end
     end
     DTW(1,1) = 0;

     % d(i,j):The distance between S(i)and R(j)
     for i = 2:M+1
         for j = max([2,i-w+1]) : min([N_lcr+1,i+w+1])
             d_lcr = norm(S(i-1)-R_lcr(j-1));
             DTW(i,j) = d_lcr+ min([DTW(i-1,j),DTW(i,j-1),DTW(i-1,j-1)]);
         end
     end

     d_lcr = DTW(M+1,N_lcr+1);

%% DTW algorithm (lane change left)   
   % DTW initiation
   
     DTW = zeros(M+1,N_lcl+1);
     w = max([w,abs(M-N_lcl)]);

     for i = 2:M+1
         for j =2:N_lcl+1
             DTW(i,j) = inf;
         end
     end
     DTW(1,1) = 0;
     
     % d(i,j):The distance between S(i)and R(j)
     for i = 2:M+1
         for j = max([2,i-w+1]) : min([N_lcl+1,i+w+1])
             d_lcl = norm(S(i-1)-R_lcl(j-1));
             DTW(i,j) = d_lcl+ min([DTW(i-1,j),DTW(i,j-1),DTW(i-1,j-1)]);
         end
     end

     d_lcl = DTW(M+1,N_lcl+1);

%%  Labeling (lane change right, lane chang left, lane keeping)     
    
    if d_lcr <= th_value_lcr
         label = 1 ;                    % 1 means lane change right happens
         d = d_lcr ; 
    elseif d_lcl <= th_value_lcl
         label = -1 ;                   % -1 means lane change left happens
         d = d_lcl ;
    else
         label = 0;                     % 0 means lane keeping happens
         d = 0;
    end
    
 %% Output(number of Loop,Sliding window start/stop time, DTW distance, labeling)  
 
   I = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.25_5.4.xlsx',nrOfLoop ,'Label_ego',str2);
   St1 = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.25_5.4.xlsx',start_time ,'Label_ego',str3);
   St2 = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.25_5.4.xlsx',stop_time ,'Label_ego',str4);
   E = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.25_5.4.xlsx',d ,'Label_ego',str5);
   Labeling = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.25_5.4.xlsx',label ,'Label_ego',str6);
   m = m + shift ;
   n = n + shift ;
   nrOfLoop = nrOfLoop + 1 ;
   k = k + 1; 
   
end
