% were pitch tracks done with estimated speed?

% import tag and flowspeed
load('NARW_foraging_tags')
ID = 8;
tag = tags{ID};
loadprh(tag);
t = (1:length(p))/fs;
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
anna = ptrack; clear ptrack % resave variable and clear because ptrack is also function name

% plot original pitch tracks from Anna
figure(1), clf, hold on
plot3(anna(:,1),anna(:,2),-p,'color',[0.5 0.5 0.5])

% redo the old way and plot
[Track] = ptrack_old(pitch,head,p,fs); % D2 era
plot3(Track(:,1),Track(:,2),-p)

% calculate a pitch track with the flowest
% calculate for a dive (since have flowest per dive)
for i = 1:length(T); % for all dives
    if isempty(dive(i).stops)
        dcue = T(i,1):T(i,2);
        [flowtrack,pest] = ptrack(Aw(round(dcue*fs),:),Mw(round(dcue*fs),:),dive(i).flowEst(1:(length(dcue))),fs);
        
        % plot on top of each other
        plot3(flowtrack(:,1),flowtrack(:,2),-p(dcue*fs))
        
    end
end
% cross fingers

