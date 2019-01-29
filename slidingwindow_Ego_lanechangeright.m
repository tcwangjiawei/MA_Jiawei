%  Ego- Test for Lanechange right

 S = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023','A:A');      
 R = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_SWnR','A:A');


M = length(S);          % M: the length of sequence Q Sampling data
N = length(R);          % N: the length of sequence C Reference signal

windLen = N ;            % Window length
m = 4 ;                  % Sliding window signal start id A4 (Excel Tabelle)
n = m + windLen ;        % Sliding window signal end id An
k = 2;                   % Inter for str

start = m ;              % Slidong window start
shift = round (0.5 * windLen) ;   % Sliding window overlap  
stop = M - N ;           % Slidong window stop
nrOfLoop = 1 ;             % Number of loops

th_value = 10 ;            % Threshold value for lane change classification

%%  Sliding Window with DTW Algorithmus

for L = start : shift : stop
    
   str1 = ['A',num2str(m),':','A',num2str(n)]; 
   str2 = ['A',num2str(k)];      % Inter for number of loops% Inter for sliding window start time 
   str3 = ['B',num2str(k)];      % Inter for sliding window start time 
   str4 = ['C',num2str(k)];      % Inter for sliding window stop time 
   str5 = ['D',num2str(k)];      % Inter for  dtw Ergebnis 
   str6 = ['E',num2str(k)];      % Inter for  labeling
   S = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023',str1);
   R = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_SWnR','A4:A543');
   start_time = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023',['B',num2str(m)]);
   stop_time = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023',['B',num2str(n)]);
   w = 1000;
   M = length(S);
   N = length(R);
   
% %% DTW initiation
     DTW = zeros(M+1,N+1);
     w = max([w,abs(M-N)]);

     for i = 2:M+1
         for j =2:N+1
             DTW(i,j) = inf;
         end
     end
     DTW(1,1) = 0;

%% DTW algorithm
     % d(i,j):The distance between S(i)and R(j)
     for i = 2:M+1
         for j = max([2,i-w+1]) : min([N+1,i+w+1])
             d = norm(S(i-1)-R(j-1));
             DTW(i,j) = d+ min([DTW(i-1,j),DTW(i,j-1),DTW(i-1,j-1)]);
         end
     end

     d = DTW(M+1,N+1);
%%  Labeling lane change right     
     if d <= th_value
        label = 1 ;      % 1 means lane change right happens
     else
         label = 0 ;      % 1 means lane change right does not happens
     end

 
   I = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Dtw_Ergebnis.xlsx',nrOfLoop ,'E_SWnR',str2);
   St1 = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Dtw_Ergebnis.xlsx',start_time ,'E_SWnR',str3);
   St2 = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Dtw_Ergebnis.xlsx',stop_time ,'E_SWnR',str4);
   E = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Dtw_Ergebnis.xlsx',d ,'E_SWnR',str5);
   Labeling = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Dtw_Ergebnis.xlsx',label ,'E_SWnR',str6);
   m = m + shift ;
   n = n + shift ;
   nrOfLoop = nrOfLoop + 1 ;
   k = k + 1;
   
end
