% NARW_plotalldens
clear dive 
% import flow speed for the tag
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])

% calculate dive duration
ddur = T(:,2)-T(:,1);
if exist('dive','var')
for j = 1:length(dive)
    dcue = T(j,1):T(j,2); % cues for that dive
    c = get(gca,'colororder'); % get color order
    c = repmat(c,ceil(size(T,1)/size(c,1)),1);    % repeat color order for number of dives
    
    if isempty(dive(j).stops) == 0
        
        figure(18),
        subplot(2,2,1), hold on
        dive(j).clearingtime = [dive(j).stops(:,2)-dive(j).stops(:,1)]';
        plot(ddur(j),mean(dive(j).clearingtime),'o','color',c(j,:))
        xlabel('Dive Duration (sec)'), ylabel('Inter-Pause Interval (sec)')
        
        subplot(2,2,2), hold on
        if tag == tags{1}
            gape = 1.2;
            speed = 0.5:0.3:2.0; % m/s
            volrate = gape*speed;
            bolus = 0.5; % half a kg
            densities = 0.001:0.001:0.01;
            for v = 1:length(volrate)
                cleartime(v,:) = bolus./densities/volrate(v);
            end
            cv = viridis(size(cleartime,2)); % color by densities
            for v = 1:size(cleartime,2)
                plot(speed, cleartime(:,v),'color',cv(v,:))
            end
            xlabel('Swimming Speed (m/s)'), ylabel('Clearing Time (sec)')
            C = regexp(sprintf('density=%.3f#', densities), '#', 'split');
            % legend(C)
        end
        plot(dive(j).mnspeedperblock,dive(j).stops(:,2)-dive(j).stops(:,1),'o','color',c(j,:))
        
        
        % estimate density 
        for k = 1:size(dive(j).stops,1)
        dive(j).dens(k) = 0.5/(dive(j).clearingtime(k)*dive(j).vperblock(k));
        end
        subplot(2,2,3), hold on 
        plot(dive(j).stops(:,1),dive(j).dens,'color',c(j,:))
        % plot pitch track
         
        % pause
    end
end
end 