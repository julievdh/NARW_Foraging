% bowhead vs narw drag

% drag = 1/2 rho A Cd U^2 
% drag coefficient from van der Hoop, McGregor, fairly average 
Cd = 0.01; 
% seawater density
rho = 1025;
U = 0.5:0.1:2.5; % speeds
% drag augmentation factor for oscillation, = 3 as per Frank Fish, pers comm
k = 1.5;
% appendages
g = 1.3;


bowhead_drag = 0.5*rho*4.23*Cd*U.^2*g*k; 
right_drag1 = 0.5*rho*1*Cd*U.^2*g*k; 
right_drag2 = 0.5*rho*2*Cd*U.^2*g*k; 

figure(1), clf
hold on 
plot(U,bowhead_drag,'LineWidth',2)
plot(U,right_drag1,'LineWidth',2)
plot(U,right_drag2,'LineWidth',2)

xlabel('Swimming Speed (m/s)'), ylabel('Drag (N)'), adjustfigurefont('helvetica',14)
legend('Bowhead, 4.2 m^2 gape', 'Right, 1m^2 gape', 'Right, 2m^2 gape','location','NW')


figure(2), clf, hold on 
plot(U,4.2*U,'--','LineWidth',2)
plot(U,1*U,'--','LineWidth',2)
plot(U,2*U,'--','LineWidth',2)
xlabel('Swimming Speed (m/s)'), ylabel('Filtration Rate (m^3/s)'), adjustfigurefont('helvetica',14)
legend('Bowhead, 4.2 m^2 gape', 'Right, 1m^2 gape', 'Right, 2m^2 gape','location','NW')


figure(3), clf
h1 = axes('Color','w','XColor','k','YColor','k',...
          'YLim',[0 300],'Xlim',[0.5 2.5],'NextPlot','add');
h2 = axes('Color','none','XColor','k','YColor','k',...
          'YLim',[0 12],'Xlim',[0.5 2.5],...
          'Yaxislocation','right',...
          'Xaxislocation','bottom','NextPlot','add');

xlabel(h1,'Swimming Speed (m/s)');
ylabel(h1,'Drag (N)');
ylabel(h2,'Filtered Volume (m^3)');

plot(h1,U,bowhead_drag,'Linewidth',2)
plot(h1,U,right_drag1,'Linewidth',2)
plot(h1,U,right_drag2,'Linewidth',2)

plot(h2,U,4.2*U,'--','LineWidth',2)
plot(h2,U,1*U,'--','LineWidth',2)
plot(h2,U,2*U,'--','LineWidth',2)
legend('Bowhead, 4.2 m^2 gape', 'Right, 1m^2 gape', 'Right, 2m^2 gape','location','NW')

adjustfigurefont('Helvetica',14), print('bowhead_right_drag','-dpng')
