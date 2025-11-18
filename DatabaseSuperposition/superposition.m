clear all; close all; fclose all; clc;

%% parameter setting
event = '2011';
grid = 3;

dt=4.0; output_dt=600; simulation_time=18000;
interval=output_dt/dt; total = simulation_time/dt;

%% load and init
memo = csvread([event '_memo.csv']);
[count c] = size(memo);

cd('surface')
sup_x=dlmread(['layer' sprintf('%02d',grid) '_x.dat']);  %先到COMCOT跑要的網格大小及地形範圍
sup_y=dlmread(['layer' sprintf('%02d',grid) '_y.dat']);  %把得到後的資料變成真實的經緯度範圍
sup_z=dlmread(['layer' sprintf('%02d',grid) '.dat']);
[lon,lat]=meshgrid(sup_x,sup_y);
sup_bath=reshape(sup_z,length(sup_x),length(sup_y)); % 水深
sup_bath= -sup_bath';
cd ..

%% initial martix setting
eta_max = zeros(size(sup_bath));
eta_min = zeros(size(sup_bath));
eta_at = zeros(size(sup_bath));
eta_at = eta_at-1;

%% linear superposition
for ii=0:interval:total
    
    cd('database')
    fn_head=['z_' sprintf('%02d',grid) '_'];
    eta0 = 0;
    
    for i=1:count
        fn0=[fn_head sprintf('%06d',ii) '.dat'];
        file=[sprintf('%3.2f',memo(i,1)) ' ' sprintf('%2.2f',memo(i,2))];
        cd(file)
        fid=fopen(fn0,'r');
        etaa = fscanf(fid, '%f');
        eta0 = eta0+etaa*memo(i,3);
        cd ..
    end
    cd ..
    
    % find max
    for x = 1:size(eta0,1)
        if eta0(x)>eta_max(x)
            eta_max(x) = eta0(x);
        end
    end
    
    % memo arrival time
    for x = 1:size(eta0,1)
        if eta_at(x) == -1 && eta0(x) ~= 0
                eta_at(x) = ii/40;
        end
    end
    
    % superposition
    eta_sup=reshape(eta0,length(sup_x),length(sup_y))';
    fn_sup=['sup_z_' sprintf('%02d',grid)];
    fn_sup_individual=[fn_sup '.' sprintf('%06d',ii) '.dat']; 

    output_fn = ['sup' sprintf('%02d',grid) '_' sprintf('%06d',ii) '.csv']
    csvwrite(output_fn,eta0)

    clf; fclose all;
end
fclose all

out_max=reshape(eta_max,length(sup_x),length(sup_y))';
csvwrite([event '_' sprintf('%02d',grid) '_Zmax.csv'],out_max)

out_at=reshape(eta_at,length(sup_x),length(sup_y))';
csvwrite([event '_' sprintf('%02d',grid) '_arrivalTime.csv'],out_at)
