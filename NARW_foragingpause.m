tag = 'eg05_231b'; %'eg05_219a'; % 'eg05_231b';
loadprh(tag);
t = (1:length(p))/fs;
pdeg = rad2deg(pitch);
warning off
%% flownoise
% find dives
T = finddives(p,fs,50,1);
[v,ph,~,~] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]); % calculate pitch deviation
hil = abs(hilbert(ph)); % compute hibert transform

for i = 1:length(T); % for all dives
    dcue = T(i,1):T(i,2);
    figure(1), clf, hold on
    plot(dcue,ph(dcue*fs)) % plot pitch deviation
    
    plot(dcue,hil(dcue*fs),'b') % plot hilbert transform
    
    plot([dcue(1) dcue(end)],[0.04 0.04]) % plot threshold
    
    % use 'findglides' to find pauses in fluking
    gl = findglides([dcue(1) dcue(end)],fs,ph);
    plot(gl(:,1),zeros(length(gl(:,1)),1),'*') % plot detected glides
    
    % this is working ok but we really want to find longer-than-average fluke strokes 
[pks,locs] = findpeaks(ph(dcue*fs),fs,'minpeakprominence',0.02);
plot(dcue(locs*fs),pks,'ko')

figure(3), clf, hold on
plot(dcue(locs(2:end)*fs),diff(locs)) % plot time between fluke strokes vs time
xlabel('Time (sec)'), ylabel('Time since last fluke stroke')
plot([dcue(1) dcue(end)],[quantile(diff(locs),0.8) quantile(diff(locs),0.8)]) % plot threshold
stops = find(diff(locs) > quantile(diff(locs),0.8)); % detect those pauses 
diff(locs(stops)) % compute time between     

figure(8), hold on % plot pitch track to see what happens/where they go after dive
plot3(ptrack(:,1),ptrack(:,2),-p,'color',[0.5 0.5 0.5])
plot3(ptrack(dcue*fs,1),ptrack(dcue*fs,2),-p(dcue*fs),'linewidth',2)

pause
end

% this is working ok but we really want to find longer-than-average fluke
% strokes 
[pks,locs] = findpeaks(ph(dcue*fs),fs,'minpeakprominence',0.02);
plot(dcue(locs*fs),pks,'ko')

figure(3), hold on
plot(dcue(locs(2:end)*fs),diff(locs)) % plot time between fluke strokes vs time
xlabel('Time (sec)'), ylabel('Time since last fluke stroke')

return 

%% plot difference in diving descent/ascent
for i = 1:length(T)
figure(100), hold on
plot(-p(T(i,1)*fs:T(i,1)*fs+600))
end
for i = 1:length(T)
figure(101), hold on
plot(-p(T(i,2)*fs-600:T(i,2)*fs))
end

