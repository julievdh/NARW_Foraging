% NARW_plotalldens

% calculate dive duration
figure(18), clf
ddur = T(:,2)-T(:,1);
[v,ph,~,~] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]); % calculate pitch deviation

if exist('dive','var')
    for j = 1:length(dive)
        dcue = T(j,1):T(j,2); % cues for that dive
        c = get(gca,'colororder'); % get color order
        c = repmat(c,ceil(size(T,1)/size(c,1)),1);    % repeat color order for number of dives
        
        if isempty(dive(j).stops) == 0
            
            
            subplot(2,2,1), hold on
            dive(j).clearingtime = [dive(j).stops(:,2)-dive(j).stops(:,1)]';
            plot(ddur(j),mean(dive(j).clearingtime),'o','color',c(j,:))
            xlabel('Dive Duration (sec)'), ylabel('Inter-Pause Interval (sec)')
            
            % calculate RMS amplitude of pitch deviation per block
            subplot(2,2,2), hold on
            for k = 1:size(dive(j).stops,1)
                plot(ph(dive(j).stops(k,1)*fs:dive(j).stops(k,2)*fs))
                dive(j).rms(k) = rms(ph(dive(j).stops(k,1)*fs:dive(j).stops(k,2)*fs));
                xlabel('Time (samples)'), ylabel('Pitch Deviation (radians)')
            end
            
            
            %             if tag == tags{1}
            %                 gape = getgape(tags{1,6});
            %                 speed = 0.5:0.3:2.0; % m/s
            %                 volrate = gape*speed;
            %                 bolus = 0.5; % half a kg
            %                 densities = 0.001:0.001:0.01;
            %                 for v = 1:length(volrate)
            %                     cleartime(v,:) = bolus./densities/volrate(v);
            %                 end
            %                 cv = viridis(size(cleartime,2)); % color by densities
            %                 for v = 1:size(cleartime,2)
            %                     plot(speed, cleartime(:,v),'color',cv(v,:))
            %                 end
            %                 xlabel('Swimming Speed (m/s)'), ylabel('Clearing Time (sec)')
            %                 C = regexp(sprintf('density=%.3f#', densities), '#', 'split');
            %                 % legend(C)
            %             end
            %             if isempty(dive(j).mnspeedperblock) ~= 1
            %                 plot(dive(j).mnspeedperblock,dive(j).stops(:,2)-dive(j).stops(:,1),'o','color',c(j,:))
            %             end
            
            % estimate density
            if isempty(dive(j).vperblock) ~= 1
                %                 for k = 1:size(dive(j).stops,1)
                %
                %                     dive(j).dens(k) = 0.5./dive(j).vperblock(k); % vperblock is volume in m^3
                %                     subplot(2,2,4), hold on
                %                     plot(ddur(j),dive(j).dens(k),'o')
                %                     xlabel('Dive Duration (sec)'), ylabel('Estimated Prey Density')
                %
                %                 end
                subplot(2,2,3), hold on
                %plot(dive(j).stops(:,1),dive(j).dens,'color',c(j,:))
                plot(dive(j).mnspeedperblock,dive(j).rms,'o-','color',c(j,:))
                subplot(2,2,4), hold on
                errorbar(mean(dive(j).mnspeedperblock),mean(dive(j).rms),std(dive(j).rms),'o','color',c(j,:))
            end
            xlabel('Swimming speed (m/s)'), ylabel('Fluke stroke RMS (radians)')
            
            % pause
        end
    end
end
