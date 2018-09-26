% list of deployments
clear, close all, warning off
% tags is deployment name, time of tag on, cue of tag off
load('NARW_foraging_tags')
% 7 is playback start/end time; 000000 = no playbacks
% 8 is analysis start time (2h after end last playback)
%%
allddur = nan(10,40); allnstops = nan(10,40);
mnboutdur = nan(10,40);
tagc = viridis(10); % color for tags
%%
for i = 1:length(tags)
    tag = tags{i};
    loadprh(tag);
    
    % cut depth to time of tag off
    t = (1:length(p))/fs/3600; % compute time vector in hours
   
    % import flow speed -- updated 25 Sept 2018
    load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
   
    % plot by time of day
    figure(100),
    subplot('position',[0.13 1.01-(i*0.11) 0.85 0.08]), hold on, box on
    UTC = tags{i,2}(4:end);
    % add sunrise and sunset
    [sun_rise,sun_set] = sunRiseSet(44.55,-66.4,-4,datestr(datenum(tags{i,2}(1:3))));
    sr = str2num(sun_rise(1:2))+str2num(sun_rise(4:5))/60+str2num(sun_rise(7:8))/3600;
    ss = str2num(sun_set(1:2))+str2num(sun_set(4:5))/60+str2num(sun_set(7:8))/3600;
    h1 = patch([ss 24+sr 24+sr ss ss],[8 8 -198 -198 0],[0.7 0.7 0.7]);
    h1.EdgeColor = [0.7 0.7 0.7]; h1.FaceAlpha = 0.7; h1.EdgeAlpha = 0.5;
    
    plot([0 30],[-50 -50],':','color',[0.8 0.8 0.8])
    
    % add playback info
    for pb = 1:size(tags{i,7},1)
        pbstart = tags{i,7}(pb,1)+tags{i,7}(pb,2)/60+tags{i,7}(pb,3)/3600; 
        pbend = tags{i,7}(pb,4)+tags{i,7}(pb,5)/60+tags{i,7}(pb,6)/3600; 
        plot([pbstart pbend],[-50 -50],'b','Linewidth',4)
        if sum(tags{i,7}) > 0 % if there is a playback
            % calculate time left in recording after playback
            tagend = datevec(addtodate(datenum(tags{i,2}),length(p)/fs,'second'));
            ttend(i) = etime(tagend,[tags{i,2}(1:3) tags{i,7}(end,4:6)])/3600; % time from end playback to end of recording in hours
            astart = 2+(tags{i,7}(end,4)+tags{i,7}(end,5)/60+tags{i,7}(end,6)/3600); % analysis start time: 2h after playback end
            plot([astart astart],[-200 10],'r:')
            % analysis start cue = 2h after playback end
            astartcue = (astart-(tags{i,2}(4)+tags{i,2}(5)/60+tags{i,2}(6)/3600))*3600*fs;
            tags{i,8} = astartcue; 
        else astartcue = 1;
        end
    end
    
    % how many dives > 50 m
    T = finddives(p,fs,50,1);
    d2after = find(T(:,1) > astartcue/fs); % find T after start cue only 
    ddur = T(:,2)-T(:,1); % calculate duration of all dives
    
    % put this here but only after astartcue 
    for j = d2after'
    %         if ~isempty(dive(j).vperblock)
                dcue = T(j,1):T(j,2); % time in seconds
                 plot((UTC(1)+UTC(2)/60+UTC(3)/3600)+(T(j,1):T(j,2))/3600,-p(round(dcue*fs)),'r','linewidth',3)
    %         end
        end
    
    % plot actual dive profile on top 
    hh=plot((UTC(1)+UTC(2)/60+UTC(3)/3600)+[1:length(p)]/fs/3600,-p,'k','LineWidth',1);
   
    ylim([-200 10]), xlim([8.5 30.5])
    set(gca,'ytick',[-150 -50 0],'yticklabels',[150 50 0],'xtick',10:2:30,'xticklabels',[10:2:24 2:2:6])
    text(28,-160,regexprep(tag(3:end),'_','-'))
    if i < length(tags), set(gca,'xtick',[]), end
    
    %%
         NARW_FilteredVol
         NARW_plotalldens
    
       figure(24), hold on
       for k = 1:length(dive)
           if isempty(dive(k).vperblock) == 0
               plot(dive(k).stops(:,2)-dive(k).stops(:,1),dive(k).vperblock,'o')
           end
       end
      xlabel('Duration of fluking bout (sec)'), ylabel('Volume filtered m^3')
    
    NARW_divepauseplot
    
    %     for k = 1:size(T,1) % all dives on a tag
    %         if isempty(dive(k).stops) == 0
    %             figure(11), subplot(2,2,1), hold on
    %             plot(ddur(k)/60,size(dive(k).stops,1),'o','color',tagc(i,:)) % color by tag
    %             allddur(i,k) = ddur(k); allnstops(i,k) = size(dive(k).stops,1);  % store those values
    %             xlabel('Dive duration (min)'), ylabel('Number of fluking bouts')
    %             subplot(2,2,2), hold on
    %             errorbar(ddur(k)/60,mean([dive(k).clearingtime]),std([dive(k).clearingtime]),'o','color',tagc(i,:)) % color by tag
    %             mnboutdur(i,k) = mean([dive(k).clearingtime]);
    %             xlabel('Dive duration (min)'), ylabel('Duration of fluking bouts (sec)')
    %         end
    %     end
    %     %
    %         if isempty(dive(k).btm) == 1 && sum(tag ~= 'eg05_210b') ~= 0 % if there's no bottom and if it's not dives 1-11 in this tag
    %             % descent speed
    %             phase_speed(k,1) = nanmean(dive(k).flowEst(round((T(k,1)+5:T(k,4))-T(k,1)+1)));
    %             phase_pitch(k,1) = nanmean(rad2deg(pitch((T(k,1):T(k,4))*fs)));
    %             % ascent speed
    %             phase_speed(k,2) = nanmean(dive(k).flowEst(round((T(k,4):T(k,2)-10)-T(k,1))));
    %             phase_pitch(k,2) = nanmean(rad2deg(pitch((T(k,4):T(k,2))*fs)));
    %         end
    %
    %           if dive(k).btm > 1
    %               % descent speed
    %               phase_speed(k,1) = nanmean(dive(k).flowEst(5:dive(k).btm(1)));
    %               phase_pitch(k,1) = mean(rad2deg(pitch(round(dcue(1:dive(k).btm(1))*fs))));
    %               % ascent speed
    %               if find(isinf(dive(k).flowEst),1,'last') < 10
    %                   phase_speed(k,2) = nanmean(dive(k).flowEst(dive(k).btm(end):end));
    %               else
    %                   phase_speed(k,2) = nanmean(dive(k).flowEst(dive(k).btm(end):find(isinf(dive(k).flowEst(5:end)) == 1,1,'first')));
    %               end
    %               phase_pitch(k,2) = mean(rad2deg(pitch(round(dcue(dive(k).btm(end):end)*fs))));
    %               % bottom speed
    %               phase_speed(k,3) = nanmean(dive(k).flowEst(dive(k).btm));
    %           end
    %            F(k) = isempty(dive(k).btm); % store that
    %     end
    %     tags{i,7} = phase_speed;
    %     tags{i,8} = phase_pitch;
    %     tags{i,9} = F;
    
    %     figure(90), hold on
    %     plot(T(:,3),1./(ddur/3600),'o')
    %     xlabel('Depth (m)'), ylabel('Dives per hour')
    %
    %
    %     [v,ph,~,~] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]); % calculate pitch deviation
    %     figure(3), clf, hold on
    %     plot(t,ph,'r')
    %     plot(t,-p/100,'k')
    %
    %     % pause
    %     save(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'],'dive','-append')
    if i < length(tags)
        clear p ptrack pitch ph Aw Mw fs phase_speed phase_pitch F % to remove carry-over of variables
    end
end


figure(100), 
xlabel('Local Time'), [ax1,ha] = suplabel('Depth (m)','y');  
adjustfigurefont
set(gcf,'position',[323 145 1038 528],'paperpositionmode','auto')
print('NARW_alldives_TOD_PB.png','-dpng','-r300')

return

figure(11), set(gcf,'paperpositionmode','auto')
subplot(2,2,3), hold on
plot(alldepth,allvperdive,'ro')
plot(alldepth(allvperdive<1),allvperdive(allvperdive<1),'ko')
ylim([0 1200]), xlim([0 200])
xlabel('Maximum dive depth (m)'), ylabel('Total volume filtered (m^3)')
subplot(2,2,4), hold on
plot(alldur/60,allvperdive,'ro')
plot(alldur(allvperdive<1)/60,allvperdive(allvperdive<1),'ko')
xlim([5 20]), ylim([0 1200]), box off
xlabel('Dive duration (min)'), ylabel('Total volume filtered (m^3)')

adjustfigurefont('helvetica',14)
subplot(2,2,1), text(5.5,18,'A','FontWeight','Bold','FontSize',18)
subplot(2,2,2), text(5.5,180,'B','FontWeight','Bold','FontSize',18)
subplot(2,2,3), text(8,1100,'C','FontWeight','Bold','FontSize',18)
subplot(2,2,4), text(5.5,1100,'D','FontWeight','Bold','FontSize',18)

print('NARW_boutregress.png','-dpng','-r300')

return

% get phase info from structure
allphases = [];
for i = 1:length(tags)
    for j = 1:size(tags{i,7},1)
        allphases(end+1,:) = tags{i,7}(j,:);
    end
end
% replace anything
allphases(isinf(allphases)) = NaN;
std(allphases(allphases(:,3) > 0,3))

%% stats
lm1 = fitlm(allddur(~isnan(allddur)),allnstops(~isnan(allnstops)))
plot(lm1)

lm2 = fitlm(allddur(~isnan(allddur)),mnboutdur(~isnan(mnboutdur)))
plot(lm2)



% figure(101), xlabel('Hours since tag on'), adjustfigurefont
% set(gcf,'position',[323 61 512 612],'paperpositionmode','auto')
% print('NARW_alldives_TSTO.png','-dpng','-r300')

% max(vertcat(tags{:,5}))/60 = longest surface time above 10 m



