% list of deployments
clear, close all, warning off

% tags is deployment name, time of tag on, cue of tag off
load('NARW_foraging_tags_all')
% 7 is playback start/end time; 000000 = no playbacks
% 8 is analysis start time (2h after end last playback)
% 9 is dives to analyze
%%
% allddur = nan(10,40); allnstops = nan(10,40);
% mnboutdur = nan(10,40);
tagc = viridis(size(tags,1)); % color for tags
%%
for i = 8; %1:size(tags,1)
    tag = tags{i};
    loadprh(tag);
    
    % cut depth to time of tag off
    t = (1:length(p))/fs/3600; % compute time vector in hours
    
    
    % plot by time of day
    if i < 10, fg = 100; sb = i;
    else if i >= 10 & i < 19, fg = 101; sb = i-9;
        else if i >= 19 & i < 28, fg = 102; sb = i-18;
            else if i >= 28 & i < 37, fg = 103; sb = i-27;
                else if i >= 37 & i < 47, fg = 104; sb = i-36;
                    end
                end
            end
        end
    end
        
    figure(fg),set(gcf,'position',[323 145 1038 604],'paperpositionmode','auto')
    subplot('position',[0.13 1.0-(sb*0.11) 0.86 0.09]), hold on, box on
    UTC = tags{i,2}(4:end);
    % add sunrise and sunset
    [sun_rise,sun_set] = sunRiseSet(44.55,-66.4,-4,datestr(datenum(tags{i,2}(1:3))));
    sr = str2num(sun_rise(1:2))+str2num(sun_rise(4:5))/60+str2num(sun_rise(7:8))/3600;
    ss = str2num(sun_set(1:2))+str2num(sun_set(4:5))/60+str2num(sun_set(7:8))/3600;
    h1 = patch([ss 24+sr 24+sr ss ss],[8 8 -198 -198 0],[0.7 0.7 0.7]);
    h1.EdgeColor = [0.7 0.7 0.7]; h1.FaceAlpha = 0.7; h1.EdgeAlpha = 0.5;
    
    % plot([0 30],[-50 -50],':','color',[0.8 0.8 0.8])
    
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
    
    % plot actual dive profile on top
    hh=plot((UTC(1)+UTC(2)/60+UTC(3)/3600)+[1:length(p)]/fs/3600,-p,'k','LineWidth',1);
    
    ylim([-200 1]), xlim([8.5 30.5])
    set(gca,'ytick',[-150 -50 0],'yticklabels',[150 50 0],'xtick',10:2:30,'xticklabels',[10:2:24 2:2:6])
    text(27.9,-160,regexprep(tag(3:end),'_','-'),'FontSize',14)
    text(29.3,-160,['n = ' num2str(size(tags{i,9},1))],'FontSize',14)
    if i < size(tags,1), set(gca,'xtick',[]), end
    
    %%
    
    if i < size(tags,1)
        clear p ptrack pitch ph Aw Mw fs phase_speed phase_pitch F % to remove carry-over of variables
    end
end


figure(100),
[ax1,ha] = suplabel('Local Time','x'); [ax1,ha] = suplabel('Depth (m)','y');
adjustfigurefont('Helvetica',18)
set(gcf,'position',[323 145 1038 604],'paperpositionmode','auto')
% print('NARW_alldives_TOD_PB.png','-dpng','-r300')

return

%% plot select for presentation 
sb = 0; 
figure(2); clf
for i = [16 24:27 50]
    tag = tags{i};
    loadprh(tag);
    
    % cut depth to time of tag off
    t = (1:length(p))/fs/3600; % compute time vector in hours
    
    
    % plot by time of day
    sb = sb+1; 
    figure(2),set(gcf,'position',[323 145 1038 604],'paperpositionmode','auto')
    subplot('position',[0.13 1.012-(sb*0.15) 0.86 0.12]), hold on, box on
    UTC = tags{i,2}(4:end);
    % add sunrise and sunset
    [sun_rise,sun_set] = sunRiseSet(44.55,-66.4,-4,datestr(datenum(tags{i,2}(1:3))));
    sr = str2num(sun_rise(1:2))+str2num(sun_rise(4:5))/60+str2num(sun_rise(7:8))/3600;
    ss = str2num(sun_set(1:2))+str2num(sun_set(4:5))/60+str2num(sun_set(7:8))/3600;
    h1 = patch([ss 24+sr 24+sr ss ss],[8 8 -198 -198 0],[0.7 0.7 0.7]);
    h1.EdgeColor = [0.7 0.7 0.7]; h1.FaceAlpha = 0.7; h1.EdgeAlpha = 0.5;
    
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
    
    % plot actual dive profile on top
    hh=plot((UTC(1)+UTC(2)/60+UTC(3)/3600)+[1:length(p)]/fs/3600,-p,'k','LineWidth',1);
    
    ylim([-200 1]), xlim([8.5 30.5])
    set(gca,'ytick',[-150 -50 0],'yticklabels',[150 50 0],'xtick',10:2:30,'xticklabels',[10:2:24 2:2:6])
    text(27.9,-160,regexprep(tag(3:end),'_','-'),'FontSize',14)
    text(29.3,-160,['n = ' num2str(size(tags{i,9},1))],'FontSize',14)
    if i < 50, set(gca,'xtick',[]), end
    
    %%
    
    
        clear p ptrack pitch ph Aw Mw fs phase_speed phase_pitch F % to remove carry-over of variables
end
[ax1,ha] = suplabel('Local Time','x'); [ax1,ha] = suplabel('Depth (m)','y');
adjustfigurefont('Helvetica',18)
set(gcf,'position',[323 145 1038 600],'paperpositionmode','auto')
print('NARW_alldives_TOD_PRES.png','-dpng','-r300')

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


