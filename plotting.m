% plot free-surface elevation
function plotting(dt,lxx,lyy,lzz,eta,fn1,time)
    % creat blue and red colormap
    bb=1-[1 1 0].*gray; rr=1-[0 1 1].*gray; rb=[flipud(bb); rr];
    
    pcolor(lxx,lyy,eta); shading flat; axis image;
    caxis([-1 1])
    box on; grid on; set(gca, 'layer', 'top');
    hold on;
    contour(lxx,lyy,lzz, [0 0], 'k'); % plot coastline
    hcb = colorbar; set(get(hcb,'Ylabel'),'String','Free-surface Elevation (m)')
    colormap(rb);
    xlabel('Longitude'); ylabel('Latitude');
    % seconds to hms
    tt_date=time/24/60/60; hms_str=datestr(tt_date, 'HH:MM:SS.FFF'); %秒轉時分秒
    title(hms_str);
    % output png files
    print([fn1 '.png'],'-dpng','-r600');
    %print(['r72.' fn1 '.png'],'-dpng','-r72');