%% figure for Doug et al
load('NARW_foraging_tags')
ID = 7; tag = tags{ID}; 
loadprh(tag)
pdeg = rad2deg(pitch);
T = finddives(p,fs,50,1);
[v,ph,~,~] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]); % calculate pitch deviation
% filter pitch signal to remove fluking 
f_high = 0.11; 
[b,a] = butter(4,f_high/fs,'low') ;	% make a 4 'pole' Butterworth bandpass filter
xf = filter(b,a,pdeg) ;		% apply the filter [b,a] to signal x

hil = abs(hilbert(ph)); % compute hibert transform
j = njerk(Aw,fs); % compute jerk


load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
%% 
figure(19), clf, hold on
set(gcf,'position',[1439        -114        1040         420],'paperpositionmode','auto')
plot([0 25],[0 0],'color',[0.75 0.75 0.75])
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
    view(2), caxis([0.8 2.2]), h = colorbar;
    
    % plot pitch and pitch deviation in bottom
    [frst,lst] = findbottomtime(pdeg(round(dcue*fs)),fs,1);
    btm = frst:lst; % bottom time in seconds
    plot(xcue',xf(round(dcue*fs)),'color','k','linewidth',2) % plot pitch through time
    plot(xcue,100+ph(round(dcue*fs))*100,'color',[0.8500    0.3250    0.0980]) % plot pitch deviation through time
    % plot(dcue/60, j(round(dcue*fs))*50-p(round(dcue*fs)),'k') % plot jerk along depth profile
    
    % plot detected and selected stops
    if isempty(dive(i).stops) == 0
        plot((5+dive(i).stops(:,1)-dcue(1)+60*10)/60,82+zeros(length(dive(i).stops),1),'k^','markersize',10,'markerfacecolor','k') % plot beginning
        plot((dive(i).stops(:,2)-dcue(1)+60*10)/60,118+zeros(length(dive(i).stops),1),'kv','markersize',10) % plot ends
    end
end

xlabel('Time (min)'), ylabel('        Depth (m)         Pitch (deg)'), ylabel(h, 'Estimated Speed (m/s)')
adjustfigurefont
xlim([0 25])
print([cd '\' tag '_DiveSpeedPitch'],'-dsvg')
% end



%% figure of glide, hilbert, etc 
keep tags

ID = 7; tag = tags{ID}; 
loadprh(tag)
pdeg = rad2deg(pitch);
T = finddives(p,fs,50,1);
[v,ph,~,~] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]); % calculate pitch deviation
hil = abs(hilbert(ph)); % compute hibert transform
j = njerk(Aw,fs); % compute jerk
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])

t = (1:length(p))/fs/3600; % compute time vector
figure(1), clf, hold on 
plot(hil(4736:8743),'b')
plot(ph(4736:8743),'r')
plot(-p(4736:8743)/100,'k')

