% list of deployments
% tags = {'eg05_219a'; 'eg05_224a'; 'eg05_230a'; 'eg05_231a';'eg05_231b';'eg05_232a';'eg05_235a';
%    'eg02_213b';'eg02_213g';'eg02_220f';'eg02_221d';'eg02_222c';'eg02_229e';'eg02_232d';
%    'eg02_233a';'eg02_236c'};%'eg05_218c'};
close all
% tags is deployment name, time of tag on, cue of tag off
load('NARW_foraging_tags')
%%
for i = 4%:10; % 1:length(tags)
    tag = tags{i};
    loadprh(tag);
    
    % cut depth to time of tag off
    %p = p(1:tags{i,3});
    t = (1:length(p))/fs/3600; % compute time vector
    
    % compute amount of time within 10m of surface
    %[tags{i,4},tags{i,5}] = findsurftime(p,fs,10);
    %figure(5), subplot(length(tags),1,i), hold on
    %histogram(tags{i,5}/60,0:1:80), xlabel('Continuous Surface Time (min)')
    
    %figure(6), hold on
    %cdfplot(tags{i,5}/60)
       
    % how many dives > 50 m
    T = finddives(p,fs,50,1);
    % mean(T(:,2)-T(:,1))/60
    
    % import flow speed for the tag
    load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
    
    NARW_FilteredVol
    NARW_plotalldens 
    
    figure(24), hold on
    for k = 1:length(dive)
        if isempty(dive(k).vperblock) == 0
        plot(dive(k).stops(:,2)-dive(k).stops(:,1),dive(k).vperblock,'o')
        end
    end
    xlabel('Duration of fluking bout (sec)'), ylabel('Volume filtered m^3')

% plot by time of day
figure(100), subplot(length(tags),1,i), hold on, box on
UTC = tags{i,2}(4:end);
hh=plot((UTC(1)+UTC(2)/60+UTC(3)/3600)+[1:length(p)]/fs/3600,-p,'k','LineWidth',1);
ylim([-200 10]), xlim([9 24])

figure(101), subplot(length(tags),1,i), hold on, box on
plot(t,-p,'k'), ylim([-200 10]), xlim([0 11.7]) % xmax of tags

NARW_divepauseplot

for k = 1:size(T,1) % all dives on a tag
    if isempty(dive(k).stops) == 0
        figure(11), subplot(2,2,1), hold on
        plot(ddur(k)/60,size(dive(k).stops,1),'o')
        xlabel('Dive Duration (min)'), ylabel('Number of fluking bouts')
        subplot(2,2,2), hold on
        errorbar(ddur(k)/60,mean([dive(k).clearingtime]),std([dive(k).clearingtime]),'o')
        xlabel('Dive Duration (min)'), ylabel('Duration of fluking bouts (sec)')
        subplot(2,2,3), hold on
        plot(ddur(k)/60,tags{i,6},'o')
        xlabel('Dive Duration (min)'), ylabel('Age (years)')
        subplot(2,2,4), hold on
        errorbar(tags{i,6},mean([dive(k).vperblock]),std([dive(k).vperblock]),'o')
        xlabel('Age (years)'), ylabel('Volume filtered per fluking interval (m^3)')
    end
    
    
    if isempty(dive(k).btm) == 1 && sum(tag ~= 'eg05_210b') ~= 0 % if there's no bottom and if it's not dives 1-11 in this tag
        % descent speed
        phase_speed(k,1) = nanmean(dive(k).flowEst(round((T(k,1)+5:T(k,4))-T(k,1)+1)));
        phase_pitch(k,1) = nanmean(rad2deg(pitch((T(k,1):T(k,4))*fs)));
        % ascent speed
        phase_speed(k,2) = nanmean(dive(k).flowEst(round((T(k,4):T(k,2)-10)-T(k,1))));
        phase_pitch(k,2) = nanmean(rad2deg(pitch((T(k,4):T(k,2))*fs)));
    end
    
    if dive(k).btm > 1
        % descent speed
        phase_speed(k,1) = nanmean(dive(k).flowEst(5:dive(k).btm(1)));
        phase_pitch(k,1) = mean(rad2deg(pitch(round(dcue(1:dive(k).btm(1))*fs))));
        % ascent speed
        if find(isinf(dive(k).flowEst),1,'last') < 10
            phase_speed(k,2) = nanmean(dive(k).flowEst(dive(k).btm(end):end));
        else
            phase_speed(k,2) = nanmean(dive(k).flowEst(dive(k).btm(end):find(isinf(dive(k).flowEst(5:end)) == 1,1,'first')));
        end
        phase_pitch(k,2) = mean(rad2deg(pitch(round(dcue(dive(k).btm(end):end)*fs))));
        % bottom speed
        phase_speed(k,3) = nanmean(dive(k).flowEst(dive(k).btm));
    end
    F(k) = isempty(dive(k).btm); % store that
end
tags{i,7} = phase_speed;
tags{i,8} = phase_pitch;
tags{i,9} = F;

figure(90), hold on 
plot(T(:,3),1./(ddur/3600),'o')
xlabel('Depth (m)'), ylabel('Dives per hour') 


[v,ph,~,~] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]); % calculate pitch deviation
figure(3), clf, hold on 
plot(t,ph,'r')
plot(t,-p/100,'k')

pause 

if i < 10
    clear p ptrack pitch ph Aw Mw fs % to remove carry-over of variables
end
end

return 


figure(100), xlabel('Local Time'), adjustfigurefont
set(gcf,'position',[323 61 512 612],'paperpositionmode','auto')
print('NARW_alldives_TOD.png','-dpng','-r300')

figure(101), xlabel('Hours since tag on'), adjustfigurefont
set(gcf,'position',[323 61 512 612],'paperpositionmode','auto')
print('NARW_alldives_TSTO.png','-dpng','-r300')

% max(vertcat(tags{:,5}))/60 = longest surface time above 10 m

