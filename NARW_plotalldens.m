% NARW_plotalldens
clear dive 
% import flow speed for the tag
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])

% calculate dive duration
ddur = T(:,2)-T(:,1);
if exist('dive','var')
for i = 1:length(dive)
    dcue = T(i,1):T(i,2); % cues for that dive
    c = get(gca,'colororder'); % get color order
    c = repmat(c,ceil(size(T,1)/size(c,1)),1);    % repeat color order for number of dives
    
    if isempty(dive(i).stops) == 0
        
        figure(18),
        subplot(2,2,1), hold on
        dive(i).clearingtime = [dive(i).stops(:,2)-dive(i).stops(:,1)]';
        plot(ddur(i),mean(dive(i).clearingtime),'o','color',c(i,:))
        xlabel('Dive Duration (sec)'), ylabel('Inter-Pause Interval (sec)')
        
        subplot(2,2,2), hold on
        if tag == tags{1}
            gape = 1.2;
            speed = 0.5:0.3:2.0; % m/s
            volrate = gape*speed;
            bolus = 0.5; % half a kg
            densities = 0.001:0.001:0.01;
            for j = 1:length(volrate)
                cleartime(j,:) = bolus./densities/volrate(j);
            end
            cv = viridis(size(cleartime,2)); % color by densities
            for j = 1:size(cleartime,2)
                plot(speed, cleartime(:,j),'color',cv(j,:))
            end
            xlabel('Swimming Speed (m/s)'), ylabel('Clearing Time (sec)')
            C = regexp(sprintf('density=%.3f#', densities), '#', 'split');
            % legend(C)
        end
        plot(dive(i).mnspeedperblock,dive(i).stops(:,2)-dive(i).stops(:,1),'o','color',c(i,:))
        
        
        % estimate density 
        for k = 1:length(dive(i).stops)
        dive(i).dens(k) = 0.5/(dive(i).clearingtime(k)*dive(i).vperblock(k));
        end
        subplot(2,2,3), hold on 
        plot(dive(i).stops(:,1),dive(i).dens,'color',c(i,:))
        % plot pitch track
         
        % pause
    end
end
end 