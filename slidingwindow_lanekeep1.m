% Test for Lanekeep1

 S = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023','A:A');      
 R = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_Spurhalten1','A:A');
% M: the length of sequence Q Sampling data
% N: the length of sequence C Reference signal
M = length(S);
N = length(R);

windLen = N; % Window length
m = 1;
n = windLen;

nrOfLoop = floor(M/N); % Number of loops

for i = 1:nrOfLoop
    
%    start_id = ['A' num2str(m) ];
%    end_id = ['A' num2str(n) ];
   str=['A',num2str(m),':','A',num2str(n)];
   S = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Ergebnisse-1023.xls','Ergebnisse-1023',str);
   R = xlsread('C:\Users\scuwa\Desktop\MA_Jiawei\Data\Reference_Signale.xlsx','RS_Spurhalten1','A:A');
   w = 1000;
   d  = dtw_lanekeep1(S,R,w);
   m = m + windLen;
   n = n + windLen;
   
end

