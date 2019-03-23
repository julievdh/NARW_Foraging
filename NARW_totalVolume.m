% load tags
% load('NARW_foraging_tags')
figure(10), clf
% for all files
% BOUT-SPECIFIC
allvols = []; % all filtered volumes per bout
allbouts = []; % all bout durations
allpauses = []; % pause duration (s)
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
allstart = []; % all bottom start
allend = []; % all bottom end
allbtmdur = []; % all bottom duration
allbtmspeed = [];
sdbtmspeed = [];
alltort = [];
mnboutdur = []; % mean bout duration for dives
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
            allpauses(end+1,1) = dive(j).stops(k,1)-dive(j).stops(k-1,2); % pause duration
        end
        if isempty(dive(j).vperblock) == 1
            NF(end+1,1:2) = [j i];
        end
        alldur(end+1,1) = ddur(j);
        tagid2(end+1,1) = i;
        if isempty(dive(j).vperblock) == 0
            allprop(end+1,1:2) = dive(j).prop; % proportion of time spent foraging
            allstart(end+1) = dive(j).btm(1);
            allend(end+1) = dive(j).btm(end);
            allbtmdur(end+1) = dive(j).btm(end)-dive(j).btm(1);
            allbtmspeed(end+1) = mean(dive(j).flowEst(dive(j).btm)); % mean bottom speed
            sdbtmspeed(end+1) = std(dive(j).flowEst(dive(j).btm)); % sd
            mnboutdur(end+1) = mean([dive(j).clearingtime]);
        else
            allprop(end+1,1:2) = NaN; % proportion of time spent foraging
            allstart(end+1) = NaN;
            allend(end+1) = NaN;
            allbtmdur(end+1) = NaN;
            allbtmspeed(end+1) = NaN; % mean bottom speed
            sdbtmspeed(end+1) = NaN; % sd
            mnboutdur(end+1) = NaN;
        end
        if isfield(dive,'tort') == 1
            if isempty(dive(j).tort) == 0
                alltort(end+1,1:2) = dive(j).tort;
            else alltort(end+1,1:2) = NaN;
            end
        else alltort(end+1,1:2) = NaN;
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

allvols(isnan(allvols)) = 0;
allvperdive(isinf(allvperdive)) = 0;

round([mean(allvperdive(allvperdive>0)) std(allvperdive(allvperdive>0))]) % volumes per dive
[mean(allvols(allvols > 0)) std(allvols(allvols > 0))] % volume per bout
[min(allvols(allvols > 0)) max(allvols)] % volume per bout

[mean(allbouts) std(allbouts)] % bout duration
median(allpauses(allpauses > 0)) % median pause duration
allspeeds(isinf(allspeeds)) = NaN;
[nanmean(allspeeds(allvols > 0)) nanstd(allspeeds(allvols > 0))] % speed during bout

[min(allbperdive) max(allbperdive) mean(allbperdive) std(allbperdive)] % bouts per dive

[mean(alldepth(allvperdive > 1)) std(alldepth(allvperdive > 1))] % depth 
[mean(alldepth(allvperdive < 1)) std(alldepth(allvperdive < 1))]

%%
gapes = [];
for i = 1:length(tagid2)
    ID = tagid2(i);
    switch ID
        case 5
            [gape,~,~,~,lnth] = getgape(tags{ID,6}, 1190);
        case 9
            [gape,~,~,~,lnth] = getgape(tags{ID,6}, 1210);
        case 7
            [gape,~,~,~,lnth] = getgape(tags{ID,6}, 1250);
        case 8
            [gape,~,~,~,lnth] = getgape(tags{ID,6}, 1250);
        otherwise
            [gape,~,~,~,lnth] = getgape(tags{ID,6});
    end
    gapes(:,i) = gape/100;
    lnths(:,i) = lnth/100;
end
figure(9), clf, hold on
jit = rand(size(gapes));
for i = 1:length(allbtmspeed)
    h = plot3([allbtmspeed(i)-sdbtmspeed(i) allbtmspeed(i)+sdbtmspeed(i)],[gapes(i)+jit(i)/20 gapes(i)+jit(i)/20],[(allprop(i,2)-allprop(i,1)).*alldur(i) (allprop(i,2)-allprop(i,1)).*alldur(i)],'color',[0.5 0.5 0.5]);
    alpha(h,0.5)
end
scatter3(allbtmspeed,gapes+jit/20,(allprop(:,2)-allprop(:,1)).*alldur,60,allvperdive,'filled','markeredgecolor','k')
h = scatter(allbtmspeed,gapes+jit/20,'ko','markeredgealpha',0.5); % projection on bottom
h = scatter3(2+zeros(length(gapes),1),gapes+jit/20,(allprop(:,2)-allprop(:,1)).*alldur,'ko','markeredgealpha',0.5);  % projection on wall
% h = scatter3(allbtmspeed,2+zeros(length(gapes),1),(allprop(:,2)-allprop(:,1)).*alldur,'ko','markeredgealpha',0.5);  % projection on wall
xlabel('Bottom speed (m/s)')
ylabel('Gape area (m^2)')
zlabel('Bottom time (sec)')
grid on
h = colorbar;
ylabel(h,'Volume filtered (m^3)')
adjustfigurefont('Helvetica',14)
view([-55.6000   23.6000])

print('NARW_3dFiltVol.png','-dpng','-r300')

%% dive duration and time spent foraging
figure(2), clf, set(gcf,'position',[176 289 1107 384],'paperpositionmode','auto')
subplot(131),
h = scatter(alldur/60,allvperdive,50,gapes,'filled','markeredgecolor','k'); alpha(h,0.5)
xlabel('Dive duration (min)'), ylabel('Total volume filtered (m^3)'), xlim([4 20])
axletter(gca,'A')
h = colorbar('position',[0.05 0.11 0.01 0.815]);
ylabel(h,'Gape area (m^2)')

subplot(132)
h = scatter(alldur(allvperdive > 0).*(allprop(allvperdive > 0,2)-allprop(allvperdive > 0,1))/60,allvperdive(allvperdive > 0),50,gapes(allvperdive > 0),'filled','markeredgecolor','k'); alpha(h,0.5)
xlabel('Bottom duration (min)'), ylabel('Total volume filtered (m^3)'),
adjustfigurefont('Helvetica',14), xlim([0 15])
axletter(gca,'B')

subplot(133), hold on
for i = 1:length(alldepth)
    h = plot([alldepth(i) alldepth(i)],[allprop(i,1) allprop(i,2)],'k'); alpha(h,0.7)
    h = scatter(alldepth(i),allprop(i,2)-allprop(i,1),50,gapes(i),'filled','markeredgecolor','k');
end
xlabel('Depth (m)'), ylabel('Proportion of dive')
xlim([80 185])
axletter(gca,'C')
adjustfigurefont('Helvetica',14)
print('NARW_DiveProportion.png','-dpng','-r300')
%%
lm1 = fitlm(alldepth,allprop(:,1))

lm2 = fitlm(alldepth,allprop(:,2)) % all depth versus bottom proportion end

lm3 = fitlm(alldepth,allprop(:,2)-allprop(:,1)) % all depth versus bottom proportion end

% get effect sizes with: h = plotEffects(lm1)
% do predictions with [ypred,yci] = predict(lm1,82)
%%
X = [allbtmspeed' gapes' alldur.*(allprop(:,2)-allprop(:,1))];
lm_vol = fitlm(X,allvperdive)
figure
h = plotEffects(lm_vol)
% h(1).XData 
%% proportional depth figure
% figure(111), clf, hold on
% col = viridis(17); % ages 2 to 18
% for i = 1:length(allprop)
% plot(allprop(i,:),[alldepth(i) alldepth(i)],'color',col(tags{tagid2(i),6}-1,:))
% end
% ylim([95 180])
% xlabel('Proportion of dive cycle foraging'), ylabel('Maximum Dive Depth (m)')
% adjustfigurefont('Helvetica',14)
%%
% tbl = table(allvols, allbouts, allrms, allspeeds, alldur, d, tagid);
% fitlme(tbl,'allrms ~ allbouts + (1|tagid)')

%% calculate total volume per tag to get filtration rate

% figure(99), clf, hold on
% for i = 1:length(allspeeds)
% plot(allspeeds(i),tags{tagid(i),6},'o','color',c(tags{tagid(i),6},:))
% end

% nanmean(allend)

%%
mean(alldur(allvperdive > 1)) % mean dive duration in seconds
dbd_vrate = allvperdive./(alldur'/3600); % dive-by-dive filtration rate (m^3/h)
[mean(dbd_vrate(allvperdive > 1)) std(dbd_vrate(allvperdive > 1))]/3600
for i = 1:size(tags,1)
    dep_filtrate(i) = sum(allvols(tagid == i))/(gettagdur(tags{i})/3600);
end
round([min(dep_filtrate) max(dep_filtrate)])
gapes2 = []; 
for i = 1:length(allspeeds)
    ID = tagid(i);
    switch ID
        case 5
            [gape,~,~,~,lnth] = getgape(tags{ID,6}, 1190);
        case 9
            [gape,~,~,~,lnth] = getgape(tags{ID,6}, 1210);
        case 7
            [gape,~,~,~,lnth] = getgape(tags{ID,6}, 1250);
        case 8
            [gape,~,~,~,lnth] = getgape(tags{ID,6}, 1250);
        otherwise
            [gape,~,~,~,lnth] = getgape(tags{ID,6});
    end
    gape = gape/100; 
    all_hr_rate(:,i) = allspeeds(i)*gape*3600; % filtration rate of all (m3/h) at the bottom of dives
    gapes2(:,i) = gape;
end
round([nanmean(all_hr_rate) nanstd(all_hr_rate)])/3600 % in m/s

% fluke stroke rate
[nanmean(allfsr) nanstd(allfsr)]

% gape effect for discussion:
tag2_vols = allvperdive(tagid2 == 2);
tag2_vols = tag2_vols(tag2_vols > 1);
[mean(tag2_vols) std(tag2_vols)]
% SEE NARW_gapeEffect.m

% nanmean(allbtmspeed./lnths)

%% some tortuosity
[nanmean(alltort(allvperdive > 1,1)) nanstd(alltort(allvperdive > 1,1))]
max(alltort(allvperdive > 1,1))

figure(120)
plot(alltort(allvperdive > 1,1),mnboutdur(allvperdive > 1),'o')
xlabel('Tortuosity'),ylabel('Mean bout duration (sec)')
lmtort2 = fitlm(alltort(allvperdive > 1,1),mnboutdur(allvperdive > 1))

figure(121)
plot(alltort(allvperdive > 1,1),allvperdive(allvperdive > 1),'o')
xlabel('Tortuosity'),ylabel('Total volume filtered (m^3)')
lmtort1 = fitlm(alltort(allvperdive > 1,1),allvperdive(allvperdive > 1));
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
% diveid = tagid.*d;
% t = table(tagid,diveid,allbouts,allrms,allfsr,allspeeds,...
%     'VariableNames',{'tagid','diveid','meas1','meas2','meas3','meas4'});
% Meas = table([1 2 3 4]','VariableNames',{'Measurements'});
% 
% rm = fitrm(t,'meas1-meas4~tagid+diveid','WithinDesign',Meas)

%% at bottom // per dive // per deployment
figure(99)
histogram(3600*(allvperdive./allbtmdur),[0:500:10000])
xlabel('Filtration rate on bottom (m^3/h)')
adjustfigurefont('Helvetica',16)
print('NARW_Frate_bottom_pres','-dpng','-r300')

figure(98)
histogram(dbd_vrate(allvperdive > 1),[0:500:10000])
xlabel('Filtration rate per dive (m^3/h)')
adjustfigurefont('Helvetica',16)
print('NARW_Frate_dive_pres','-dpng','-r300')


figure(97)
histogram(dep_filtrate,[0:500:10000])
xlabel('Filtration rate per deployment (m^3/h)')
adjustfigurefont('Helvetica',16)
ylim([0 5]), set(gca,'ytick',[0:5])
print('NARW_Frate_dep_pres','-dpng','-r300')

%% plot by bottom, by dive, by deployment
figure(100), hold on
plot(repmat(1,length(allvperdive),1)+rand(length(allvperdive),1),3600*(allvperdive./allbtmdur),'o','linewidth',1.5) % on bottom
plot(repmat(2,length(find(allvperdive>1)),1)+rand(length(find(allvperdive>1)),1),dbd_vrate(allvperdive > 1),'o','linewidth',1.5) % per dive
plot(repmat(3,length(dep_filtrate),1)+rand(length(dep_filtrate),1),dep_filtrate,'o','linewidth',1.5) % per deployment

ylabel('Filtration rate (m^3/h)')
adjustfigurefont('Helvetica',16)

figure(101), clf, hold on, box on
scatterby(tagid2,3600*(allvperdive(allvperdive > 1)./allbtmdur(allvperdive > 1)),30,col(tagid2(find(allvperdive>1)),:));
scatterby(11+tagid2(find(allvperdive>1)),dbd_vrate(allvperdive > 1),30,col(tagid2(find(allvperdive>1)),:));
scatterby(22+[1:10],dep_filtrate,30,col(1:10,:));
ylabel('Filtration rate (m^3/h)')
set(gca,'xtick',6:10:26,'xticklabels',{'On bottom','Per dive','Per deployment'})
ylim([0 7500]), axletter(gca,'C')
adjustfigurefont('Helvetica',16)
print -dpng NARW_filtrate -r300

% extend to full day?
for i = 1:length(dep_filtrate)
    day_filtrate = dep_filtrate(i)*(24/(gettagdur(tags{i})/3600));
end

% plot speed vs gape
figure(87), clf, hold on 
for i = 1:10
scatter3(mean(gapes2(tagid == i))+rand/10,mean(allspeeds(tagid == i)),mean(allfsr(tagid == i)),'o')
end
grid on
xlabel('Gape (m^2)'), zlabel('Fluke Stroke Rate (Hz)'), ylabel('Speed (m/s)')

figure(88), clf, hold on 
for i = 1:10
scatter3(gapes2(tagid == i)+rand(1,length(find(tagid == i)))/10,allspeeds(tagid == i),allfsr(tagid == i),60,'markeredgecolor',col(tagid2(i),:))
end
