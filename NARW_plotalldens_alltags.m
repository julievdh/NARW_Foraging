% NARW_plotalldens
load('NARW_foraging_tags')

figure(18), clf
for i = [1:4 6:length(tags)]
    tag = tags{i};
    loadprh(tag)
    T = finddives(p,fs,50,1);
    % calculate dive duration
    ddur = T(:,2)-T(:,1);
    [v,ph,~,~] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]); % calculate pitch deviation
    clear F dive;  FD = []; TTNFD = []; % reset some variables
    
    load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
    
    if exist('dive','var')
        for j = 1:length(dive)
            dcue = T(j,1):T(j,2); % cues for that dive
            c = viridis(size(T,1)); % color dive number
            
            if isempty(dive(j).stops) == 0
                
                figure(18), subplot(3,4,i), hold on
                dive(j).clearingtime = dive(j).stops(:,2)-dive(j).stops(:,1); 
                % calculate RMS amplitude of pitch deviation per block
                % subplot(2,2,2), hold on
                for k = 1:size(dive(j).stops,1)
                    %    plot(ph(dive(j).stops(k,1)*fs:dive(j).stops(k,2)*fs))
                    dive(j).rms(k) = rms(ph(dive(j).stops(k,1)*fs:dive(j).stops(k,2)*fs));
                    %   xlabel('Time (samples)'), ylabel('Pitch Deviation (radians)')
                end
                
                % plot mean speed versus RMS
                if isempty(dive(j).vperblock) ~= 1
                    
                    %plot(dive(j).mnspeedperblock,dive(j).rms,'o-','color',c(j,:))
                    errorbar(mean(dive(j).mnspeedperblock),mean(dive(j).rms),std(dive(j).rms),'o','color',c(j,:))
                end
                xlabel('Swimming speed (m/s)'), ylabel('Fluke RMS amplitude (rad)')
                
            end
            % calculate time to next foraging dive
            F(j) = ~isempty(dive(j).btm); % 1 = next is foraging dive, 0 = next is not foraging dive
        end
        % foraging dives
        FD = T(F,1); % these are start cues of all foraging dives
        for j = 1:length(dive)-1
            % find nearest foraging dive
            fdnum = nearest(FD,T(j,2),[],1);
            % calculate time until next foraging dive
            if isnan(fdnum) == 0
                TTNFD(:,j) = FD(fdnum)-T(j,2); % time until next foraging dive
            else TTNFD(:,j) = NaN;
            end
            figure(29), hold on
            plot(TTNFD(j),mean(dive(j).rms)/mean(dive(j).mnspeedperblock),'o','color',c(j,:))
            
            % figure(30), subplot(3,4,i), hold on
            % scatter(mean(dive(j).mnspeedperblock),mean(dive(j).rms),[],TTNFD(j),'filled')
            % caxis([100 2000]);
        end
        
        figure(30),
        subplot(3,4,i), hold on
        for j = 1:length(dive)
            errorbar(mean(dive(j).rms),mean(dive(j).clearingtime),std(dive(j).clearingtime),'o','color',c(j,:))
            for k = 1:size(dive(j).stops,1)
                plot(dive(j).rms(k),dive(j).clearingtime(k),'o','color',c(j,:))
            end
        end
        xlabel('Fluke RMS amplitude (rad)'), ylabel('Bout duration (sec)')
    end
end
figure(18), adjustfigurefont 
set(gcf,'position',[ 514    45   880   628],'paperpositionmode','auto')
print('RMSspeed_all','-dsvg','-r300')
figure(30), adjustfigurefont
set(gcf,'position',[ 524    45   880   628],'paperpositionmode','auto')
print('RMSduration_all','-dsvg','-r300')


