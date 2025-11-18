% Generate the square unit source for the initial surface elevation.
%
% Execute comcot code and get 
% 'layer01_x.dat'
% 'layer01_y.dat'
% 'layer01.dat'
% 
% run this code to generate the ini_surface.dat and execute comcot

clc; clear; fclose all; close all;
%%
% set the node and initial elevation of the single unit source
zhigh=10;                 %抬升海嘯源高度（公尺）
startX=140;  endX=150;    %要繪製unit sources的範圍(經度)
startY=34;   endY=42;     %要繪製unit sources的範圍(緯度)
node=12;                   %unit sources的大小
fn=['ini.cct']; % finename for outputing the ini surf.

%% 讀地形檔
cd('surface')
lx=dlmread('layer01_x.dat');  %先到COMCOT跑要的網格大小及地形範圍
ly=dlmread('layer01_y.dat');  %把得到後的資料變成真實的經緯度範圍
lz=dlmread('layer01.dat');
[lxx,lyy]=meshgrid(lx,ly);
lzz=reshape(lz,length(lx),length(ly)); % 水深
lzz= -lzz';   
% 畫地形檔（確認用，也可以不畫）
pcolor(lxx,lyy,lzz); %畫地形
shading flat; axis image;
hold on
contour(lxx,lyy,lzz,[0 0],'k','linewidth',1.3)   %畫海岸線 
box on; grid on; set(gca, 'layer', 'top');
hcb = colorbar; set(get(hcb,'Ylabel'),'String','Elevation (m)');
xlabel('Longitude'); ylabel('Latitude');
cd ..

%% 生成unit sources
x1 = find(lx==startX);
xi = 1;
x0 = find(lx==endX);
y0 = find(ly==endY);

while x1<x0
    y1 = find(ly==startY);
    yj = 1;
    while y1<y0
       
        % 初始化波場
        aa = zeros(size(lzz)); 

        % 抬升指定範圍內的海嘯源
        for i = 1:node
            for j = 1:node
                aa(y1+j-1,x1+i-1) = zhigh;
                if(i==node/2 && j==node/2)
                    Xmid = lx(x1+i-1);
                    Ymid = ly(y1+i-1);
                end
            end
        end
        
%%
%         繪製產生海嘯源後的波高圖，如果需要大量產生unit sourse可關掉（避免耗時）
%         主要是用來確認unit sourse的生成結果沒有問題
%         figure(2); clf;
%         aa1=aa;
%         aa1(aa1<0.001)=nan;
%         pcolor(lxx,lyy,lzz); %畫地形
%         hold on;
%         pcolor(lxx,lyy,aa1); % initial surface elevation
%         shading flat; axis image;
%         hold on
%         contour(lxx,lyy,lzz,[0 0],'k','linewidth',1.3)   %畫海岸線  
%         box on; grid on; set(gca, 'layer', 'top');
%         hcb = colorbar; set(get(hcb,'Ylabel'),'String','Elevation (m)');
%         xlabel('Longitude'); ylabel('Latitude');
%         print(['r600.' fn '(' sprintf('%3.2f',Xmid) ',' sprintf('%3.2f',Ymid) ')' '.png'],'-dpng','-r600');
%         print(['r72.' fn '(' sprintf('%3.2f',Xmid) ',' sprintf('%3.2f',Ymid) ')' '.png'],'-dpng','-r72');
%         pause(0.1);

        %%
        % Write the initial free-surface elevation
        disp('Writting the ''ini_surface_unit_source.dat''...')
        fliename=['ini.cct' ];
        fid=fopen(fliename,'w'); 
        for jj =1:size(aa,1) 
            line1 = aa(jj,:); % divide into two parts 
            for ii =1:floor(length(line1 )/15) 
                wt1(ii,:)=line1 (1+15*(ii-1):15*ii); 
            end
            wt2=line1 (1+15*(floor(length(line1)/15)):end); % output the data
            for ii = 1:size(wt1,1) 
                fprintf(fid,' %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f\n',wt1(ii,:));
            end
            % if there is no remain when data's quantity devided by 15
            if rem(length(line1 ),15)~=0 
                fprintf(fid,' %7.3f',wt2); 
                fprintf(fid,'\n'); 
            end
            clear wt1 wt2 line1 
        end
        fclose(fid)   
        
        % 將畫好的unit source直接丟到COMCOT跑
        % 生成初始波高的同時也可以生成海嘯傳遞，不須再手動執行COMCOT
        % ！！comcot.ctl要先設定好！！
        dos('comcot.exe');
        
        % 整理生成好的unit sources
        filen = [sprintf('%3.2f',Xmid) ' ' sprintf('%3.2f',Ymid)];
        if ~exist(filen,'dir')==0
            mkdir(filen);
        end
        
        movefile('ini.*', filen, 'f');
        movefile('*.dat',filen,'f');
        %movefile('*.png',filen,'f');
        
        y1 = y1 + node;
    end
    
    x1 = x1 + node;
end


disp('Database is done!')
