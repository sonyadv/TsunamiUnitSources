% 輸入地震參數即可得到comcot.ctl檔
%
% load 'sample.ctl' and get 'comcot.ctl'
%
clc; clear all; close all;
%% read sample
fid = fopen('sample.ctl','r+');

i = 0;
content = {};
while ~feof(fid) % 從頭讀到尾
    tline = fgetl(fid); % 讀取一行
    i = i+1;    
    content{i} = tline;  % 把每一行的内容儲存到"content"這個cell裡
end

%% input data
% 目前是全手動輸入
% 代辦：結合馬國鳳老師的公式
data = {};
data{1} = input('Focal Depth (meter): ','s');
data{2} = input('Length of source area (meter): ','s');
data{3} = input('Width of source area (meter): ','s');
data{4} = input('Dislocation of fault plate (meter): ','s');
data{5} = input('Strike direction (theta): ','s');
data{6} = input('Dip  angle (delta): ','s');
data{7} = input('Slip angle (lambda): ','s');

%% set data
for i = 1:7
    % strrep: Find and replace substrings
    content{i+28} = strrep(content{i+28},'##', data{i});
end

%% write comcot.ctl
out = fopen('comcot.ctl','w');
s = size(content);
for i = 1:s(2)
    fprintf(out,content{i});
    fprintf(out,'\n');
end

fclose(fid);
fclose(out);

disp('The writting of comcot.ctl is done!')

%% run comcot and get ini surface of simluation
% 得到初始值後使用資料庫速算系統做運算(superpose.m)
dos('comcot.exe');
