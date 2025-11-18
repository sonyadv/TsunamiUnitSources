% 計算係數矩陣與線性疊加
% 然後畫圖
%
clear all; close all; fclose all; clc;

%% case setting
event = '2011';

%% loading and init
% set the diameter and initial elevation of the single unit source
% 這邊要跟auto_gs.m的設定一樣
zhigh=10;                 %抬升海嘯源高度（公尺）
startX=140;  endX=145;    %要繪製unit sources的範圍(經度)
startY=34;   endY=40;     %要繪製unit sources的範圍(緯度)
node=6;                   %unit sources的大小

% numerical parameters
cd('org')
% load bathymetry
lx=dlmread('layer01_x.dat');  %先到COMCOT跑要的網格大小及地形範圍
ly=dlmread('layer01_y.dat');  %把得到後的資料變成真實的經緯度範圍
lz=dlmread('layer01.dat');
[lxx,lyy]=meshgrid(lx,ly);
lzz=reshape(lz,length(lx),length(ly)); % 水深
lzz= -lzz';

% load real parameter
%cd('org')
fid=fopen('ini_surface.dat','r');
eta0=fscanf(fid, '%f');
std=reshape(eta0,length(lx),length(ly))';
cd ..

%% coefficient matrix
x1 = find(lx==startX);
xi = 1;
x0 = find(lx==endX);
y0 = find(ly==endY);
count = 1;
memo=zeros(1,3);

while x1<x0
    y1 = find(ly==startY);
    yj = 1;
    while y1<y0
        
        [m,n]=size(lzz);
        
        % 檢查中心點是否有海嘯
        tsun=0;
        coef=0;
        for i = 1:node
            for j = 1:node
                if(i==node/2 && j==node/2)
                    if(std(y1+j-1,x1+i-1)~=0)
                        tsun=1;
                        std(y1+j-1,x1+i-1);
                        coef=std(y1+j-1,x1+i-1)/zhigh;
                        Xmid = lx(x1+i-1);
                        Ymid = ly(y1+i-1);
                    end
                end
            end
        end
        
        if(tsun==1)
            memo(count,1) = round(Xmid,2);
            memo(count,2) = round(Ymid,2);
            memo(count,3) = coef;
            count = count+1;
        end
        y1 = y1 + node;
    end
    x1 = x1 + node;
end

csvwrite([event '_memo.csv'],memo)

disp('The writting of ''memo'' is done!')
