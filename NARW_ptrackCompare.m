% were pitch tracks done with estimated speed?

% import tag and flowspeed
load('NARW_foraging_tags')
ID = 8;
tag = tags{ID};
loadprh(tag);
t = (1:length(p))/fs;
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
anna = ptrack; clear ptrack % resave variable and clear because ptrack is also function name

% calculate for a dive (since have flowest per dive)
for i = 1:length(T); % for all dives
    if ~isempty(dive(i).stops)
        dcue = T(i,1):T(i,2);
        
        figure(1), clf, hold on
        % plot original pitch tracks from Anna
        % plot3(anna(dcue*fs,1),anna(dcue*fs,2),-p(dcue*fs),'color',[0.5 0.5 0.5])
        
        % redo the old way and plot
        oldtrack = ptrack_old(pitch(dcue*fs),head(dcue*fs),p(dcue*fs),fs); % D2 era
        plot3(oldtrack(:,1),oldtrack(:,2),-p(dcue*fs))
        
        % calculate a pitch track with the flowest
        flowtrack = ptrack(Aw(round(dcue*fs),:),Mw(round(dcue*fs),:),dive(i).flowEst(1:(length(dcue))),fs);
        
        % plot on top of each other
        plot3(flowtrack(:,1),flowtrack(:,2),-p(dcue*fs))
        legend('old','flowEst')
        
        % calculate tortuosity for both 
        tort_old = tortuosity(oldtrack((dive(i).btm),:),fs,5);
        tort_flow = tortuosity(flowtrack((dive(i).btm),:),fs,5);
        figure(2), hold on
        plot(i,mean(tort_old(:,1)),'ko')
        plot(i,mean(tort_flow(:,1)),'ro')
    end
end
% cross fingers

% tortuosity is different if using flowEst or using OCDR -- have to
% integrate flowEst method into code and rerun 

