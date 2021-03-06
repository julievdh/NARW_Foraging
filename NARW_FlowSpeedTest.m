% NARW Flow Speed and Filtered Volume Estimates
% Julie van der Hoop 2018

clear

load('NARW_foraging_tags') % let's make this more straightforward
% HAVE TO RECOMPUTE VOLUMES FOR ALL TO ENSURE CORRECT GAPE IS USED - new
% gapes, including from measured lengths (Perryman) 11 March 2019 
ID = 10;
tag = tags{ID};
loadprh(tag,'p','fs','Aw','Mw','pitch');

t = (1:length(p))/fs;
pdeg = rad2deg(pitch);
warning off
%% flownoise
% find dives
T = finddives(p,fs,50,1);
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
d2after = tags{ID,9};
%%
% for all dives
% %for i = 1:size(T,1) % missing first 10 dives in first 2 .dtgs
%     % cut dive into 1s long chunks
%     dcue = T(i,1):T(i,2);
%     plot(dcue*fs, -p(round(dcue*fs))), hold on
%     for j = 5:1:length(dcue)-10 % remove first 5 and last 5 seconds of dive
%         % import the sound for that 5 s chunk
%         % [s,afs] = tagwavread(tag,dseg(1),dseg(2)-dseg(1));
%         % calculate flow noise
%         [v,afs] = flownoise(tag,dcue(j),dcue(j+1)); % 1 second long
%         medFN(i,j) = mean(v);
%         % calculate change in pitch over that chunk
%         dsamp = round(dcue(j)*fs:dcue(j+10)*fs);
%         medpitch(i,j) = mean(pdeg(dsamp));
%         plot(dsamp,pdeg(dsamp))
%         % calculate change in depth over that chunk
%         deldepth(i,j) = mean(diff(p(dsamp))*fs);% p(dsamp(end))-p(dsamp(1)); % checked -- same as p(dcue(j+5)*fs) - p(dcue(j)*fs)
%         % try to median(diff(p(dsamp))*fs
%         spd(i,j) = deldepth(i,j)./sind(medpitch(i,j));
%         % plot(medFN(i,j),spd(i,j),'o')
%
%         figure(12), hold on
%         plot(dcue,-p(round(dcue*fs)))
%         plot(dcue,pdeg(round(dcue*fs)))
%         plot(dcue(j),abs(spd(i,j)),'o')
%     end
%     % add the NaN removal here: can't exceed max deldepth over that
%     % dive cycle (remove any speeds greater than max vertical speeds)
%     exd = find(abs(spd(i,:)) > 1.5*max(abs(diff(p(round(dcue*fs))))));
%     spd(i,exd) = NaN;
% end
% % spd(spd < min(diff(p))) = NaN;
% % spd(spd > max(diff(p))) = NaN;
%
% % save some parameters
% save(strcat('C:/tag/tagdata/',tag,'_flowspeed'),'medFN','spd','medpitch','T','p','pitch','fs')
%%
figure(4), clf, hold on
th = 30;
plot(log10(medFN(medpitch > th)),abs(spd(medpitch > th)),'o','LineWidth',1.5) % ascents
plot(log10(medFN(medpitch < -th)),abs(spd(medpitch < -th)),'o','LineWidth',1.5) % descents
ylabel('Speed (m/s)'), xlabel('Log_1_0(Median Flow Noise)')

figure(5), clf, hold on
for i = d2after'
    scatter(abs(spd(i,:)),log10(medFN(i,:)),20,abs(medpitch(i,:)))
    pause
end
colorbar
xlabel('Speed (m/s)'), ylabel('Flow Noise'),

selspeed = []; selFN = [];
for i = d2after'
    ii = find(abs(medpitch(i,:)) > th);
    % ii = find(medpitch(i,:) < -th); 
    selspeed = horzcat(selspeed,abs(spd(i,ii)));
    selFN = horzcat(selFN,medFN(i,ii));
    selFN(isnan(selspeed)) = [];
    selspeed(isnan(selspeed)) = [];
end

logselFN = log10(selFN);
if tag == 'eg01_214a'
    ii = find(logselFN > -2.1);
    logselFN = logselFN(ii);
    selspeed = selspeed(ii);
end
plot(logselFN,selspeed,'o')

% myfit = fittype('a+b*20*log10(x)','dependent',{'y'},'independent',{'x'},'coefficients',{'a','b'});
%[c,g] = fit(logselFN,selspeed,'poly1','robust','LAR')
[c,g] = fit(logselFN',selspeed','poly2','lower',[-Inf -1 -Inf],'upper',[0.2 Inf Inf],'robust','LAR')
figure(4),
h = plot(c,'k'); h.LineWidth = 2;  legend off
ci = predint(c,linspace(min(logselFN),max(logselFN),100));
plot(linspace(min(logselFN),max(logselFN),100),ci,'k--','LineWidth',2)
ylabel('Vertical speed (m/s)'), xlabel('Log_1_0(Flow noise)'), adjustfigurefont('Helvetica',14)
axletter(gca,['R^2 = ' num2str(round(g.rsquare,2))],14)
axletter(gca,['RMSE = ' num2str(round(g.rmse,2)) ' m/s'],14,0.05,0.85)
axletter(gca,['y = ' num2str(round(c.p3,2)) ' + ' num2str(round(c.p2,2)) 'x + ' num2str(round(c.p1,2)) 'x^2'],12,0.65,0.1)
set(gcf,'paperpositionmode','auto')
% print('NARW_FlowNoise_SuppFig.png','-dpng','-r300')

% expvsquad

%% apply
% calculate pitch
[~,ph] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]);
hil = abs(hilbert(ph)); % compute hibert transform
% calculate jerk
j = njerk(Aw,fs);
if exist('dive','var') == 0
    dive = [];
end
%%
figure(10), clf
figure(299), clf
for i = d2after';
    %%
    flowEst = feval(c,log10(medFN(i,:))); % 1 Hz speed estimate from flow sound
    figure(4)
    plot(log10(medFN(i,:)),flowEst,'.')
    
    figure(9), clf, hold on % for this example
    dcue = T(i,1):T(i,2); % time in seconds
    % plot(dcue, -p(dcue*fs))
    xx = [dcue/60; dcue/60]'; % minutes
    yy = [-p(round(dcue*fs)) -p(round(dcue*fs))];
    zz = zeros(size(xx));
    cc = [flowEst(1:(length(xx)-10)) flowEst(1:(length(xx))-10)];
    cc(end+1:end+10,:) = Inf;
    hs = surf(xx,yy,zz,cc,'EdgeColor','Interp','LineWidth',3);
    view(2), colorbar
    
    plot(dcue/60, j(round(dcue*fs))*50-p(round(dcue*fs)),'k') % plot jerk along depth profile
    title(['Dive ' num2str(i)])
    xlabel('Time (min)')
    
    % calculate filtered volume
    switch ID
        case 5
            gape = getgape(tags{ID,6}, 1190)/100;
        case 9
            gape = getgape(tags{ID,6}, 1210)/100;
        case 7
            gape = getgape(tags{ID,6}, 1250)/100;
        case 8
            gape = getgape(tags{ID,6}, 1250)/100;
        otherwise
            gape = getgape(tags{ID,6})/100;
    end
    
    % find bottom time based on pitch angle < 20
    [frst,lst] = findbottomtime(pdeg(round(dcue*fs)),fs,1);
    %%
    if isnan(frst) ~= 1
        %%
        btm = frst:lst; % bottom time in seconds
        plot(dcue/60,pdeg(round(dcue*fs))) % plot pitch through time
        %plot(dcue(btm)/60,pdeg(dcue(btm)*fs),'.') % plot pitch on bottom
        plot(dcue(btm)/60,ph(round(dcue(btm)*fs))*100) % plot pitch deviation signal during bottom
        if tag == 'eg05_231b'
            [pks,gl] = findpeaks(j(dcue(btm)*fs),1,'minpeakdistance',30,'minpeakheight',0.3); % find peaks in jerk signal
            %[pks,locs] = findpeaks(ph(dcue(btm)*fs),fs,'minpeakprominence',0.02); % find peaks with ph instead
            plot(dcue(btm(gl))/60,ph(dcue(btm(gl))*fs),'k*')
            gl = gl(:,1)+ dcue(btm(1)); % for consistency with other method
        end
        
        gl = findglides([dcue(btm(1)) dcue(btm(end))],fs,ph,2);
        hold on, plot(gl(:,1)/60,zeros(length(gl(:,1)),1),'k*') % plot detected glides
        plot(gl(:,2)/60,zeros(length(gl(:,1)),1),'k.') % plot detected glides
        
        
        % pick out starts/stops from detected glides and save them
        stops = [];
        if exist('dive','var') == 0 | size(dive,2) < i
            NARW_PauseSelect
        end
        if size(dive,2) >= i
            stops = dive(i).stops;
        end
        if isempty(stops) == 0
            plot(stops(:,2)/60,zeros(length(stops(:,2)),1)+1,'r*') % plot selected stops
            plot(stops(:,1)/60,zeros(length(stops(:,2)),1),'g*')
            plot([stops(:,1)/60 stops(:,2)/60],[0 5])
            
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
            
            %%
            frate = gape*flowEst(btm); % filtration rate = gape*flow speed
            vol = cumsum(frate(~isinf(frate))); % integrate rate for filtered volume
            figure(10), hold on
            plot(dcue(btm(~isinf(frate)))-dcue(btm(1)),vol), xlabel('Seconds into dive'), ylabel('Cumulative Filtered Volume (m^3)')
            %plot(stops(:,2)-dcue(btm(1)),vol(round(stops(:,2)-dcue(btm(1)))),'o')
            pause
            
            % store/plot values
            stops = sort(stops);
            del = find(stops(:,2)-stops(:,1) < 3);
            stops(del,:) = []; % delete those (they're input errors)
            
            dive(i).stops = stops;
            % block duration
            figure(299), subplot(221), hold on
            errorbar(T(i,1),mean(stops(:,2)-stops(:,1)),std(stops(:,2)-stops(:,1)),'o')
            plot([T(i,1) T(i,2)],[mean(stops(:,2)-stops(:,1)) mean(stops(:,2)-stops(:,1))])
            ylabel('Duration of Consistent Fluking'), xlabel('Time of dive start')
            % volume filtered per block
            %figure(11), plot(frate), hold on
            vperblock = []; mnspeedperblock = [];
            for k = 1:size(stops,1)
                vperblock(:,k) = sum(frate(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1))))));
                mnspeedperblock(:,k) = mean(flowEst(stops(k,1)-dcue(1):stops(k,2)-dcue(1)));
                % check
                % plot(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1)))),frate(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1))))))
            end
            figure(299), subplot(222), hold on
            plot(vperblock,'.-')
            dive(i).vperblock = vperblock;
            dive(i).mnspeedperblock = mnspeedperblock;
            dive(i).btm = btm;
        end
    end
    
    % store other things
    dive(i).flowEst = flowEst;
end


% append stops to file
save(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'],'dive','c','g','-append')

