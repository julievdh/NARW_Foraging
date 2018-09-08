% Figure 6 in MS 

figure(19), clf, hold on
h4 = axes('position',[0.06 0.1 0.5 0.65],'Color','w','XColor','k','YColor','k',...
    'YLim',[-140 90],'Xlim',[0 9200],'NextPlot','add',...
    'xtick',[],'ytick',[-20:20:20],...
    'Yaxislocation','right');
h3 = axes('position',[0.06 0.1 0.5 0.65],'Color','none','XColor','k','YColor','k',...
    'YLim',[-150 100],'Xlim',[0 9200],'NextPlot','add');
plot(h4, t*3600,rad2deg(ph),'color','k','Linewidth',1.5)
ylabel(h4,'                    Pitch (deg)')
plot(h3, t*3600,-p,'color',[0.7 0.7 0.7],'linewidth',2)
subplot('position',[0.68 0.1 0.3 0.8]), hold on
plot3(ptrack(:,1),ptrack(:,2),-p,'color',[0.5 0.5 0.5],'linewidth',2)
h1 = axes('position',[0.06 0.75 0.5 0.2],'Color','w','XColor','k','YColor','k',...
    'YLim',[0 120],'Xlim',[0 9200],'NextPlot','add','xtick',[]);
h2 = axes('position',[0.06 0.75 0.5 0.2],'color','none','XColor','k','YColor','k',...
                'YLim',[0 10],'Xlim',[0 9200],...
                'Yaxislocation','right',...
                'Xaxislocation','top','NextPlot','add');

if exist('dive','var') == 1
    for j = 1:size(T,1)
        c = viridis(size(T,1)); % color dive number
        dcue = T(j,1):T(j,2); % seconds in dive
        
        plot(h3, dcue,-p(round(dcue*fs)),'color',c(j,:),'linewidth',3)
        if isempty(dive(j).vperblock) ~= 1
            plot(h3, [dcue(1) dive(j).btm(1)+dcue(1)],[0 0],'linewidth',2)
            % from the surface until first stop = travel time
            dive(j).travel(1) = dive(j).stops(1,1)-dcue(1); % seconds
            dive(j).forage = sum(dive(j).stops(:,2)-dive(j).stops(:,1)); % seconds
            dive(j).travel(2) = dcue(end)-dive(j).stops(end,2);
            % add stops
            plot(h3, [dive(j).stops(1,1) dive(j).stops(1,2)],[0 dive(j).vperblock(1)/10],'.-','linewidth',2) % first starts at zero
            for k = 2:size(dive(j).stops,1)
                plot(h3, [dive(j).stops(k,1) dive(j).stops(k,2)],[sum(dive(j).vperblock(1:k-1))/10 sum(dive(j).vperblock(1:k))/10],'.-','linewidth',2)
            end
            plot(h3, [dive(j).stops(k,2) dcue(end)],[sum(dive(j).vperblock(1:k))/10 sum(dive(j).vperblock(1:k))/10],'linewidth',2) % ends at end of last pause, goes to surface
        end
        if isempty(dive(j).stops) ~= 1
            errorbar(h1,T(j,1),mean(dive(j).stops(:,2)-dive(j).stops(:,1)),std(dive(j).stops(:,2)-dive(j).stops(:,1)),'bo','markerfacecolor','b');
            plot(h1, dive(j).stops(:,2),dive(j).stops(:,2)-dive(j).stops(:,1),'.-','color',[0.7 0.7 1],'linewidth',2) % add stop duration
            plot(h2, dive(j).stops(:,1),rad2deg(dive(j).rms(:)),'.-','color','k','linewidth',2)
        end
        if exist('ptrack','var')
            subplot('position',[0.68 0.1 0.3 0.8]), hold on
            plot3(ptrack(round(dcue*fs),1),ptrack(round(dcue*fs),2),-p(round(dcue*fs)),'color',c(j,:),'linewidth',3)
        end
        
    end
end
title(regexprep(tag,'_',' '))
%xlabel('Time (seconds)')
%ylabel('Depth (m)')


set(gcf,'position',[70 83 1309 560],'paperpositionmode','auto')

set(h3, 'ytick',[-150:50:50 80],'yticklabels',{'150','100','50','0','50','80'})
xlabel(h3, 'Time (seconds)'), ylabel(h3, '                        Depth (m)        Volume filtered (m^3)     ')
subplot('position',[0.68 0.1 0.3 0.8]), hold on
xlabel('Easting (m)'), ylabel('Northing (m)')
axis square 

ylabel(h1,'Bout duration (sec)'), ylabel(h2,'RMS (deg)')

adjustfigurefont('Helvetica',14)


print([tag 'dive_vol_pause.png'],'-dpng','-r300')

