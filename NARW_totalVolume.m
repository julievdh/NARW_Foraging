% load tags
load('NARW_foraging_tags')
figure(10), clf
% for all files
for i = 1:length(tags)
    tag = tags{i};
    
    % import flow speed for the tag
    load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
    
    % calculate total volume
    for j = 1:length(dive)
        vperdive(j) = sum(dive(j).vperblock);
    end
    
    figure(10), subplot(length(tags),1,i), hold on
    histogram(vperdive,'binwidth',25,'facecolor',c(tags{i,6},:))
    xlim([0 1050])
    clear vperdive
end
xlabel('Total Volume Filtered Per Dive (m^3)')
