figure(19), clf, hold on
subplot('position',[0.07 0.1 0.55 0.8]), hold on
plot(t*3600,ph*50,'color',[0.3010    0.7450    0.9330],'Linewidth',1.5)
plot(t*3600,-p,'color',[0.7 0.7 0.7],'linewidth',2)

if exist('dive','var') == 1
    for j = 1:size(T,1)
        col = viridis(size(T,1)); % color dive number
        dcue = T(j,1):T(j,2); % seconds in dive
        subplot('position',[0.07 0.1 0.55 0.8]), hold on
        plot(dcue,-p(round(dcue*fs)),'color',col(j,:),'linewidth',3)
        if isempty(dive(j).stops) ~= 1
            h = errorbar(T(j,1),100+mean(dive(j).stops(:,2)-dive(j).stops(:,1)),std(dive(j).stops(:,2)-dive(j).stops(:,1)),'bo','markerfacecolor','b');
            plot(dive(j).stops(:,2),100+dive(j).stops(:,2)-dive(j).stops(:,1),'.-','color',[0.7 0.7 1],'linewidth',2) % add stop duration
            plot(dive(j).stops(:,1),100+dive(j).rms(:)*500,'.-','color','k','linewidth',2)
        end
        if isempty(dive(j).vperblock) ~= 1
            plot([dcue(1) dive(j).btm(1)+dcue(1)],[0 0],'linewidth',2)
            % from the surface until first stop = travel time
            dive(j).travel(1) = dive(j).stops(1,1)-dcue(1); % seconds
            dive(j).forage = sum(dive(j).stops(:,2)-dive(j).stops(:,1)); % seconds
            dive(j).travel(2) = dcue(end)-dive(j).stops(end,2);
            % add stops
            plot([dive(j).stops(1,1) dive(j).stops(1,2)],[0 dive(j).vperblock(1)/10],'.-','linewidth',2) % first starts at zero
            for k = 2:size(dive(j).stops,1)
                plot([dive(j).stops(k,1) dive(j).stops(k,2)],[sum(dive(j).vperblock(1:k-1))/10 sum(dive(j).vperblock(1:k))/10],'.-','linewidth',2)
            end
            plot([dive(j).stops(k,2) dcue(end)],[sum(dive(j).vperblock(1:k))/10 sum(dive(j).vperblock(1:k))/10],'linewidth',2) % ends at end of last pause, goes to surface
        end
        if exist('ptrack','var')
            subplot('position',[0.65 0.1 0.3 0.8]), hold on
            plot3(ptrack(:,1),ptrack(:,2),-p,'color',[0.5 0.5 0.5],'linewidth',2)
            plot3(ptrack(round(dcue*fs),1),ptrack(round(dcue*fs),2),-p(round(dcue*fs)),'color',col(j,:),'linewidth',3)
            % add stops
            %for k = 1:length(dive(j).stops)
            %    plot3(ptrack(round(dive(j).stops(k,1)*fs),1),ptrack(round(dive(j).stops(k,1)*fs),2),-p(round(dive(j).stops(k,1)*fs)),'ko')
            %end
        end
        
    end
end
title(regexprep(tag,'_',' '))
%xlabel('Time (seconds)')
%ylabel('Depth (m)')
adjustfigurefont

set(gcf,'position',[1513 -14 1309 560],'paperpositionmode','auto')

subplot('position',[0.07 0.1 0.55 0.8]), hold on
set(gca,'ytick',[-150:50:200],'yticklabels',{'150','100','50','0','500','1000','50','100'})
xlabel('Time (seconds)'), ylabel('                                       Depth (m)        Volume Filtered (m^3)         Bout Duration (sec)')
subplot('position',[0.65 0.1 0.3 0.8]), hold on
xlabel('Easting (m)'), ylabel('Northing (m)')

print([tag 'dive_vol_pause.png'],'-dpng','-r300')
return 

%% look at individual dive shapes
sb = 0; 
figure(3), clf, set(gcf,'position',[494  -95 752 559],'paperpositionmode','auto')
for j = [9 10 11 12]
    sb = sb+1; % subplot counter
    dcue = T(j,1):T(j,2); % seconds in dive

    subplot(2,2,sb), 
    hold on
        startpt = ptrack(round(dcue(1)*fs),:); 
    % plot3(ptrack(round(dcue*fs),1),ptrack(round(dcue*fs),2),-p(round(dcue*fs)),'color',c(j,:),'linewidth',3)
%     tort = tortuosity(ptrack(round(dcue*fs),:),fs,1);
     xx = [ptrack(dcue(1:end)*fs,1)-startpt(1) ptrack(dcue(1:end)*fs,1)-startpt(1)]; % x coords, downsampled
     yy = [ptrack(dcue(1:end)*fs,2)-startpt(2) ptrack(dcue(1:end)*fs,2)-startpt(2)]; % y coords, downsampled
     zz = [-p(dcue(1:end)*fs) -p(dcue(1:end)*fs)];
     cc = [dive(j).flowEst(1:length(dcue)) dive(j).flowEst(1:length(dcue))];
     hs = surf(xx,yy,zz,cc,'EdgeColor','Interp','LineWidth',3);
    % view(2), colorbar, caxis([0 1])
    % center at zero

    % plot3(ptrack(round(dcue*fs),1)-startpt(1),ptrack(round(dcue*fs),2)-startpt(2),-p(round(dcue*fs)),'color',c(j,:),'linewidth',3)
    hold on, plot3(ptrack(round(dcue(1)*fs),1)-startpt(1),ptrack(round(dcue(1)*fs),2)-startpt(2),-p(round(dcue(1)*fs)),'kv','markerfacecolor','k','MarkerSize',10)
    plot3(ptrack(round(dcue(end)*fs),1)-startpt(1),ptrack(round(dcue(end)*fs),2)-startpt(2),-p(round(dcue(end)*fs)),'k^','markerfacecolor','k','MarkerSize',10)

    % plot3(ptrack(round(dcue*fs),1)-startpt(1),ptrack(round(dcue*fs),2)-startpt(2),ph(round(dcue*fs))*50-p(round(dcue*fs)),'k')
    if isempty(dive(j).stops) == 0
        for k = 1:length(dive(j).stops)
        plot3(ptrack(round(dive(j).stops(k,1)*fs),1)-startpt(1),ptrack(round(dive(j).stops(k,1)*fs),2)-startpt(2),-p(round(dive(j).stops(k,1)*fs))+8,'kv')
        end
    end
    view([17 27]), grid on, % pause
    xlabel('Easting (m)'), ylabel('Northing (m)'), zlabel('Depth (m)'), rotate_labels(gca)
    set(gca,'xtick',-400:200:400,'ytick',-400:200:400) 
    
    tort(:,j) = nanmean(tortuosity(ptrack(dcue(dive(j).btm)*fs,:),fs,10),1);
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