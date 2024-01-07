%nc_dump('.nc');
clc; clear; fclose all; close all;

%% initial setting
mostname = '.most';
ncname = '.nc';
name = 'Grid';

%% read and plot bathmetry files
mostFn = dlmread(mostname);

% pre-process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% most format：                                                           %
%                                                                         %
% 1      nodes(y) nodes(x)                                                %
% 2      lon                                                              %
% y+2    lat                                                              %
% x+y+2 ... y                                                             %
% :                                                                       %
% :      bathymetry                                                       %
% :                                                                       %
% x+y+1+x                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y = mostFn(1,1);
x = mostFn(1,2);
lon = mostFn(2:y+1,1);
lat = mostFn(y+2:x+y+1,1);
bath = mostFn(x+y+2:x+y+1+x,1:y);
bath = bath.*-1;
[Lon,Lat] = meshgrid(lon,lat);

% plot
figure(1)
p = pcolor(Lon,Lat,bath);                                              % 畫地形圖
set(p, 'EdgeColor', 'none');                                           % pcolor不要網格
shading flat; axis image;                                                 % 顏色設定
hold on
contour(Lon,Lat,bath,[0 0],'k');                                          % 畫海岸線
box on; grid on; set(gca, 'layer', 'top');                                % 經緯度格線、放到最上面
hcb = colorbar; set(get(hcb,'Ylabel'),'String','Elevation (m)');          % colorbar顯示、標題設定
xlabel('Longitude'); ylabel('Latitude');                                  % 坐標軸標題
title([name ' topographic map'])                                          % 圖標題
print([name '_topographicMap.png'],'-dpng','-r600');                      % 印出dpi600的png

csvwrite(['commitLON.csv'],lon)
csvwrite(['commitLAT.csv'],lat)

%% read runup
ts=nc_varget(ncname,'TIME');
ha=nc_varget(ncname,'HA');

% pre-process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% runup.nc format:                                                        %
%                                                                         %
% dimensions:                                                             %
%   LON = x ;                                                             %
%   LAT = y ;                                                             %
%   TIME(sec) = UNLIMITED ;                                               %
%                                                                         %
% variables:                                                              %
%     single VA(TIME,LAT,LON), shape = [t x y]                            %
%         VA:units = "CENTIMETERS/SECOND" ;                               %
%         VA:long_name = "Velocity Component along Latitude" ;            %
%     single UA(TIME,LAT,LON), shape = [t x y]                            %
%         UA:units = "CENTIMETERS/SECOND" ;                               %
%         UA:long_name = "Velocity Component along Longitude" ;           %
%     single HA(TIME,LAT,LON), shape = [t x y]                            %
%         HA:long_name = "Wave Amplitude" ;                               %
%         HA:units = "CENTIMETERS" ;                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x y] = size(Lon);
wave = ha(1,:,:);
wave = reshape(wave,x,y);

% plot
figure(2)
p = pcolor(Lon,Lat,wave);                                                 % 畫地形圖
set(p, 'EdgeColor', 'none');                                              % pcolor不要網格
caxis([-1000 1000])                                                       % 範圍設定
cmap = cbrewer2('RdBu');                                                  % 色階設定
colormap(flip(cmap));                                                     % 
shading flat; axis image;                                                 % 顏色設定
hold on
contour(Lon,Lat,bath,[0 0],'k');                                          % 畫海岸線
box on; grid on; set(gca, 'layer', 'top');                                % 經緯度格線、放到最上面
hcb = colorbar; set(get(hcb,'Ylabel'),'String','wave height (m)');        % colorbar顯示、標題設定
xlabel('Longitude'); ylabel('Latitude');                                  % 坐標軸標題
title([name ' initial surface'])                                          % 圖標題
print([name '_initialSurface.png'],'-dpng','-r600');                      % 印出dpi600的png

csvwrite(['comcot00.csv'],wave)

%% Wave height 
gauge_x = 152.123;
gauge_y = 30.528;

% find index
diff = abs(lon - gauge_x);
[min_x, gauge_col]= min(diff(:));
clear diff;
diff = abs(lat - gauge_y);
[min_y, gauge_row] = min(diff(:));

% record wave height
i = 1;
wave_h = [];
while ts(i)<7800
    
    [x y] = size(Lon);
    wave = ha(i,:,:);
    wave = reshape(wave,x,y);

    wave_h(i) = wave(gauge_row,gauge_col);

    clear wave;
    i = i+1;
end

wave_h = wave_h./100;
time = ts(1:i-1);

% plot
fn_fig = ['ComMIT Wave Height at (' ...
    sprintf('%3.2f',gauge_x) ',' sprintf('%2.2f',gauge_y) ')']
figureSize = [100, 100, 1200, 400];
set(gcf, 'Position', figureSize);

plot(time,wave_h)
ylabel('Wave Height (m)','FontSize',14)
ylim([-2 2])

time_str = datestr(seconds(time(1:20:end)), 'hh:MM:ss');
time_tik = time(1:20:end);
xticks(time_tik)
xlim([time(1) time(end)])
xticklabels(time_str)
xlabel('Time (hh:mm:ss)','FontSize',14)

box on; grid on;
title(fn_fig,'FontSize',16)

% save
fn_save = ['ComMIT(' sprintf('%3.2f',gauge_x) ',' sprintf('%2.2f',gauge_y) ').png']
print([fn_save],'-dpng');

