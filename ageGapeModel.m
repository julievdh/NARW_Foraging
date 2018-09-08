% NARW mouth gape model test
for whaleAge = 1:20; 

lnth(whaleAge) = 1011.033+320.501*log10(whaleAge); % MOORE ET AL 2004
lnth(whaleAge) = lnth(whaleAge)./100;

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
%Best and Shell 1996, table 1
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

ft = fitlm(allBlength,allPlength); % fit the model 

print('NPRW_SRW_baleenlength','-dpng','-r300')

%% apply the model for body lengths 

for whaleAge = 1:20; 

lnth(whaleAge) = 1011.033+320.501*log10(whaleAge); % MOORE ET AL 2004
lnth(whaleAge) = lnth(whaleAge)/100;

end
% estimate baleen length
Blength = feval(ft,lnth);

% estimate gape with length and width 
A2 = (snt.*Blength)./2;

%% for plotting multiple axes 
figure(22), clf
test = 1011.033+320.501*log10(0.1:2:20); % vector of estimated lengths 
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

plot(h1,1:20,A2,'color',[123/255 50/255 148/255])
% plot(h1,A,'--','color',[123/255 50/255 148/255])
plot(h1,1:20,snt,'color',[0    0.4470    0.7410])
plot(h1,1:20,Blength,'color',[ 0.9290    0.6940    0.1250])

plot(h1,[1/12 3.5/12 1],[0.68 1.01 snt(1)],'-','color',[0    0.4470    0.7410]) % width data for calves from Carolyn Miller

plot(h1,[1/12 3/12 1],[(0.68.^2)./2 (1.01.^2)./2 A2(1)],'-','color',[123/255 50/255 148/255]) % area for calves 

% add size of whales in our study 
age = [2     3     4     8    19]; % unique([tags{:,6}])
for n = 1:length(age)
gapes(n) = getgape(age(n));     
end
plot(h1,age,gapes,'o','color',[123/255 50/255 148/255])


adjustfigurefont
print('NARW_gape_length2','-dsvg','-r300')

