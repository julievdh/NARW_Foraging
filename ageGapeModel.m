% NARW mouth gape model test
for whaleAge = 1:20;
    [whaleLength,ci] = MooreAgeLength(whaleAge); % MOORE ET AL 2004
    whaleLength = whaleLength/100; ci = ci/100; 

    lnth(whaleAge) = whaleLength; 
    ci_length(whaleAge,1:2) = ci; 
    
    [width,stations] = bodywidth(lnth(whaleAge)); % this is mesomorphic but I don't really like it for going across age stages.
    figure(19), hold on
    plot(stations, width)
    
    snt(whaleAge) = width(1)*2; % fix this relationship but you get the idea
    
end

figure(20), clf, hold on,
plot(snt)
A = (snt.^2)./2;
plot(A)

plot(1/12,0.68,'o','color',[0    0.4470    0.7410]) % width data for calves from Carolyn Miller
plot(3.5/12,1.01,'o','color',[0    0.4470    0.7410]) % width data for calves from Carolyn Miller

plot(1/12,(0.68.^2)./2,'o','color',[    0.8500    0.3250    0.0980]) % area for calves
plot(3.5/12,(1.01.^2)./2,'o','color',[    0.8500    0.3250    0.0980]) % are for calves

xlabel('Age (years)'), ylabel({'Head Width (m)'; 'Gape Area (m^2)'})
adjustfigurefont

print('NARW_gape_length','-dpng','-r300')

%% adding  baleen length
% Best and Shell 1996, table 1
bodylength = [13.1 10.06 14.3 9.25 4.6 13.76 14.8 10.31 11.76 11.23 10.66];
platelength = [1.75 1.025 1.90 1.05 .12 2.375 2.025 1.125 .98 .82 1.36]; % (m)

% Omura (1958), Klumov (1962), Matthews (1938) as reported in Omura 1969
Antarctic = [6.4664073	0.1593402; 13.501248	1.8153068; 14.4106	1.9719481];
NPRW = [10.777474	0.39463958
    11.657088	0.89067054
    12.418416	1.9719481
    12.612979	0.98490834
    14.112836	2.0025098
    14.711208	2.0512502
    15.111184	1.8767136
    15.203412	2.0911121
    15.426739	2.1613517
    16.039192	2.3819911
    16.154743	2.3812551
    16.309784	2.0458448
    16.621752	2.1919591
    16.622633	2.5980382
    16.416725	2.8286684
    17.025084	2.519035
    17.084837	2.595094
    17.115084	2.6474535
    17.441118	2.5928245
    17.820353	2.3610904
    18.331057	1.9995272];

figure(21), clf, hold on
plot(bodylength,platelength,'v','linewidth',1)
plot(NPRW(:,1),NPRW(:,2),'^','linewidth',1)
plot(Antarctic(:,1),Antarctic(:,2),'o','linewidth',1)

xlabel('Body length (m)')
ylabel('Length of longest baleen plate (m)')
adjustfigurefont

allBlength = vertcat(bodylength',NPRW(:,1),Antarctic(:,1));
allPlength = vertcat(platelength',NPRW(:,2),Antarctic(:,2));

ft = fit(allBlength,allPlength,'poly1'); % fit the model

%% apply the model for body lengths

% estimate baleen length
Blength = feval(ft,lnth);
ci_Blength = predint(ft,lnth,0.95,'functional','off'); % for figure
AllLength = feval(ft,[min(bodylength) max(NPRW(:,1))]);

% plot the fit on the figure -- ADD ERROR? plot_ci
ci_baleen = predint(ft,[min(bodylength) max(NPRW(:,1))],0.95,'functional','off');
H = plot_ci([min(bodylength) max(NPRW(:,1))],ci_baleen,'patchcolor',[0 0 0],'patchalpha',0.25,'linecolor','w');

plot([min(bodylength) max(NPRW(:,1))],AllLength,'color',[.6 .6 .6])
plot(lnth,Blength,'k')

% get equation from ft.Coefficients and add text

print('NPRW_SRW_baleenlength','-dpng','-r300')


%% for plotting multiple axes
figure(22), clf
axesPosition = [110 40 200 200];  %# Axes position, in pixels
yWidth = 30;                      %# y axes spacing, in pixels

h1 = axes('Color','w','XColor','k','YColor',[123/255 50/255 148/255],...
    'YLim',[0 2.2],'Xlim',[0 20],'NextPlot','add');
h2 = axes('Color','none','XColor','k','YColor','k',...
    'YLim',[0 2.2],'Xlim',[0 20],...
    'Xtick',0.1:2:20,'xticklabels',round(test/100,1),...
    'Yaxislocation','right',...
    'Xaxislocation','top','NextPlot','add');

xlabel(h1,'Age (years)');
ylabel(h2,'Head Width (m), Baleen Length (m)');
ylabel(h1,'Gape Area (m^2)');
xlabel(h2,'Body Length (m)');

% plot baleen lengths and CI
plot(h1,1:20,Blength,'color',[ 0.9290    0.6940    0.1250])
plot(h1,1:20,ci_Blength,'k:','color',[ 0.9290    0.6940    0.1250])

% add size of whales in our study
age = [2     3     4     8    19]; % unique([tags{:,6}])
for n = 1:length(age)
    [gapes(n), ci_gapes(n)] = getgape(age(n));
end
for whaleAge = 1:20
    [all_gapes(whaleAge),all_ci_gapes(whaleAge),all_widths(whaleAge),all_ci_widths(whaleAge,1:2)] = getgape(whaleAge); 
end
% plot widths and CI
plot(h2,1:20,all_widths/100,'color',[0    0.4470    0.7410])
plot(h2,1:20,all_ci_widths/100,':','color',[0    0.4470    0.7410])
plot(h1,[1/12 3.5/12 1],[0.68 1.01 all_widths(1)/100],'-','color',[0    0.4470    0.7410]) % width data for calves from Carolyn Miller

% plot gapes and CI
plot(h1,[1/12 3/12 1],[(0.68.^2)./2 (1.01.^2)./2 all_gapes(1)/100],'-','color',[123/255 50/255 148/255]) % area for calves
plot(h1,1:20,all_gapes/100,'color',[123/255 50/255 148/255])        
plot(h1,1:20,all_gapes/100-all_ci_gapes/100,':','color',[123/255 50/255 148/255])
plot(h1,1:20,all_gapes/100+all_ci_gapes/100,':','color',[123/255 50/255 148/255])
plot(h1,age,gapes/100,'o','color',[123/255 50/255 148/255],'markerfacecolor',[123/255 50/255 148/255])

adjustfigurefont
print('NARW_gape_length2','-dsvg','-r300')

return 
%% add mouth size to calculate baleen filter area

mouthlength = [2	235; 0	140; 3	197;
    2	230; 0	69; 12	300; 2	299;
    2.5	200; 3	235; 0	90; 12	337;
    0	101; 4	250; 0	77; 2	278;
    28	309; 10	320; 0	128; 1	165;
    1	245; 12	361; 30	360; 15	280;
    12	373; 9	315; 0	13; 1	98;
    1	187.9; 2 	238; 0	85; 1	161;
    0	109; 0	115; 2	210; 2	220; 1	206];

bodylen = [1030; 760; 1100; 1090; 412; 1360;
    1155; 1030; 1266; 478; 1415; 513; 1270; 417; 1259; 1370;
    1350; 771; 910; 1100; 1370; 1600; 1490; 1380; 1470; 600
    560; 658; 1260; 401; 772; 470; 495; 975; 1000; 885];

figure(18), clf, hold on
plot(allBlength,allPlength*100,'o')
plot(bodylen/100,mouthlength(:,2),'o')
xlabel('Body Length (m)')

ft2 = fit(bodylen/100,mouthlength(:,2),'poly1'); % fit the model
Mlength = feval(ft2,lnth);

plot(lnth,Blength*100,'k')
plot(lnth,Mlength,'k')
H = plot_ci([min(bodylength) max(NPRW(:,1))],ci_baleen*100,'patchcolor',[0 0 0],'patchalpha',0.25,'linecolor','w');
ci2 = predint(ft2,[min(bodylength) max(NPRW(:,1))]);
H2 = plot_ci([min(bodylength) max(NPRW(:,1))],ci2,'patchcolor',[0 0 0],'patchalpha',0.25,'linecolor','w');
