% list of deployments
% tags = {'eg05_219a'; 'eg05_224a'; 'eg05_230a'; 'eg05_231a';'eg05_231b';'eg05_232a';'eg05_235a';
%    'eg02_213b';'eg02_213g';'eg02_220f';'eg02_221d';'eg02_222c';'eg02_229e';'eg02_232d';
%    'eg02_233a';'eg02_236c'};%'eg05_218c'};
close all
% tags is deployment name, time of tag on, cue of tag off
load('NARW_foraging_tags')

for i = 1:length(tags)
    tag = tags{i};
    loadprh(tag);
    
    % cut depth to time of tag off
    %p = p(1:tags{i,3});
    t = (1:length(p))/fs/3600; % compute time vector
    
    % compute amount of time within 10m of surface
    [tags{i,4},tags{i,5}] = findsurftime(p,fs,10);
    figure(5), subplot(length(tags),1,i), hold on
    histogram(tags{i,5}/60,0:1:80), xlabel('Continuous Surface Time (min)')
    
    %figure(6), hold on
    %cdfplot(tags{i,5}/60)
    
    
    % how many dives > 50 m
    T = finddives(p,fs,50,1);
    % mean(T(:,2)-T(:,1))/60
    % pause
    
    % plot by time of day
    figure(100), subplot(length(tags),1,i), hold on, box on
    UTC = tags{i,2}(4:end);
    hh=plot((UTC(1)+UTC(2)/60+UTC(3)/3600)+[1:length(p)]/fs/3600,-p,'k','LineWidth',1);
    ylim([-200 10]), xlim([9 24])
    
    figure(101), subplot(length(tags),1,i), hold on, box on
    plot(t,-p,'k'), ylim([-200 10]), xlim([0 11.7]) % xmax of tags
    
    NARW_plotalldens
    NARW_divepauseplot
    
    keep tags i % to remove carry-over of variables
end
figure(100), xlabel('Local Time'), adjustfigurefont
set(gcf,'position',[323 61 512 612],'paperpositionmode','auto')
print('NARW_alldives_TOD.png','-dpng','-r300')

figure(101), xlabel('Hours since tag on'), adjustfigurefont
set(gcf,'position',[323 61 512 612],'paperpositionmode','auto')
print('NARW_alldives_TSTO.png','-dpng','-r300')

% max(vertcat(tags{:,5}))/60 = longest surface time above 10 m

