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
    
    for j = 31 % DO THIS FOR ALL TAGS too
        
        figure(18), clf
        hold on
        for k = [1:3 7:size(dive(j).stops,1)-1]
            x = ((dive(j).stops(k,1)*fs:dive(j).stops(k+1,2)*fs)-dive(j).stops(k,2)*fs)/fs;
            subplot(411), hold on, box on
            plot(x,rad2deg(ph(dive(j).stops(k,1)*fs:dive(j).stops(k+1,2)*fs)))
            xlim([-60 60])
            subplot(412), hold on, box on
            plot(x,rad2deg(roll(dive(j).stops(k,1)*fs:dive(j).stops(k+1,2)*fs)))
            xlim([-60 60])
            subplot(413), hold on, box on
            plot(x,rad2deg(head(dive(j).stops(k,1)*fs:dive(j).stops(k+1,2)*fs)))
            xlim([-60 60])
            subplot(414), hold on, box on
            plot(x,-p(dive(j).stops(k,1)*fs:dive(j).stops(k+1,2)*fs))
            xlim([-60 60])
        end
        subplot(411), % title(regexprep(tag,'_','  '));
        ylabel('Pitch (deg)')
        subplot(412), ylabel('Roll (deg)')
        subplot(413), ylabel('Heading (deg)')
        subplot(414), ylabel('Depth'), xlabel('Time (s)')
        adjustfigurefont('Helvetica',14)
        
        print(['NARW_stop_prhd_dive' num2str(j) '_' tag '.png'],'-dpng','-r90')
        
    end
end
