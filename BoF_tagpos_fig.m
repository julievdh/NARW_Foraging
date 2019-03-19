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

figure(1), clf
set(gcf, 'Position',[100 100 800 800])
set(gcf, 'color', 'white');
hold on
fillseg(new,[0.50196     0.50196     0.50196],[0 0 0]);


H1 =plot(Bathy_100m_contour(:,1),Bathy_100m_contour(:,2))
H2= plot(Bathy_200m_contour(:,1),Bathy_200m_contour(:,2))
set(H2, 'color', [0.5     0.7     0.1])
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
tagonlat = [44.65783333
44.62916667
44.55933333
44.57116667
44.5875
44.56783333
44.6532
44.68151667
44.62416667
44.68716667];

tagonlon = [66.42783333
66.51
66.50833333
66.3935
66.5025
66.50083333
66.49936667
66.36926667
66.39583333
66.46483333];

% add tag off for tags where have data
tagofflat = [44.55668333
44.57363333
44.61615
44.649
0
44.56026667];

tagofflon = [66.46508333
66.52308333
66.43483333
66.4395
0
66.51348333];

tagofflon(tagofflon == 0) = NaN;
tagofflat(tagofflat == 0) = NaN; % replace zeros with NaN

%% plot
plot(-tagonlon,tagonlat,'ko')
plot(-tagofflon,tagofflat,'ro')

CH = [-66.45 44.81666667;
    -66.28333333 44.78333333;
    -66.28333333 44.66666667;
    -66.36666667 44.55;
    -66.5 44.48333333;
    -66.61666667 44.48333333;
    -66.61666667 44.7;
    -66.45 44.81666667];

plot(CH(:,1),CH(:,2),'r','linewidth',1.5)

% print -dpng NARW_BoF_tagpos -r300

return 
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