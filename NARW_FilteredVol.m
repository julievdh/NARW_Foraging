% traveltime and filtered volume

% plot time versus volume
figure(6), clf
set(gcf,'position',[4   289   793   384])
% for all dives 2 h after playback end
for k = d2after';
    dcue = T(k,1):T(k,2); % cues for that dive
   
    c = viridis(size(T,1)); % color dive number
    % dive(k).btm(1) is the first at depth, so descent is until then
    figure(6),
    subplot('position',[0.07 0.1 0.35 0.8]), hold on
    xlabel('Time (seconds)'), ylabel('Depth (m)        Volume Filtered (m^3)')
    if isempty(dive(k).vperblock) == 0
        plot([0 dive(k).btm(1)],[0 0])
        % add stops
        plot([dive(k).stops(1,1)-dcue(1) dive(k).stops(1,2)-dcue(1)],[0 dive(k).vperblock(1)]) % first starts at zero
        for j = 2:size(dive(k).stops,1)
            plot([dive(k).stops(j,1)-dcue(1) dive(k).stops(j,2)-dcue(1)],[sum(dive(k).vperblock(1:j-1)) sum(dive(k).vperblock(1:j))],'.-','markersize',10)
        end
        plot([dive(k).stops(j,2)-dcue(1) dcue(end)-dcue(1)],[sum(dive(k).vperblock(1:j)) sum(dive(k).vperblock(1:j))],'color',c(k,:)) % last ends at zero
    end
    if isempty(dive(k).btm) == 1
        plot([0 T(k,2)-T(k,1)],[0 0])
    end
    plot(-p(round(dcue*fs)),'color',c(k,:))
    
    % plot total volume filtered and dive duration

    if isempty(dive(k).vperblock) == 0
        plot(T(k,2)-T(k,1),sum(dive(k).vperblock(1:j)),'ko','markerfacecolor',c(k,:))
    else if isempty(dive(k).btm) == 1
            plot(T(k,2)-T(k,1),0,'ko','markerfacecolor',c(k,:))
        end
    end
    
    subplot('position',[0.5 0.1 0.2 0.8]), hold on
    if isempty(dive(k).vperblock) == 0
        errorbar(T(k,2)-T(k,1),mean(dive(k).stops(:,2)-dive(k).stops(:,1)),std(dive(k).stops(:,2)-dive(k).stops(:,1)),'ko','markerfacecolor',c(k,:))
    else if isempty(dive(k).btm) == 1
            plot(T(k,2)-T(k,1),0,'ko','markerfacecolor',c(k,:))
        end
    end
    xlabel('Dive Duration (sec)'), ylabel('Duration of Fluking Bouts (sec)')
    
    
    subplot('position',[0.75 0.1 0.2 0.8]), hold on % plot duration vs. number of stops
    plot(ddur(k),size(dive(k).stops,1),'ko','markerfacecolor',c(k,:))
    ylim([0 11])
    xlabel('Dive Duration (sec)'), ylabel('Number of bouts')
    
    if isempty(dive(k).stops) ~= 1
        figure(16), hold on
        line([dive(k).stops(1,1)-dcue(1) dive(k).stops(end,2)-dcue(1)]/length(dcue),[i+0.02*k i+0.02*k],'color',c(k,:))
    dive(k).prop = [dive(k).stops(1,1)-dcue(1) dive(k).stops(end,2)-dcue(1)]/length(dcue); % store this value 
    end
    
    % pause
end

adjustfigurefont

return


%% travel time versus foraging time
figure(3), hold on
clear travel forage
for k = 1:length(dive)
    travel(k,1:2) = dive(k).travel;
    forage(k) = dive(k).forage;
end
plot(travel(:,1),forage,'color',[0.7 0.7 1])
plot(travel(:,2),forage,'color',[0.7 0.7 0.7])
for k = 1:size(T,1),
    if isempty(dive(k).travel) == 0
        plot(dive(k).travel(1),dive(k).forage,'bv')
        plot(dive(k).travel(2),dive(k).forage,'k^')
    end
end
xlabel('Travel time'), ylabel('Foraging time')
figure(4), hold on
plot(sum(travel'),forage,'color',[0.7 0.7 0.7])
for k = 1:size(T,1),
    if isempty(dive(k).travel) == 0
        plot(dive(k).travel(1)+dive(k).travel(2),dive(k).forage,'k^-')
    end
end
xlabel('RT Travel time'), ylabel('Foraging time')

