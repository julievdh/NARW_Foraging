% Functional Ecology Revision Calculations

%% How much volume is 9 million copepods?
% one copepod = 2 - 4 mm^3
cop_vol_low = 9E6*2;
cop_vol_high = 9E6*4;
% convert mm^3 to m^3
cop_vol_low*1E-9
cop_vol_high*1E-9

%% What makes the biggest difference?

gape = 1:0.1:2.0;
speed = 1.1;
frate = gape*speed;
figure(1), clf, hold on
plot(gape,frate)

speed = 0.6:0.1:1.6;
gape = 1.2;
frate = gape*speed;
plot(speed,frate)
plot([0.6 2],[0.6 2],'k') % 1:1 line
xlabel('Speed')

figure(2)
gape = 0.9:0.1:1.9;
speed = 0.7:0.1:1.5;
frate = gape'*speed;
mesh(speed,gape,frate)
xlabel('Speed (m/s)'), ylabel('Gape (m^2)'), zlabel('Filtration Rate (m^3/s)')


%% baleen length/area/plates
baleencount = [2.00	NaN 185
    0       NaN	213
    3.00	220	212
    0.00	205	207
    2.00	220	247
    0.00	238	235
    0.00	NaN	225
    2.00	217	225
    28.00	212	210
    10.00	159	163
    0.00	190	NaN];

mouthlength = [2	235
    0	140
    3	197
    2	230
    0	69
    12	300
    2	299
    2.5	200
    3	235
    0	90
    12	337
    0	101
    4	250
    0	77
    2	278
    28	309
    10	320
    0	128
    1	165
    1	245
    12	361
    30	360
    15	280
    12	373
    9	315
    0	13
    1	98
    1	187.9
    2 	238
    0	85
    1	161
    0	109
    0	115
    2	210
    2	220
    1	206];

bodylen = [1030
    760
    1100
    1090
    412
    1360
    1155
    1030
    1266
    478
    1415
    513
    1270
    417
    1259
    1370
    1350
    771
    910
    1100
    1370
    1600
    1490
    1380
    1470
    600
    560
    658
    1260
    401
    772
    470
    495
    975
    1000
    885];

ageGapeModel

% plot(bodylen,mouthlength(:,2),'o')
% fit relationship between body length and mouth length
ft2 = fitlm(bodylen/100,mouthlength(:,2)); % fit the model
Mlength = feval(ft2,lnth);

figure, hold on
plot(allBlength,allPlength*100,'o')
plot(bodylen/100,mouthlength(:,2),'o')
xlabel('Body Length (m)')
plot(lnth,Blength*100,'k')
plot(lnth,Mlength,'k')

BFA = Blength*100.*Mlength;
H = plot_ci([min(bodylength) max(NPRW(:,1))],ci*100,'patchcolor',[0 0 0],'patchalpha',0.25,'linecolor','w');

%% check for roll/heading changes when pitch changes
PRHplotNARWcheck

%% Plot v-shaped and foraging dive side by side

load('NARW_foraging_tags')
ID = 8;
tag = tags{ID};
loadprh(tag,'p','fs','Aw','Mw','pitch');
pdeg = rad2deg(pitch);

t = (1:length(p))/fs;
% import flow speed -- updated 25 Sept 2018
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
T = finddives(p,fs,50,1);

figure(3), clf
for i = [4, 10];
    dcue = T(i,1)-50:T(i,2)+50;
    subplot(121), hold on % depth
    plot([0 0],[-140 10],'--','color',[0.5 0.5 0.5])
    plot([T(i,2)-T(i,1) T(i,2)-T(i,1)],[-140 10],'--','color',[0.5 0.5 0.5])
    plot(dcue-T(i,1),-p(round(dcue*fs)),'LineWidth',1.5)
    ylim([-140 10]), xlim([-50 811])
    xlabel('Time (s)'), set(gca,'xtick',0:120:900)
    ylabel('Depth (m)'), box on
    
    subplot(122), hold on % pitch
    plot([0 0],[-80 80],'--','color',[0.5 0.5 0.5])
    plot([T(i,2)-T(i,1) T(i,2)-T(i,1)],[-80 80],'--','color',[0.5 0.5 0.5])
    plot(dcue-T(i,1),pdeg(round(dcue*fs)),'LineWidth',1.5)
    ylim([-80 80]), xlim([-50 811])
    xlabel('Time (s)'), set(gca,'xtick',0:120:900)
    ylabel('Pitch (degrees)'), box on
end

adjustfigurefont('Helvetica',14)
set(gcf,'paperpositionmode','auto')
print('NARW_DiveCompare','-dpng','-r300')

%% heading/pitch/depth

warning off

load('NARW_foraging_tags')
for ID = 1;
    tag = tags{ID};
    loadprh(tag);
    load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
    [~,ph,~,~] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]); % calculate pitch deviation
    
    for j = 31
        
        figure(18), clf, hold on
        set(gcf,'position',[841   181   512   492],'paperpositionmode','auto')
        
        allhd = nan(size(dive(j).stops,1)-1,3);
        allrl = nan(size(dive(j).stops,1)-1,3); 
        alldpth = nan(size(dive(j).stops,1)-1,3);
        
        for k = [1:3 6:size(dive(j).stops,1)-1]
            x = ((dive(j).stops(k,1)*fs:dive(j).stops(k+1,2)*fs)-dive(j).stops(k,2)*fs)/fs;
            % all changes in heading, roll and depth
            allhd(k,:) = rad2deg([head(round((dive(j).stops(k,2)-20)*fs)) head(round((dive(j).stops(k,2))*fs)) head(round((dive(j).stops(k,2)+20)*fs))]);
            allrl(k,:) = rad2deg([roll(round((dive(j).stops(k,2)-20)*fs)) roll(round((dive(j).stops(k,2))*fs)) roll(round((dive(j).stops(k,2)+20)*fs))]);
            alldpth(k,:) = [-p(round((dive(j).stops(k,2)-20)*fs)) -p(round((dive(j).stops(k,2))*fs)) -p(round((dive(j).stops(k,2)+20)*fs))];


            
            
            s1 = subplot(411); hold on, box on, grid on
            plot(x,rad2deg(ph(dive(j).stops(k,1)*fs:dive(j).stops(k+1,2)*fs))-rad2deg(ph(round(dive(j).stops(k,2)*fs))))
            xlim([-60 60])
            s2 = subplot(412); hold on, box on, grid on
            plot(x,rad2deg(roll(dive(j).stops(k,1)*fs:dive(j).stops(k+1,2)*fs))-rad2deg(roll(round(dive(j).stops(k,2)*fs))))
            xlim([-60 60])
            s3 = subplot(413); hold on, box on, grid on
            plot(x,rad2deg(head(dive(j).stops(k,1)*fs:dive(j).stops(k+1,2)*fs))-rad2deg(head(round(dive(j).stops(k,2)*fs))))
            xlim([-60 60])
            s4 = subplot(414); hold on, box on, grid on
            plot(x,-p(dive(j).stops(k,1)*fs:dive(j).stops(k+1,2)*fs)+p(round(dive(j).stops(k,2)*fs)))
            xlim([-60 60])
        end
        subplot(411), % title(regexprep(tag,'_','  '));
        Del = texlabel(Delta); 
        s1.YLabel.Position(1) = -69.8182; 
        s2.YLabel.Position(1) = -69.8182; 
        s3.YLabel.Position(1) = -69.8182; 
        s4.YLabel.Position(1) = -69.8182; 
        ylabel([test 'Pitch (deg)'])
        subplot(412), ylabel([test 'Roll (deg)'])
        subplot(413), ylabel([test 'Heading (deg)'])
        subplot(414), ylabel([test 'Depth (m)']), xlabel('Time (s)')
        adjustfigurefont('Helvetica',12)
        
        print(['NARW_stop_prhd_dive' num2str(j) '_' tag '.png'],'-dpng','-r90')
        
    end
end

figure(19), clf
subplot(131)
plot([allrl(:,1)-allrl(:,2) allrl(:,3)-allrl(:,2)]','o-')
xlim([0 3])
subplot(132)
plot([allhd(:,1)-allhd(:,2) allhd(:,3)-allhd(:,2)]','o-')
xlim([0 3])
subplot(133)
plot([alldpth(:,1)-alldpth(:,2) alldpth(:,3)-alldpth(:,2)]','o-')
xlim([0 3])

%% visualise with plotter
F = plot_3d_model;
divetest = [ph(dive(j).stops(1,1)*fs:dive(j).stops(end,2)*fs) roll(dive(j).stops(1,1)*fs:dive(j).stops(end,2)*fs) head(dive(j).stops(1,1)*fs:dive(j).stops(end,2)*fs)];
rot_3d_model(F,divetest) ;

%% 
1.5*1.2*600
1.0*1.8*600

%% what are min/mean/max vertical speeds measured? 
load('NARW_foraging_tags') % let's make this more straightforward

for ID = 1:10
tag = tags{ID};
loadprh(tag,'p','fs','Aw','Mw','pitch');

t = (1:length(p))/fs;
pdeg = rad2deg(pitch);
warning off

% find dives
T = finddives(p,fs,50,1);
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
d2after = tags{ID,9};

th = 30; 
selspeed = []; selFN = [];
for i = d2after'
    ii = find(abs(medpitch(i,:)) > th);
    % ii = find(medpitch(i,:) < -th); 
    selspeed = horzcat(selspeed,abs(spd(i,ii)));
    selFN = horzcat(selFN,medFN(i,ii));
    selFN(isnan(selspeed)) = [];
    selspeed(isnan(selspeed)) = [];
end
maxselspeed(ID) = max(selspeed); 
meanselspeed(ID) = mean(selspeed);
minselspeed(ID) = min(selspeed); 
end

mean(maxselspeed)
mean(minselspeed)
    