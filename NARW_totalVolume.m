% load tags
load('NARW_foraging_tags')
figure(10), clf
% for all files
allvols = [];
allbouts = [];
allvperdive = [];
allspeeds = []; 
for i = 1:length(tags)
    tag = tags{i};
    c = get(gca,'colororder'); % get color order
    c = repmat(c,ceil(max([tags{:,6}])/size(c,1)),1);    % repeat color order for number of dives
    
    % import flow speed for the tag
    load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
    
    % calculate total volume
    vperdive = []; % clear it 
    for j = 1:length(dive)
        vperdive(j) = sum(dive(j).vperblock);
        allvperdive(end+1) = vperdive(j); 
        for k = 1:length(dive(j).vperblock)
            if isempty(dive(j).vperblock) ~= 1
                allvols(end+1) = dive(j).vperblock(k); % make massive vector of all volumes
                allbouts(end+1) = dive(j).stops(k,2)-dive(j).stops(k,1); % make massive vector of all durations
                allspeeds(end+1) = dive(j).mnspeedperblock(k); % make massive vector of all speeds
            end
        end
    end
    
    figure(10), subplot(length(tags),1,i), hold on
    if i == 8
        histogram(vperdive(11:end),'binwidth',25,'facecolor',c(tags{i,6},:)) % because missing first 10 dives
    else 
    histogram(vperdive,'binwidth',25,'facecolor',c(tags{i,6},:))
    end
    yl = get(gca,'ylim'); text(50,yl(2)*0.75,strcat('Age   ',num2str(tags{i,6}))) 
    xlim([0 1050])
end
xlabel('Total Volume Filtered Per Dive (m^3)')
adjustfigurefont
set(gcf,'position',[13     5   512   668],'paperpositionmode','auto')
print('volfiltered_each.png','-dpng','-r300')

[mean(allvperdive) std(allvperdive)]
[mean(allvols) std(allvols)]
[mean(allbouts) std(allbouts)]
[mean(allspeeds) std(allspeeds)]