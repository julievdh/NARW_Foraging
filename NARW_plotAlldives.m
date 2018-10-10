% list of deployments
clear, close all, warning off
% tags is deployment name, time of tag on, cue of tag off
load('NARW_foraging_tags')
% 7 is playback start/end time; 000000 = no playbacks
% 8 is analysis start time (2h after end last playback)
% 9 is dives to analyze 
%%
allddur = nan(10,40); allnstops = nan(10,40);
mnboutdur = nan(10,40);
tagc = viridis(10); % color for tags
%%
for i = 1:size(tags,1)
    tag = tags{i};
    loadprh(tag);
    
    % cut depth to time of tag off
    t = (1:length(p))/fs/3600; % compute time vector in hours
   
    % import flow speed -- updated 25 Sept 2018
    load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
   
    % flow speed fit
    gof(i,:) = [g.rsquare g.rmse]; 
    
    % plot by time of day
    figure(100),
    subplot('position',[0.13 1.01-(tags{i,13}*0.11) 0.86 0.09]), hold on, box on
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
    if i == 7, d2after = d2after(1:end-1); end 
    tags{i,9} = d2after; % store 
    ddur = T(:,2)-T(:,1); % calculate duration of all dives
    
    % put this here but only after astartcue 
    for j = d2after'
            if ~isempty(dive(j).vperblock)
                dcue = T(j,1):T(j,2); % time in seconds
                 plot((UTC(1)+UTC(2)/60+UTC(3)/3600)+(T(j,1):T(j,2))/3600,-p(round(dcue*fs)),'r','linewidth',3)
           end
        end
    
    % plot actual dive profile on top 
    hh=plot((UTC(1)+UTC(2)/60+UTC(3)/3600)+[1:length(p)]/fs/3600,-p,'k','LineWidth',1);
   
    ylim([-200 1]), xlim([8.5 30.5])
    set(gca,'ytick',[-150 -50 0],'yticklabels',[150 50 0],'xtick',10:2:30,'xticklabels',[10:2:24 2:2:6])
    text(28,-160,regexprep(tag(3:end),'_','-'),'FontSize',12)
    text(29.3,-160,['n = ' num2str(size(tags{i,9},1))],'FontSize',12)
    if tags{i,13} < size(tags,1), set(gca,'xtick',[]), end 
    
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
    
%     NARW_divepauseplot
    
         for k = tags{i,9}' % all dives in analysis 
            dcue = T(k,1):T(k,2); % cues for that dive
            if isempty(dive(k).stops) == 0
                figure(11), subplot('position',[0.75 0.1 0.2 0.8]), hold on % plot duration vs. number of stops
                plot(ddur(k)/60,size(dive(k).stops,1),'o','color',tagc(i,:),'linewidth',1.5) % color by tag
                allddur(i,k) = ddur(k); allnstops(i,k) = size(dive(k).stops,1);  % store those values
                xlabel('Dive duration (min)'), ylabel('Number of fluking bouts')
                subplot('position',[0.5 0.1 0.2 0.8]), hold on
                errorbar(ddur(k)/60,mean([dive(k).clearingtime]),std([dive(k).clearingtime]),'o','color',tagc(i,:),'linewidth',1.5) % color by tag
                mnboutdur(i,k) = mean([dive(k).clearingtime]);
                xlabel('Dive duration (min)'), ylabel('Fluking bout duration (sec)')
            end
    %     end
    %     %
            if isempty(dive(k).vperblock) == 1 
                % descent speed
                phase_speed(k,1) = nanmean(dive(k).flowEst(round((T(k,1)+5:T(k,4))-T(k,1)+1)));
                phase_pitch(k,1) = nanmean(rad2deg(pitch((T(k,1):T(k,4))*fs)));
                % ascent speed
                phase_speed(k,2) = nanmean(dive(k).flowEst(round((T(k,4):T(k,2)-10)-T(k,1))));
                phase_pitch(k,2) = nanmean(rad2deg(pitch((T(k,4):T(k,2))*fs)));
            end
    
          if dive(k).vperblock > 1
                  % descent speed
                  phase_speed(k,1) = nanmean(dive(k).flowEst(5:dive(k).btm(1)));
                  phase_pitch(k,1) = mean(rad2deg(pitch(round(dcue(1:dive(k).btm(1))*fs))));
                  [pks,locs] = findpeaks(ph(round(dcue(1:dive(k).btm(1))*fs)),fs,'minpeakdistance',0.8,'minpeakprominence',0.05);
                  phase_fsr(k,1) = 1./mean(diff(locs))/fs;
                  % ascent speed
                  if find(isinf(dive(k).flowEst),1,'last') < 10
                      phase_speed(k,2) = nanmean(dive(k).flowEst(dive(k).btm(end):end));
                  else
                      phase_speed(k,2) = nanmean(dive(k).flowEst(dive(k).btm(end):find(isinf(dive(k).flowEst(5:end)) == 1,1,'first')));
                  end
                  phase_pitch(k,2) = mean(rad2deg(pitch(round(dcue(dive(k).btm(end):end)*fs))));
                  [pks,locs] = findpeaks(ph(round(dcue(dive(k).btm(end):end)*fs)),fs,'minpeakdistance',0.8,'minpeakprominence',0.05);
                  phase_fsr(k,2) = 1./mean(diff(locs))/fs;
                 
                  % bottom speed
                  phase_speed(k,3) = nanmean(dive(k).flowEst(dive(k).btm));
                  [pks,locs] = findpeaks(ph(round(dcue(dive(k).btm)*fs)),fs,'minpeakdistance',0.8,'minpeakprominence',0.05);
                  phase_fsr(k,3) = 1./mean(diff(locs))/fs;
                 
              end
               F(k) = isempty(dive(k).vperblock); % store that
        end
         tags{i,10} = phase_speed;
         tags{i,11} = phase_pitch;
         tags{i,12} = F;
         tags{i,13} = phase_fsr; 
    
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
         save(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'],'dive','-append')
    if i < size(tags,1)
        clear p ptrack pitch ph Aw Mw fs phase_speed phase_pitch F % to remove carry-over of variables
    end
end


figure(100), 
[ax1,ha] = suplabel('Local Time','x'); [ax1,ha] = suplabel('Depth (m)','y');  
adjustfigurefont('Helvetica',16)
set(gcf,'position',[323 145 1038 528],'paperpositionmode','auto')
print('NARW_alldives_TOD_PB.png','-dpng','-r300')

return

figure(11), set(gcf,'paperpositionmode','auto','position',[4         289        1005         384])
subplot('position',[0.07 0.1 0.35 0.8]), hold on
plot(alldepth,allvperdive,'ro','linewidth',1.5)
plot(alldepth(allvperdive<1),allvperdive(allvperdive<1),'ko','linewidth',1.5)
ylim([0 1700]), xlim([0 200])
axletter(gca,'D')
xlabel('Maximum dive depth (m)'), ylabel('Total volume filtered (m^3)')

adjustfigurefont('helvetica',16)

subplot('position',[0.5 0.1 0.2 0.8]), hold on 
xlim([400/60 1000/60]), axletter(gca,'E')
subplot('position',[0.75 0.1 0.2 0.8]), hold on % plot duration vs. number of stops
ylim([0 15]), xlim([0 1000/60]), axletter(gca,'F')

print('NARW_boutregress.png','-dpng','-r300')

lm_depth = fitlm(alldepth(allvperdive > 1),allvperdive(allvperdive > 1)); 
return

% get phase info from structure
allphase_speed = []; allphase_pitch = []; allF = []; allphase_fsr = [];  
for i = 1:size(tags,1)
    for j = 1:size(tags{i,10},1)
        allphase_speed(end+1,:) = tags{i,10}(j,:);
        allphase_pitch(end+1,:) = tags{i,11}(j,:); 
        allphase_fsr(end+1,:) = tags{i,13}(j,:); 
        allF(end+1) = tags{i,12}(j); % this one isn't working
    end
end
% replace anything
allphase_speed(allphase_speed == 0) = NaN; 
allphase_pitch(allphase_pitch == 0) = NaN; 
allphase_fsr(allphase_fsr == 0) = NaN; 
% nanmean(allphase_pitch(allF == 1,:))
% nanmean(allphase_pitch(allF == 0,:))


%% stats
lm1 = fitlm(allddur(~isnan(allddur)),allnstops(~isnan(allnstops))) % dive duration and number of pauses 
plot(lm1)

lm2 = fitlm(allddur(~isnan(allddur)),mnboutdur(~isnan(mnboutdur))) % bout duration and dive duration 
plot(lm2)

