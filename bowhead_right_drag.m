% bowhead vs narw drag

% drag = 1/2 rho A Cd U^2 
% drag coefficient from van der Hoop, McGregor, fairly average 
Cd = 0.01; 
% seawater density
rho = 1025;
U = 0.5:0.1:3; % speeds
% drag augmentation factor for oscillation, = 1-3 as per Frank Fish, pers comm
k = 1.5;
% appendages
g = 1.3;

%%
bowhead_drag = 0.5*rho*4.23*Cd*U.^2*g*k; 
right_drag1 = 0.5*rho*1*Cd*U.^2*g*k; 
right_drag2 = 0.5*rho*2*Cd*U.^2*g*k; 
% data_drag = 0.5*rho.*gapes*Cd.*allspeeds'*g*k; 

figure(1), clf
hold on 
plot(U.^2,bowhead_drag,'LineWidth',2)
plot(U.^2,right_drag1,'LineWidth',2)
plot(U.^2,right_drag2,'LineWidth',2)

xlabel('Swimming Speed^2 (m/s)'), ylabel('Drag (N)'), adjustfigurefont('helvetica',14)
legend('Bowhead, 4.2 m^2 gape', 'Right, 1m^2 gape', 'Right, 2m^2 gape','location','NW')

% Potvin Mouth Friction Drag (N) [U^2 vs N]
MouthFriction = [1.0238559	84.90758
2.2950184	234.156
4.025251	447.49136
15.994707	1682.0536
0.98922634	257.6173
2.2959318	471.56204
3.991452	836.0248
9.007175	1864.7675
15.930597	3365.5798
0.9895585	343.94678
2.2971776	795.2976
3.993362	1332.4193
16.008991	5394.221];
plot(MouthFriction(:,1),MouthFriction(:,2),'o')
% fit a relationship to this for smoother plotting

% get sizes and reorder for plotting 

figure(2), clf, hold on 
plot(U,4.2*U,'--','LineWidth',2)
plot(U,1*U,'--','LineWidth',2)
plot(U,2*U,'--','LineWidth',2)
xlabel('Swimming Speed (m/s)'), ylabel('Filtration Rate (m^3/s)'), adjustfigurefont('helvetica',14)
legend('Bowhead, 4.2 m^2 gape', 'Right, 1m^2 gape', 'Right, 2m^2 gape','location','NW')


figure(3), clf
h1 = axes('Color','w','XColor','k','YColor','k',...
          'YLim',[0 4000],'Xlim',[0.5 max(U)],'NextPlot','add');
h2 = axes('Color','none','XColor','k','YColor','k',...
          'YLim',[0 14],'Xlim',[0.5 max(U)],...
          'Yaxislocation','right','ytick',[0 3 6 9 12],...
          'Xaxislocation','top','xtick',[],'NextPlot','add');

xlabel(h1,'Swimming Speed (m/s)');
ylabel(h1,'Mouth Friction Drag (N)');
ylabel(h2,'Filtation Rate (m^3/s)');

plot(h1,sqrt(MouthFriction(1:4,1)),MouthFriction(1:4,2),'Linewidth',2)
plot(h1,sqrt(MouthFriction(5:9,1)),MouthFriction(5:9,2),'Linewidth',2)
plot(h1,sqrt(MouthFriction(10:13,1)),MouthFriction(10:13,2),'Linewidth',2)

bowhead_frate = 4.2*U; % filtration rates of bowhead and rights based on area and swimming speed
right_frate1 = 1*U; 
right_frate2 = 2*U; 

plot(h2,U,bowhead_frate,'--','LineWidth',2)
plot(h2,U,right_frate1,'--','LineWidth',2)
plot(h2,U,right_frate2,'--','LineWidth',2)
legend('Bowhead, 4.2 m^2 gape', 'Right, 1m^2 gape', 'Right, 2m^2 gape','location','NW')

adjustfigurefont('Helvetica',14), print('bowhead_right_drag','-dpng')

% values for paper

% right whale with 1m2 gape filters 3 m^3/s at 3 m/s, drag is X amount more
% than bowhead filtering that speed 
right_drag1(end)/bowhead_drag(3);
right_drag2(find(U==1.5))/bowhead_drag(3);


% plot(h1,allspeeds,data_drag,'o')
% plot(h2,allspeeds,all_hr_rate/3600,'^')
return 

%% sharks
whaleshark_drag = 0.5*rho*0.1*Cd*U.^2*g*k; 
basking_drag = 0.5*rho*0.4*Cd*U.^2*g*k;

% figure(3), clf
% h1 = axes('Color','w','XColor','k','YColor','k',...
%           'YLim',[0 450],'Xlim',[0.5 max(U)],'NextPlot','add');
% h2 = axes('Color','none','XColor','k','YColor','k',...
%           'YLim',[0 14],'Xlim',[0.5 max(U)],...
%           'Yaxislocation','right','ytick',[0 3 6 9 12],...
%           'Xaxislocation','top','xtick',[],'NextPlot','add');

% xlabel(h1,'Swimming Speed (m/s)');
% ylabel(h1,'Drag (N); Frontal Area Reference');
% ylabel(h2,'Filtation Rate (m^3/s)');

plot(h1,U,whaleshark_drag,'Linewidth',2)
plot(h1,U,basking_drag,'Linewidth',2)

whaleshark_frate = 0.1*U; % filtration rates of bowhead and rights based on area and swimming speed
basking_frate = 0.4*U; 

plot(h2,U,whaleshark_frate,'--','LineWidth',2)
plot(h2,U,basking_frate,'--','LineWidth',2)
legend('Whale Shark', 'Basking Shark','location','NW')
