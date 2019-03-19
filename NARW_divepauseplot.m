%% look at individual dive shapes
% redo with estimated speed

% import tag and flowspeed
load('NARW_foraging_tags')
ID = 8;
tag = tags{ID};
loadprh(tag);
t = (1:length(p))/fs;
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
anna = ptrack; clear ptrack % resave variable and clear because ptrack is also function name

T = finddives(p,fs,50,1);

% set up figure
sb = 0;
figure(3), clf, set(gcf,'position',[494  -95 752 559],'paperpositionmode','auto')
for j = [9 10 11 12]
    sb = sb+1; % subplot counter
    dcue = T(j,1):T(j,2); % seconds in dive
    
    % calculate pitch track for dive using flowEst
    flowtrack = ptrack(Aw(round(dcue*fs),:),Mw(round(dcue*fs),:),dive(j).flowEst(1:(length(dcue))),fs);
    
    subplot(2,2,sb),
    hold on
    startpt = flowtrack(1,:);
    % plot3(ptrack(round(dcue*fs),1),ptrack(round(dcue*fs),2),-p(round(dcue*fs)),'color',c(j,:),'linewidth',3)
    %     tort = tortuosity(ptrack(round(dcue*fs),:),fs,1);
    xx = [flowtrack(:,1)-startpt(1) flowtrack(:,1)-startpt(1)]; % x coords, downsampled
    yy = [flowtrack(:,2)-startpt(2) flowtrack(:,2)-startpt(2)]; % y coords, downsampled
    zz = [-p(dcue(1:end)*fs) -p(dcue(1:end)*fs)];
    cc = [dive(j).flowEst(1:length(dcue)) dive(j).flowEst(1:length(dcue))];
    hs = surf(xx,yy,zz,cc,'EdgeColor','Interp','LineWidth',3);
    % view(2), colorbar, caxis([0 1])
    % center at zero
    
    % plot start and end points
    hold on, plot3(flowtrack(1,1)-startpt(1),flowtrack(1,2)-startpt(2),-p(round(dcue(1)*fs)),'kv','markerfacecolor','k','MarkerSize',10)
    plot3(flowtrack(end,1)-startpt(1),flowtrack(end,2)-startpt(2),-p(round(dcue(end)*fs)),'k^','markerfacecolor','k','MarkerSize',10)
    
    % plot pitch
    [v,ph,mx,fr] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]); % calculate pitch deviation
    plot3(flowtrack(:,1)-startpt(1),flowtrack(:,2)-startpt(2),ph(round(dcue*fs))*60-p(round(dcue*fs)),'k')
    
    if isempty(dive(j).stops) == 0
        for k = 1:length(dive(j).stops)
            plot3(flowtrack(round(dive(j).stops(k,1))-dcue(1),1)-startpt(1),flowtrack(round(dive(j).stops(k,1))-dcue(1),2)-startpt(2),-p(round(dive(j).stops(k,1)*fs))+8,'kv')
        end
    end
    view([17 27]), grid on, % pause
    xlabel('Easting (m)'), ylabel('Northing (m)'), zlabel('Depth (m)'), rotate_labels(gca)
    set(gca,'xtick',-400:200:400,'ytick',-400:200:400)
    
    tort(:,j) = nanmean(tortuosity(flowtrack(dive(j).btm),:),fs,10,1);
    % nanmean(tort)
end

adjustfigurefont('Helvetica',14)
subplot(221), xlim([-250 250]), ylim([0 500]), zlim([-150 10]), title('A','FontSize',18,'FontWeight','bold')
axletter(gca,['vol: ' num2str(round(sum(dive(9).vperblock),0)) ' m^3'],14,0.9)
axletter(gca,['tortuosity ' num2str(round(tort(1,9),3))],14,0.9,0.7)

subplot(222), xlim([-100 400]), ylim([-400 100]), zlim([-150 10]), title('B','FontSize',18,'FontWeight','bold')
axletter(gca,['vol: ' num2str(round(sum(dive(10).vperblock),0)) ' m^3'],14,0.9)
axletter(gca,['tortuosity ' num2str(round(tort(1,10),3))],14,0.9,0.7)

subplot(223), xlim([-150 350]), ylim([-350 150 ]), zlim([-150 10]), title('C','FontSize',18,'FontWeight','bold')
axletter(gca,['vol: ' num2str(round(sum(dive(11).vperblock),0)) ' m^3'],14,0.9)
axletter(gca,['tortuosity ' num2str(round(tort(1,11),3))],14,0.9,0.7)

subplot(224), xlim([-450 50]), ylim([-150 350]), zlim([-150 10]), title('D','FontSize',18,'FontWeight','bold')
axletter(gca,['vol: ' num2str(round(sum(dive(12).vperblock),0)) ' m^3'],14,0.9)
axletter(gca,['tortuosity ' num2str(round(tort(1,12),3))],14,0.9,0.7)
colorbar('position',[0.93 0.11 0.02 0.815])
% print('NARW_ptrack4.png','-dpng','-r300')