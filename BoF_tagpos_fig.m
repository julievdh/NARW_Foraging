%% get coastline data
coastdn = '/Users/julievanderhoop/Documents/MATLAB/UGthesis/Coastline_Data/';
% coastdn = '/Users/angeliavanderlaan/Documents/Dalhousie/PhD_DATA/Coastline_data/';
% coastdn = 'G:\Dalhousie\PhD_DATA\Coastline_data\';
coastfn = 'Fishing_Fill.dat';
% coastfn = 'VACATE_coast.dat';
bathy100m = 'Bathy_100m_contour.dat';
bathy200m = 'Bathy_200m_contour.dat';
load([coastdn coastfn])
load([coastdn bathy100m])
load([coastdn bathy200m])

figure(11),clf
map = Fishing_Fill;
% map = VACATE_coast;
new=join_cst(map,.0001);
%%
gsize =0.25;
% lats = 45.5:0.05:51;
lats = 43.5:gsize:45;
lats = lats';
% longs =-57:-0.05:-66;
longs =-65:-gsize:-66.5;
longs = longs';
elong = longs + -gsize;
elat = lats + gsize;


latlim = [min(lats) max(elat)];
lonlim = [min(longs) max(elong)];

maxlat = max(latlim);
minlat = min(latlim);

sf_long = 1/(cos(((maxlat + minlat)/2)*(pi/180)));
latdeg = maxlat - minlat;
longdeg = sf_long*latdeg;
maxlong = -66+longdeg/2;
minlong  = -66-longdeg/2;

%xtcklocs = [-66.4:0.2:-64.4];
%ytcklocs = [42.4:.2:44];

%xtcklabs =['66.4';'66.2';'66.0';'65.8';'65.6';'65.4';'65.2';'65.0';'64.8';'64.6';'64.4'];
%ytcklabs =['42.4';'42.6';'42.8';'43.0';'43.2';'43.4';'43.6';'43.8'; '44.0'];


%scbar_10 = [-66.4 42.425; -66.2783 42.425];
%scbar_50 = [-66.4 42.425; -65.79152 42.425];
%scbar_25 = [-66.4 42.425; -66.095755 42.425];

%%

figure(1),
set(gcf, 'Position',[100 100 800 800])
set(gcf, 'color', 'white');
hold on
fillseg(new,[0.50196     0.50196     0.50196],[0 0 0]);


H1 =plot(Bathy_100m_contour(:,1),Bathy_100m_contour(:,2))
H2= plot(Bathy_200m_contour(:,1),Bathy_200m_contour(:,2))
set(H2, 'color', [0.31373     0.31765     0.31373])
set(H1, 'color', [0.31373     0.31765     0.31373])
% text(-66.325,42.46,'25 km','fontsize',12, 'fontweight','bold', 'backgroundcolor', 'w')
% plot(scbar_25(:,1), scbar_25(:,2), 'k-', 'linewidth', 5)

axis([minlong maxlong minlat maxlat])


%set(gca, 'xdir', 'reverse')
set(gca, 'tickdir','out')


set(gca, 'tickdir','out')
set(gca, 'ydir', 'normal')
%set(gca, 'xtick', xtcklocs, 'xticklabel', xtcklabs)
%set(gca, 'ytick', ytcklocs, 'yticklabel', ytcklabs)
xlabel('^oW Longitude ','fontsize',14)
ylabel('^oN Latitude ','fontsize',14)
set(gca,'fontsize',12)
% text(-66.4,43.95,'(a)','fontsize',14)
axis square
box on

%% tagon
tagonlat = [44.87666667
    44.61
    0
    44.72833333
    44.68833333
    0
    0
    0
    44.65016667
    0
    0
    0
    44.70441667
    0
    44.68716667
    44.619
    0
    0
    44.563
    44.64383333
    44.62416667
    0
    0
    0
    44.57725
    44.66788333
    44.6845
    0
    0
    0
    44.66816667
    0
    0
    0
    44.60866667
    44.61296667
    0
    44.64311667
    44.67946667
    44.66195
    44.6167
    44.68151667
    44.60256667
    44.6846
    44.68851667
    44.61993333
    44.6532
    44.65875
    44.61643333
    44.63265
    44.63875
    0
    44.926
    44.56783333
    44.57
    44.57766667
    44.62716667
    0
    44.5875
    0
    44.61333333
    44.61766667
    44.58333333
    44.57116667
    0
    0
    44.55933333
    44.59033333
    44.62916667
    44.66966667
    44.65783333
    44.6215
    44.60116667
    44.65133333
    0
    44.653
    44.69283333];

tagonlon = [66.43333333
    66.50333333
    0
    66.57333333
    66.56833333
    0
    0
    0
    66.381
    0
    0
    0
    66.52941667
    0
    66.46483333
    66.498
    0
    0
    66.51966667
    66.3485
    66.39583333
    0
    0
    0
    66.44796667
    66.39218333
    66.3486
    0
    0
    0
    66.42383333
    0
    0
    0
    66.52316667
    66.50198333
    0
    66.46508333
    66.3989
    66.43566667
    66.43866667
    66.36926667
    66.4604
    66.43555
    66.48088333
    66.54103333
    66.49936667
    66.56058333
    66.46355
    66.47806667
    66.481
    0
    66.50216667
    66.50083333
    66.50116667
    66.49733333
    66.47783333
    0
    66.5025
    0
    66.44033333
    66.41183333
    66.463
    66.3935
    0
    0
    66.50833333
    66.54083333
    66.51
    66.49483333
    66.42783333
    66.47083333
    66.48983333
    66.435
    0
    66.48266667
    66.39233333];

tagonlat(tagonlat == 0) = NaN; % replace zeros with NaN
tagonlon(tagonlon == 0) = NaN;
%% plot
plot(-tagonlon,tagonlat,'ko')

CH = [-66.45 44.81666667;
    -66.28333333 44.78333333;
    -66.28333333 44.66666667;
    -66.36666667 44.55;
    -66.5 44.48333333;
    -66.61666667 44.48333333;
    -66.61666667 44.7;
    -66.45 44.81666667];

plot(CH(:,1),CH(:,2),'r','linewidth',1.5)

print -dpng NARW_BoF_tagpos -r300

%% tag duration 

tdur = [2.516666667
4.283333333
0.716666667
6.283333333
5
8.75
0
41.71666667
20.33583333
3.671111111
0.015277778
1.64
1.203888889
1.924722222
0
0
5.5
0
0
0
0.544444444
0.066666667
2.433333333
1.599722222
0.25
0.195833333
1.383333333
0.756944444
1.7175
0
0
0.138055556
1.193611111
0.666666667
0.436388889
0.128333333
0
0
2.766666667
0
0.083333333
0.116666667
1.633333333
5.283333333
0.183333333
0.816666667
0.166666667
1.233333333
0.407222222
7.9
1.233333333
4.35
1.033333333
4.293888889
1.894722222
0.664166667
0.500277778
0.180555556
3.422777778
0
0.75
10.80638889
2.889444444
5.711666667
0.333333333
0
36
1.2
0.633333333
0.55
8
11.54611111
0
0
8.616666667
2.351666667
9
3.1025
6.340555556
0.218333333
5.383333333
5.4
0
0.8
1.132222222]; 

tdur(tdur == 0) = NaN; 
tdur(tdur > 24) = 24; 
figure(2)
histogram(tdur,[0:0.5:24])
xlabel('Recording duration (h)')
adjustfigurefont('Helvetica',18)
xlim([0 24])
set(gca,'xtick',[0 4 8 12 20 24],'xticklabels',{'0','4','8','12','20','>24'})

print -dpng NARW_BoF_tagdur -r300