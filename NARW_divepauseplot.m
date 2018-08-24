figure(19), clf, hold on

if exist('dive','var') == 1
    for j = 1:size(T,1)
        c = get(gca,'colororder'); % get color order
        c = repmat(c,ceil(size(T,1)/size(c,1)),1);    % repeat color order for number of dives
        dcue = T(j,1):T(j,2); % seconds in dive
        subplot('position',[0.07 0.1 0.55 0.8]), hold on
        plot(t*3600,-p,'color',[0.7 0.7 0.7])
        plot(dcue,-p(round(dcue*fs)),'color',c(j,:),'linewidth',2)
        if isempty(dive(j).stops) ~= 1
            h = errorbar(T(j,1),mean(dive(j).stops(:,2)-dive(j).stops(:,1)),std(dive(j).stops(:,2)-dive(j).stops(:,1)),'bo','markerfacecolor','b');
            %h.CapSize = 12;
            plot(dive(j).stops(:,1),dive(j).stops(:,2)-dive(j).stops(:,1),'.-','color',[0.7 0.7 1])
            plot(dive(j).stops(:,1),dive(j).rms(:)*500,'.-','color','k')

        end
        if isempty(dive(j).vperblock) ~= 1
            % plot volume
            h = errorbar(T(j,1),mean(dive(j).vperblock),std(dive(j).vperblock),'ro','markerfacecolor','r');
            plot(dive(j).stops(:,1),dive(j).vperblock,'.-','color',[1 0.7 0.7])
%            h = errorbar(T(j,1),mean(dive(j).dens)*1000,std(dive(j).dens*1000),'go','markerfacecolor','g'); % in g/m^3
%            plot(dive(j).stops(:,1),dive(j).dens*1000,'.-','color',[0.7 1 0.7]) % in g/m^3
            %plot([T(i,1) T(i,2)],[mean(stops(:,2)-stops(:,1)) mean(stops(:,2)-stops(:,1))])
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

print([tag 'dive_vol_pause.png'],'-dpng','-r300')

