% load tags
% load('NARW_foraging_tags')
figure(10), clf
% for all files
% BOUT-SPECIFIC
allvols = []; % all filtered volumes per bout
allbouts = []; % all bout durations
allpauses = [];
allspeeds = []; % speeds of all bouts
allrms = []; % RMS amplitude during all bouts
allfsr = []; % fluke stroke rate during all bouts
tagid = []; % tag ID counter
d = []; % dive counter

% DIVE-SPECIFIC
tagid2 = []; 
allbperdive = []; % number of bouts per dive
allvperdive = []; % all volumes per dive
alldur = []; % all dive durations
alldepth = []; % all dive depths
allprop = []; % all prop of time on bottom
allbtmspeed = [];
sdbtmspeed = []; 
NF = []; % non-foraging dives
for i = 1:size(tags,1)
    tag = tags{i,1};
    col = get(gca,'colororder'); % get color order
    col = repmat(col,ceil(max([tags{:,6}])/size(col,1)),1);    % repeat color order for number of dives
    
    % import flow speed for the tag
    load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
    ddur = T(:,2)-T(:,1); % calculate dive duration
    % calculate total volume
    vperdive = []; % clear it
    for j = tags{i,9}' % over the dives in the analysis portion
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
        tagid2(end+1,1) = i; 
        if isempty(dive(j).vperblock) == 0
            allprop(end+1,1:2) = dive(j).prop; % proportion of time spent foraging
            allbtmspeed(end+1) = mean(dive(j).flowEst(dive(j).btm)); % mean bottom speed
            sdbtmspeed(end+1) = std(dive(j).flowEst(dive(j).btm)); % sd
        else
            allprop(end+1,1:2) = NaN; % proportion of time spent foraging
            allbtmspeed(end+1) = NaN; % mean bottom speed
            sdbtmspeed(end+1) = NaN; % sd
        end
        alldepth(end+1,1) = T(j,3);
        allbperdive(end+1,1) = size(dive(j).stops,1); 
    end
    
    figure(10), subplot('position',[0.1 1.0-(i*0.11) 0.85 0.08]), hold on, box off
    
    histogram(vperdive(tags{i,9}),'binwidth',25) % 'facecolor',col(tags{i,6},:))
    ylim([0 10])
    yl = get(gca,'ylim');
    text(50,yl(2)*0.85,strcat('Age:   ',num2str(tags{i,6}),'  Gape:  ',num2str(getgape(tags{i,6}),2),' m^2'))
    text(50,yl(2)*0.6,regexprep(tag(3:end),'_','-'))
    
    xlim([0 2000]),
    if i < size(tags,1), set(gca,'xtick',[]), end
end
xlabel('Total Volume Filtered (m^3) Per Dive ')
adjustfigurefont
set(gcf,'position',[13     5   512   668],'paperpositionmode','auto')
print('volfiltered_each.png','-dpng','-r300')


[mean(allvperdive(allvperdive>0)) std(allvperdive(allvperdive>0))] % volumes per dive
[mean(allvols) std(allvols)]
[mean(allbouts) std(allbouts)]
[mean(allspeeds) std(allspeeds)]

[mean(alldepth(allvperdive > 1)) std(alldepth(allvperdive > 1))]
[mean(alldepth(allvperdive < 1)) std(alldepth(allvperdive < 1))]

%% 
for i = 1:length(tagid2)
gape = getgape(tags{tagid2(i),6});
gapes(:,i) = gape;
end 
figure(9), clf, hold on 
for i = 1:length(allbtmspeed)
h = plot3([allbtmspeed(i)-sdbtmspeed(i) allbtmspeed(i)+sdbtmspeed(i)],[gapes(i) gapes(i)],[(allprop(i,2)-allprop(i,1)).*alldur(i) (allprop(i,2)-allprop(i,1)).*alldur(i)],'color',[0.5 0.5 0.5]);
alpha(h,0.5)
end
scatter3(allbtmspeed,gapes,(allprop(:,2)-allprop(:,1)).*alldur,60,allvperdive,'filled','markeredgecolor','k')
xlabel('Bottom speed (m/s)')
ylabel('Gape area (m^2)')
zlabel('Bottom time (sec)')
grid on
h = colorbar; 
ylabel(h,'Volume filtered (m^3)')
adjustfigurefont('Helvetica',14)
view([-39.2000   13.2000])

print('NARW_3dFiltVol.png','-dpng','-r300')


%% proportional depth figure
figure(111), clf, hold on 
col = viridis(17); % ages 2 to 18
for i = 1:length(allprop)
plot(allprop(i,:),[alldepth(i) alldepth(i)],'color',col(tags{tagid2(i),6}-1,:))
end
ylim([95 180])
xlabel('Proportion of dive cycle foraging'), ylabel('Maximum Dive Depth (m)')
adjustfigurefont('Helvetica',14)
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