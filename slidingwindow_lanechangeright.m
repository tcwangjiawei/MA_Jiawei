% Test for Lanechange right

 S = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023','A:A');      
 R = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_SWnR','A:A');
% M: the length of sequence Q Sampling data
% N: the length of sequence C Reference signal
M = length(S);
N = length(R);

windLen = N; % Window length
m = 1;
n = windLen;
k = 2;

nrOfLoop = floor(M/N); % Number of loops

for i = 1:nrOfLoop
    
   str1 = ['A',num2str(m),':','A',num2str(n)];
   str2 = ['B',num2str(k)];
   str3 = ['A',num2str(k)];
   S = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023',str1);
   R = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_SWnR','A:A');
   w = 1000;
   d = dtw_lanechangeright(S,R,w);
   I = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Dtw_Ergebnis.xlsx',i ,'E_SWnR',str3);
   E = xlswrite('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Dtw_Ergebnis.xlsx',d ,'E_SWnR',str2);
   m = m + windLen;
   n = n + windLen;
   k = k + 1;
   
end

