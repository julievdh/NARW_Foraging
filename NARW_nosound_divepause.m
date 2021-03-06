% for tags where we don't have audio
%tag = 'eg01_207a'; 
%loadprh(tag)
%T = finddives(p,fs,50,1);
%[v,ph,~,~] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]); % calculate pitch deviation
%pdeg = rad2deg(pitch); 

for i = 1:10; size(T,1); % have to make some rule on dive shape
    %%
    figure(9), clf, hold on % for this example
    dcue = T(i,1):T(i,2); % time in seconds
    
    plot(dcue/60, -p(round(dcue*fs)),'color',[0.7 0.7 0.7])
    % plot(dcue/60, j(round(dcue*fs))*50-p(round(dcue*fs)),'k') % plot jerk along depth profile
    
    title(['Dive ' num2str(i)])
    xlabel('Time (min)')
    
    % find bottom time based on pitch angle < 20
    [frst,lst] = findbottomtime(pdeg(round(dcue*fs)),fs,1);
    %%
    if isnan(frst) ~= 1 
        btm = frst:lst; % bottom time in seconds
        plot(dcue/60,pdeg(round(dcue*fs)),'b') % plot pitch through time
        %plot(dcue(btm)/60,pdeg(dcue(btm)*fs),'.') % plot pitch on bottom
        plot(dcue(btm)/60,ph(round(dcue(btm)*fs))*100) % plot pitch deviation signal during bottom
        if tag == 'eg05_231b'
            [pks,gl] = findpeaks(j(dcue(btm)*fs),1,'minpeakdistance',30,'minpeakheight',0.3); % find peaks in jerk signal
            %[pks,locs] = findpeaks(ph(dcue(btm)*fs),fs,'minpeakprominence',0.02); % find peaks with ph instead
            plot(dcue(btm(gl))/60,ph(dcue(btm(gl))*fs),'k*')
            gl = gl(:,1)+ dcue(btm(1)); % for consistency with other method
        end
        
        gl = findglides([dcue(btm(1)) dcue(btm(end))],fs,ph);
        hold on, plot(gl(:,1)/60,zeros(length(gl(:,1)),1),'k*') % plot detected glides
        
        % pick out starts/stops from detected glides and save them
        stops = [];
        %if exist('dive','var') == 0 | size(dive,2) < i
            NARW_PauseSelect
        %end
        %if size(dive,2) >= i
        %    stops = dive(i).stops;
        %end
        if isempty(stops) == 0
            plot(stops(:,2)/60,zeros(length(stops(:,2)),1),'r*') % plot selected stops
            plot(stops(:,1)/60,zeros(length(stops(:,2)),1),'g*')
            
            %[pks,locs] = findpeaks(ph(dcue*fs),fs,'minpeakprominence',0.02);
            %plot(dcue(locs*fs),pks,'ko')
            
            %figure(3), clf, hold on
            %plot(dcue(locs(2:end)*fs),diff(locs)) % plot time between fluke strokes vs time
            %xlabel('Time (sec)'), ylabel('Time since last fluke stroke')
            %plot([dcue(1) dcue(end)],[quantile(diff(locs),0.8) quantile(diff(locs),0.8)]) % plot threshold
            %stops = find(diff(locs) > quantile(diff(locs),0.8)); % detect those pauses
            %diff(locs(stops)) % compute time between
            if exist('ptrack','var') == 1
                figure(8), hold on % plot pitch track to see what happens/where they go after dive
                plot3(ptrack(:,1),ptrack(:,2),-p,'color',[0.5 0.5 0.5])
                plot3(ptrack(dcue*fs,1),ptrack(dcue*fs,2),-p(dcue*fs),'linewidth',2)
            end
            
            % store/plot values
            stops = sort(stops);
            dive(i).stops = stops;
            % block duration
            figure(299), subplot(221), hold on
            errorbar(T(i,1),mean(stops(:,2)-stops(:,1)),std(stops(:,2)-stops(:,1)),'o')
            plot([T(i,1) T(i,2)],[mean(stops(:,2)-stops(:,1)) mean(stops(:,2)-stops(:,1))])
            ylabel('Duration of Consistent Fluking'), xlabel('Time of dive start')
            
            dive(i).btm = btm;
        end
    end
end

save(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'],'dive','-append')
