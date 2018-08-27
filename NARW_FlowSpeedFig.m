%% figure for Doug et al
ID = 7;
loadprh(tag)
pdeg = rad2deg(pitch);
T = finddives(p,fs,50,1);
[v,ph,~,~] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]); % calculate pitch deviation
hil = abs(hilbert(ph)); % compute hibert transform
j = njerk(Aw,fs); % compute jerk

figure(19), clf, hold on
set(gcf,'position',[1439        -114        1040         420],'paperpositionmode','auto')
plot([0 26],[0 0],'color',[0.75 0.75 0.75])
for i = [3 5]; % have to make some rule on dive shape
    
    flowEst = dive(i).flowEst; % estimated flow speed
    
    dcue = T(i,1):T(i,2); % time in seconds
    if i == 3
        xcue = (dcue-dcue(1))/60;  % x axis coordinates
    else
        xcue = (dcue-dcue(1)+60*10)/60; % minutes
    end
    xx = [xcue; xcue]'; % minutes
    
    yy = [-p(round(dcue*fs)) -p(round(dcue*fs))];
    zz = zeros(size(xx));
    cc = [flowEst(1:(length(xx)-10)) flowEst(1:(length(xx))-10)];
    cc(end+1:end+10,:) = Inf;
    hs = surf(xx,yy,zz,cc,'EdgeColor','Interp','LineWidth',4);
    view(2), caxis([0.7 2.2]), h = colorbar;
    
    % plot pitch and pitch deviation in bottom
    [frst,lst] = findbottomtime(pdeg(round(dcue*fs)),fs,1);
    btm = frst:lst; % bottom time in seconds
    plot(xcue,pdeg(round(dcue*fs)),'color',[ 0    0.4470    0.7410]) % plot pitch through time
    plot(xcue,100+ph(round(dcue*fs))*100,'color',[0.8500    0.3250    0.0980]) % plot pitch deviation signal during bottom
    % plot(dcue/60, j(round(dcue*fs))*50-p(round(dcue*fs)),'k') % plot jerk along depth profile
    
    % plot detected and selected stops
    if isempty(dive(i).stops) == 0
        plot((dive(i).stops(:,1)-dcue(1)+60*10)/60,90+zeros(length(dive(i).stops),1),'k^','markersize',10,'markerfacecolor','k') % plot beginning
        plot((dive(i).stops(:,2)-dcue(1)+60*10)/60,90+zeros(length(dive(i).stops),1),'k^','markersize',10,'markerfacecolor','k') % plot ends
    end
end

xlabel('Time (min)'), ylabel('        Depth (m)         Pitch (deg)'), ylabel(h, 'Estimated Speed (m/s)')
adjustfigurefont
xlim([0 26])
% print([cd '\' tag '_dives28-29.png'],'-dpng')
% end


