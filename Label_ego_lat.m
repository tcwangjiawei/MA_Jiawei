%%  Label_ego_lat (lcr = lane change right, lcl = lane change left, lk = lane keeping,Shift(0.25 * windLen) and Windlen(540))
%  S is the orignal signal
%  R_lcr is the reference siggnal for lane change right 
%  R_lcl is the reference siggnal for lane change left
%  Slidiwindow parameter: Shift(0.75 * windLen) and Windlen(540).

Signal = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023','A:A');
R_lcr = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_SWnR','A4:A543');
R_lcl = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_SWnL','A:A');
start_time = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023','B:B');
stop_time = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023','B:B');
save('dataprepation.mat','Signal','R_lcr','R_lcl','start_time','stop_time');


Lsignal = length(Signal);           % M: the length of sequence Q Sampling data
N_lcr = length(R_lcr);              % N: the length of sequence C Reference signal
N_lcl = length(R_lcl); 


%% Sliding window initialization
windLen = N_lcr ;                   % Window length
m = 1 ;                             % Sliding window signal start id (dataprepation.mat)
n = m + windLen ;                   % Sliding window signal end id An
k = 1;                              % Inter for str

start = m ;                         % Slidong window start
shift = round (0.75 * windLen) ;       % Sliding window overlap  
stop = Lsignal - N_lcr ;            % Slidong window stop
nrOfLoop = 1 ;                      % Number of loops

th_value_lcr = 10 ;                 % Threshold value for lane change right classification
th_value_lcl = 10 ;                 % Threshold value for lane change left classification

number_loop = zeros();
lstart_time = zeros();
lstop_time = zeros();
dtw_d = zeros();
labeling = zeros();
all_d_lcl = zeros();
all_d_lcr = zeros();

%%  Sliding Window with DTW Algorithmus

for L = start : shift : stop
    
   D = load('dataprepation.mat');
   
   
   str1 = ['A',num2str(m),':','A',num2str(n)]; 
  
   loop_start_time = D.start_time(m);
   loop_stop_time = D.start_time(n);
   
   S = D.Signal(m:n);  % Signal in Sliding window
   save ('S.mat','S');
   SD = load ('S.mat');
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
             d_lcr = norm(SD.S(i-1)-D.R_lcr(j-1));
             DTW(i,j) = d_lcr+ min([DTW(i-1,j),DTW(i,j-1),DTW(i-1,j-1)]);
         end
     end

     d_lcr = DTW(M+1,N_lcr+1);
     all_d_lcr(k,1) = d_lcr;

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
             d_lcl = norm(SD.S(i-1)-D.R_lcl(j-1));
             DTW(i,j) = d_lcl+ min([DTW(i-1,j),DTW(i,j-1),DTW(i-1,j-1)]);
         end
     end

     d_lcl = DTW(M+1,N_lcl+1);
     all_d_lcl(k,1) = d_lcl;
     

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
  
   number_loop(k,1) = nrOfLoop;
   lstart_time(k,1) = loop_start_time;
   lstop_time(k,1) = loop_stop_time;
   dtw_d(k,1) = d;
   labeling(k,1) = label;
  
   m = m + shift ;
   n = n + shift ;
   nrOfLoop = nrOfLoop + 1 ;
   k = k + 1; 
   
end

str2 = ['A',num2str(2),':','A',num2str(k + 2)];         % Inter for number of loops% Inter for sliding window start time 
str3 = ['B',num2str(2),':','B',num2str(k + 2)];         % Inter for sliding window start time 
str4 = ['C',num2str(2),':','C',num2str(k + 2)];         % Inter for sliding window stop time 
str5 = ['D',num2str(2),':','D',num2str(k + 2)];         % Inter for  dtw Ergebnis 
str6 = ['E',num2str(2),':','E',num2str(k + 2)];        
str7 = ['F',num2str(2),':','F',num2str(k + 2)];         
str8 = ['G',num2str(2),':','G',num2str(k + 2)];         

Numberofloop = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.75_5.4.xlsx',number_loop ,'Label_ego',str2);
St1 = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.75_5.4.xlsx',lstart_time ,'Label_ego',str3);
St2 = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.75_5.4.xlsx',lstop_time ,'Label_ego',str4);
all_d_lcr = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.75_5.4.xlsx',all_d_lcr ,'Label_ego',str5);
all_d_lcl = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.75_5.4.xlsx',all_d_lcl,'Label_ego',str6);
dtw_d = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.75_5.4.xlsx',dtw_d ,'Label_ego',str7);
Output_label = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\DTW_Ergebnis_0.75_5.4.xlsx',labeling ,'Label_ego',str8);



