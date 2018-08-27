% traveltime and filtered volume

% plot time versus volume
figure(6), clf
% for a dive
for k = 1:size(T,1);
    dcue = T(k,1):T(k,2); % cues for that dive
    
    c = viridis(size(T,1)); % color dive number
    % dive(k).btm(1) is the first at depth, so descent is until then
    figure(6),
    subplot('position',[0.07 0.1 0.55 0.8]), hold on
    xlabel('Time (seconds)'), ylabel('Depth (m)        Volume Filtered (m^3)')
    if isempty(dive(k).vperblock) == 0
        plot([0 dive(k).btm(1)],[0 0])
        % add stops
        plot([dive(k).stops(1,1)-dcue(1) dive(k).stops(1,2)-dcue(1)],[0 dive(k).vperblock(1)]) % first starts at zero
        for j = 2:size(dive(k).stops,1)
            plot([dive(k).stops(j,1)-dcue(1) dive(k).stops(j,2)-dcue(1)],[sum(dive(k).vperblock(1:j-1)) sum(dive(k).vperblock(1:j))])
        end
        plot([dive(k).stops(j,2)-dcue(1) dcue(end)-dcue(1)],[sum(dive(k).vperblock(1:j)) sum(dive(k).vperblock(1:j))],'color',c(k,:)) % last ends at zero
    end
    if isempty(dive(k).btm) == 1
        plot([0 T(k,2)-T(k,1)],[0 0])
    end
    plot(-p(round(dcue*fs)),'color',c(k,:))
    
    % plot total volume filtered and dive duration
    subplot('position',[0.65 0.1 0.3 0.8]), hold on
    xlabel('Dive Duration     (seconds)'), ylabel('Volume Filtered (m^3)')
    
    if isempty(dive(k).vperblock) == 0
        plot(T(k,2)-T(k,1),sum(dive(k).vperblock(1:j)),'o','color',c(k,:))
    else if isempty(dive(k).btm) == 1
            plot(T(k,2)-T(k,1),0,'o','color',c(k,:))
        end
    end
    
    if isempty(dive(k).stops) ~= 1
        figure(16), hold on
        line([dive(k).stops(1,1)-dcue(1) dive(k).stops(end,2)-dcue(1)]/length(dcue),[i+0.02*k i+0.02*k],'color',c(k,:))
    end
    
    
    % pause
end



%% also plot all through time
figure(7), clf, hold on
for k = 1:size(T,1);
    dcue = T(k,1):T(k,2); % cues for that dive
    
    if isempty(dive(k).vperblock) == 0
        plot([dcue(1) dive(k).btm(1)+dcue(1)],[0 0])
        % from the surface until first stop = travel time
        dive(k).travel(1) = dive(k).stops(1,1)-dcue(1); % seconds
        dive(k).forage = sum(dive(k).stops(:,2)-dive(k).stops(:,1)); % seconds
        dive(k).travel(2) = dcue(end)-dive(k).stops(end,2);
        % add stops
        plot([dive(k).stops(1,1) dive(k).stops(1,2)],[0 dive(k).vperblock(1)],'.-') % first starts at zero
        for j = 2:size(dive(k).stops,1)
            plot([dive(k).stops(j,1) dive(k).stops(j,2)],[sum(dive(k).vperblock(1:j-1)) sum(dive(k).vperblock(1:j))],'.-')
        end
        plot(dive(k).stops(:,2),dive(k).stops(:,2)-dive(k).stops(:,1),'.-','color',[0.7 0.7 1]) % add stop duration
        plot([dive(k).stops(j,2) dcue(end)],[sum(dive(k).vperblock(1:j)) sum(dive(k).vperblock(1:j))]) % ends at end of last pause, goes to surface
    end
    if isempty(dive(k).btm) == 1
        plot([dcue(1) dcue(end)],[0 0])
    end
    plot(dcue,-p(round(dcue*fs)),'color',c(k,:))
end

xlabel('Time (seconds)'), ylabel('Depth (m)        Volume Filtered (m^3)')

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

