clear all; close all; fclose all; clc;

%% parameter setting
event = '2011';
grid = 2;

dt=4.0; output_dt=600; simulation_time=18000;
interval=output_dt/dt; total = simulation_time/dt;

%% load bath
cd('surface')
sup_x=dlmread(['layer' sprintf('%02d',grid) '_x.dat']);  %先到COMCOT跑要的網格大小及地形範圍
sup_y=dlmread(['layer' sprintf('%02d',grid) '_y.dat']);  %把得到後的資料變成真實的經緯度範圍
sup_z=dlmread(['layer' sprintf('%02d',grid) '.dat']);
[lon,lat]=meshgrid(sup_x,sup_y);
sup_bath=reshape(sup_z,length(sup_x),length(sup_y)); % 水深
sup_bath= -sup_bath';
cd ..

%% load csv and plot
ii_count=0;
for ii=0:interval:total
    ii_count=ii_count+1;
    
    %cd('output01')
    fn = ['sup' sprintf('%02d',grid) '_' sprintf('%06d',ii) '.csv']
    eta0 = csvread(fn);
    %cd ..

    eta_sup=reshape(eta0,length(sup_x),length(sup_y))';
    fn_sup_individual =  ['sup' sprintf('%02d',grid) '_' sprintf('%06d',ii)]

    plotting(dt,sup_x,sup_y,sup_bath,eta_sup,fn_sup_individual,60*10*ii/150) 
    creating_gif(fn_sup_individual,fn_sup,ii_count)

    clf; fclose all;
end

%% plot z max
eta_max=reshape(eta_max,length(lxx),length(ly))';
fn_zmax='zmax_';
pcolor(lon,lat,sup_bath); shading flat; axis image;
caxis([0 1])
box on; grid on; set(gca, 'layer', 'top');
hold on;
contour(lon,lat,sup_bath, [0 0], 'k'); % plot coastline
hcb = colorbar; set(get(hcb,'Ylabel'),'String','Free-surface Elevation (m)')
colormap(parula);
xlabel('Longitude'); ylabel('Latitude');
title(['Z max']);
% output png files
print(['r600.' fn_zmax '.png'],'-dpng','-r600');
print(['r72.' fn_zmax '.png'],'-dpng','-r72');

%% plot arrival time
eta_at=reshape(eta_at,length(lx),length(ly))';
fn_at='arrival_time';
contourf(lxx,lyy,eta_at); shading flat; axis image;
caxis([0 10])
box on; grid on; set(gca, 'layer', 'top');
hold on;
contour(lxx,lyy,lzz, [0 0], 'k'); % plot coastline
colormap(parula);
xlabel('Longitude'); ylabel('Latitude');
title(['arrival time']);
% output png files
print(['r600.' fn_at '.png'],'-dpng','-r600'); 
print(['r72.' fn_at '.png'],'-dpng','-r72');
