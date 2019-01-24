%% Test for Lanechange right

 S = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023','A:A');      
 R = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_SWnR','A:A');
% M: the length of sequence Q Sampling data
% N: the length of sequence C Reference signal
M = length(S);
N = length(R);

windLen = N; % Window length
m = 4;       % Signal start id A4
n = windLen; % Signal end id An
k = 2;

nrOfLoop = floor(M/N); % Number of loops

for L = 1:nrOfLoop
    
   str1 = ['A',num2str(m),':','A',num2str(n)];
   str2 = ['B',num2str(k)];
   str3 = ['A',num2str(k)];
   S = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023',str1);
   R = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_SWnR','A4:A543');
   w = 1000;
   M = length(S);
   N = length(R);
   
%% DTW initiation
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

 
   I = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Dtw_Ergebnis.xlsx',L ,'E_SWnR',str3);
   E = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Dtw_Ergebnis.xlsx',d ,'E_SWnR',str2);
   m = m + windLen;
   n = n + windLen;
   k = k + 1;
   
end
