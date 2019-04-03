% traveltime and filtered volume
% NARW_plotAlldives

%%
ID = 8;
tag = tags{ID};
loadprh(tag)
t = (1:length(p))/fs/3600; % compute time vector

% how many dives > 50 m
T = finddives(p,fs,50,1);
ddur = T(:,2)-T(:,1); % calculate duration of all dives

% import flow speed for the tag
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])

%% plot time versus volume
figure(6), clf
% set(gcf,'position',[4   289   930   384],'paperpositionmode','auto')
% plot these first in background
% subplot('position',[0.5 0.1 0.2 0.8]), hold on
hold on 
plot(alldur,mnboutdur,'o','color',[0.7 0.7 0.7])

% subplot('position',[0.75 0.1 0.2 0.8]), hold on % plot duration vs. number of stops
% plot(allddur,allnstops,'o','color',[0.7 0.7 0.7])

% for a dive
for k = tags{ID,9}';
    dcue = T(k,1):T(k,2); % cues for that dive
    
    c = viridis(size(T,1)); % color dive number
    % dive(k).btm(1) is the first at depth, so descent is until then
    figure(5),
    % subplot('position',[0.07 0.1 0.35 0.8]), 
    hold on
    xlabel('Time (seconds)'), ylabel('Depth (m)        Volume Filtered (m^3)')
    if isempty(dive(k).vperblock) == 0
        plot([0 dive(k).btm(1)],[0 0],'color',[0.5 0.5 0.5])
        % add stops
        plot([dive(k).stops(1,1)-dcue(1) dive(k).stops(1,2)-dcue(1)],[0 dive(k).vperblock(1)],'linewidth',1.5,'color',[0.5 0.5 0.5]) % first starts at zero
        for j = 2:size(dive(k).stops,1)
            h = plot([dive(k).stops(j,1)-dcue(1) dive(k).stops(j,2)-dcue(1)],[sum(dive(k).vperblock(1:j-1)) sum(dive(k).vperblock(1:j))],'.-','markersize',10,'linewidth',1,'color',[0.5 0.5 0.5]);
           % h.facealpha = 0.5; 
        end
        plot([dive(k).stops(j,2)-dcue(1) dcue(end)-dcue(1)],[sum(dive(k).vperblock(1:j)) sum(dive(k).vperblock(1:j))],'color',c(k,:),'linewidth',1.5,'color',[0.5 0.5 0.5]) % last ends at zero
    end
    if isempty(dive(k).btm) == 1
        plot([0 T(k,2)-T(k,1)],[0 0],'linewidth',1.5)
    end
    plot(-p(round(dcue*fs)),'color',c(k,:),'linewidth',1.5)
    
    % plot total volume filtered and dive duration
    
    if isempty(dive(k).vperblock) == 0
        plot(T(k,2)-T(k,1),sum(dive(k).vperblock(1:j)),'ko','markerfacecolor',c(k,:))
    else if isempty(dive(k).btm) == 1
            plot(T(k,2)-T(k,1),0,'ko','markerfacecolor',c(k,:))
        end
    end
    
    figure(6), hold on
    if isempty(dive(k).vperblock) == 0
        errorbar(T(k,2)-T(k,1),mean(dive(k).stops(:,2)-dive(k).stops(:,1)),std(dive(k).stops(:,2)-dive(k).stops(:,1))/2,'ko','markerfacecolor',c(k,:),'linewidth',1.5)
    else if isempty(dive(k).btm) == 1
            plot(T(k,2)-T(k,1),0,'ko','markerfacecolor',c(k,:))
        end
    end
    xlabel('Dive Duration (sec)'), ylabel('Duration of Fluking Bouts (sec)')
    
    
%     subplot('position',[0.75 0.1 0.2 0.8]), hold on % plot duration vs. number of stops
%     plot(ddur(k),size(dive(k).stops,1),'ko','markerfacecolor',c(k,:))
%     ylim([0 max(max(allnstops))+1])
%     xlabel('Dive Duration (sec)'), ylabel('Number of bouts')
%     
    
    % pause
end

figure(5), adjustfigurefont('helvetica',16)
axletter(gca,'A'), box on
print('FilteredVolExample_Fig_A','-dpng','-r300')

figure(6), adjustfigurefont('helvetica',16)
ylim([20 160]), axletter(gca,'B'), box on
print('FilteredVolExample_Fig_B','-dpng','-r300')

% print('FilteredVolExample_Fig','-dpng','-r300')