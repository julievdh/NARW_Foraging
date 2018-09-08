% load tags
load('NARW_foraging_tags')
figure(10), clf
% for all files
allvols = []; % all filtered volumes per bout
allbouts = []; % all bout durations
allpauses = []; 
allvperdive = []; % all volumes per dive
allspeeds = []; % speeds of all bouts
allrms = []; % RMS amplitude during all bouts
allfsr = []; % fluke stroke rate during all bouts
d = []; % dive counter
alldur = []; % all dive durations
alldepth = []; % all dive depths
tagid = []; % tag ID counter
NF = []; % non-foraging dives
for i = 1:length(tags)
    tag = tags{i};
    c = get(gca,'colororder'); % get color order
    c = repmat(c,ceil(max([tags{:,6}])/size(c,1)),1);    % repeat color order for number of dives
    
    % import flow speed for the tag
    load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
    ddur = T(:,2)-T(:,1); % calculate dive duration
    % calculate total volume
    vperdive = []; % clear it
    for j = 1:length(dive)
        vperdive(j) = sum(dive(j).vperblock);
        allvperdive(end+1) = vperdive(j);
        for k = 1:length(dive(j).vperblock)
            if isempty(dive(j).vperblock) ~= 1
                allvols(end+1,1) = dive(j).vperblock(k); % make massive vector of all volumes
                allbouts(end+1,1) = dive(j).stops(k,2)-dive(j).stops(k,1); % make massive vector of all durations
                allspeeds(end+1,1) = dive(j).mnspeedperblock(k); % make massive vector of all speeds
                allrms(end+1,1) = dive(j).rms(k); % make massive vector of RMS
                allfsr(end+1,1) = dive(j).fsr(k); % make massive vector of fluke stroke rate
                d(end+1,1) = j;
                tagid(end+1,1) = i;
            end
        end
        for k = 2:size(dive(j).stops,1)
            allpauses(end+1,1) = dive(j).stops(k,1)-dive(j).stops(k-1,2); 
        end
        if isempty(dive(j).vperblock) == 1 
            NF(end+1,1:2) = [j i];
        end
        alldur(end+1,1) = ddur(j);
        alldepth(end+1,1) = T(j,3);
    end
    
    figure(10), subplot('position',[0.13 1.0-(i*0.095) 0.8 0.08]), hold on, box off
    if i == 8
        histogram(vperdive(11:end),'binwidth',25,'facecolor',c(tags{i,6},:)) % because missing first 10 dives
    else
        histogram(vperdive,'binwidth',25,'facecolor',c(tags{i,6},:))
    end
    ylim([0 10])
    yl = get(gca,'ylim'); text(50,yl(2)*0.85,strcat('Age   ',num2str(tags{i,6})))
    text(50,yl(2)*0.65,regexprep(tag(3:end),'_','-'))
    xlim([0 1050]),
    if i <= 9, set(gca,'xtick',[]), end
end
xlabel('Total Volume Filtered (m^3) Per Dive ')
adjustfigurefont
set(gcf,'position',[13     5   512   668],'paperpositionmode','auto')
print('volfiltered_each.png','-dpng','-r300')

NF = NF([1:17 28:31],:); % because first 10 dives of tag 8 are foraging dives but just don't have sound
allvperdive = allvperdive([1:117 128:end]); 
alldur = alldur([1:117 128:end]); 
alldepth = alldepth([1:117 128:end]); 

[mean(allvperdive(allvperdive>0)) std(allvperdive(allvperdive>0))]
[mean(allvols) std(allvols)]
[mean(allbouts) std(allbouts)]
[mean(allspeeds) std(allspeeds)]

[mean(alldepth(allvperdive > 1)) std(alldepth(allvperdive > 1))]
[mean(alldepth(allvperdive < 1)) std(alldepth(allvperdive < 1))]


%%
% tbl = table(allvols, allbouts, allrms, allspeeds, alldur, d, tagid);
% fitlme(tbl,'allrms ~ allbouts + (1|tagid)')

%% calculate total volume per tag to get filtration rate

% figure(99), clf, hold on 
% for i = 1:length(allspeeds)
% plot(allspeeds(i),tags{tagid(i),6},'o','color',c(tags{tagid(i),6},:))
% end
return 

mean(alldur(allvperdive > 1)) % mean dive duration in seconds 
dbd_vrate = allvperdive./(alldur'/3600); % dive-by-dive filtration rate (m^3/h) 
[mean(dbd_vrate(allvperdive > 1)) std(dbd_vrate(allvperdive > 1))]/3600
for i = 1:length(tags)
dep_filtrate(i) = sum(allvols(tagid == i))/(gettagdur(tags{1})/3600); 
end
[min(dep_filtrate) max(dep_filtrate)]
for i = 1:length(allspeeds)
    gape = getgape(tags{tagid(i),6}); 
    all_hr_rate(:,i) = allspeeds(i)*gape*3600; % filtration rate of all (m3/h)
    gapes(:,i) = gape; 
end
[mean(all_hr_rate) std(all_hr_rate)]/3600

% fluke stroke rate
[nanmean(allfsr) nanstd(allfsr)] 

return 

% plot bout duration vs. age 
for i = 1:length(tags)
figure(9), hold on
errorbar(tags{i,6}+rand(1),mean(allbouts(tagid == i)),std(allbouts(tagid == i)))
end

%% bouts per dive statistics
% % set nans first 
% cv_bouts_bydive = nan(10,39); 
% b_perdive = nan(10,39); 
% for i = 1:10; 
% for j = 1:size(unique(d(tagid == i))) 
%    un = unique(d(tagid == i)); 
%    cv_bouts_bydive(i,j) = std(allbouts(find(d(tagid == i) == un(j))))/mean(allbouts(find(d(tagid == i) == un(j)))); 
% end
% end
% % size(find(cv_bouts_bydive > 0)) % just check size

%% stat test 
load fisheriris
diveid = tagid.*d; 
t = table(tagid,diveid,allbouts,allrms,allfsr,allspeeds,...
'VariableNames',{'tagid','diveid','meas1','meas2','meas3','meas4'});
Meas = table([1 2 3 4]','VariableNames',{'Measurements'});

rm = fitrm(t,'meas1-meas4~tagid+diveid','WithinDesign',Meas)