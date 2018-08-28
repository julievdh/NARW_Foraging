figure(19), clf, hold on

if exist('dive','var') == 1
    for j = 1:size(T,1)
        c = viridis(size(T,1)); % color dive number
        dcue = T(j,1):T(j,2); % seconds in dive
        subplot('position',[0.07 0.1 0.55 0.8]), hold on
        plot(t*3600,-p,'color',[0.7 0.7 0.7])
        plot(dcue,-p(round(dcue*fs)),'color',c(j,:),'linewidth',2)
        if isempty(dive(j).stops) ~= 1
            h = errorbar(T(j,1),100+mean(dive(j).stops(:,2)-dive(j).stops(:,1)),std(dive(j).stops(:,2)-dive(j).stops(:,1)),'bo','markerfacecolor','b');
            plot(dive(j).stops(:,2),100+dive(j).stops(:,2)-dive(j).stops(:,1),'.-','color',[0.7 0.7 1]) % add stop duration
            plot(dive(j).stops(:,1),100+dive(j).rms(:)*500,'.-','color','k')
        end
        if isempty(dive(j).vperblock) ~= 1
            plot([dcue(1) dive(j).btm(1)+dcue(1)],[0 0])
            % from the surface until first stop = travel time
            dive(j).travel(1) = dive(j).stops(1,1)-dcue(1); % seconds
            dive(j).forage = sum(dive(j).stops(:,2)-dive(j).stops(:,1)); % seconds
            dive(j).travel(2) = dcue(end)-dive(j).stops(end,2);
            % add stops
            plot([dive(j).stops(1,1) dive(j).stops(1,2)],[0 dive(j).vperblock(1)/10],'.-') % first starts at zero
            for k = 2:size(dive(j).stops,1)
                plot([dive(j).stops(k,1) dive(j).stops(k,2)],[sum(dive(j).vperblock(1:k-1))/10 sum(dive(j).vperblock(1:k))/10],'.-')
            end
            plot([dive(j).stops(k,2) dcue(end)],[sum(dive(j).vperblock(1:k))/10 sum(dive(j).vperblock(1:k))/10]) % ends at end of last pause, goes to surface
        end
        if exist('ptrack','var')
            subplot('position',[0.65 0.1 0.3 0.8]), hold on
            plot3(ptrack(:,1),ptrack(:,2),-p,'color',[0.5 0.5 0.5])
            plot3(ptrack(round(dcue*fs),1),ptrack(round(dcue*fs),2),-p(round(dcue*fs)),'color',c(j,:),'linewidth',2)
            
        end
        
    end
end
title(regexprep(tag,'_',' '))
%xlabel('Time (seconds)')
%ylabel('Depth (m)')
adjustfigurefont

set(gcf,'position',[1513 -14 1309 560],'paperpositionmode','auto')

subplot('position',[0.07 0.1 0.55 0.8]), hold on
set(gca,'ytick',[-150:50:200],'yticklabels',{'150','100','50','0','500','1000','50','100'})
xlabel('Time (seconds)'), ylabel('                                       Depth (m)        Volume Filtered (m^3)         Bout Duration (sec)')
subplot('position',[0.65 0.1 0.3 0.8]), hold on
xlabel('Easting (m)'), ylabel('Northing (m)')

print([tag 'dive_vol_pause.png'],'-dpng','-r300')

