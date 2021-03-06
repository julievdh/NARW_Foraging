% NARW_RCD
% obtain rate of change in direction every 10 s
addpath '/Users/jvanderhoop/Documents/MATLAB/CircStat2012a'
warning off 

% load prh
load('NARW_foraging_tags')
alld = [];
alls = [];
d_RCD = []; 
s_RCD = []; 
for i = 1:8 %size(tags,1)
    tag = tags{i}; ID = i;
    loadprh(tag)
    load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
    
    % add playback info
    for pb = 1:size(tags{i,7},1)
        pbstart = tags{i,7}(pb,1)+tags{i,7}(pb,2)/60+tags{i,7}(pb,3)/3600; 
        pbend = tags{i,7}(pb,4)+tags{i,7}(pb,5)/60+tags{i,7}(pb,6)/3600; 
        if sum(tags{i,7}) > 0 % if there is a playback
            % calculate time left in recording after playback
            tagend = datevec(addtodate(datenum(tags{i,2}),length(p)/fs,'second'));
            ttend(i) = etime(tagend,[tags{i,2}(1:3) tags{i,7}(end,4:6)])/3600; % time from end playback to end of recording in hours
            astart = 2+(tags{i,7}(end,4)+tags{i,7}(end,5)/60+tags{i,7}(end,6)/3600); % analysis start time: 2h after playback end
            % analysis start cue = 2h after playback end
            astartcue = (astart-(tags{i,2}(4)+tags{i,2}(5)/60+tags{i,2}(6)/3600))*3600*fs;
            tags{i,8} = astartcue; 
        else astartcue = 1;
        end
    end
    
    % downsample everything to every 10 seconds
    [pf,qf] = rat(0.1/fs,0.0001); % obtain resampling factors
    Aw_rs = resample(Aw(astartcue:end,:),pf,qf);
    Mw_rs = resample(Mw(astartcue:end,:),pf,qf);
    [pitch_rs,roll_rs] = a2pr(Aw_rs);
    head_rs = m2h(Mw_rs,pitch_rs,roll_rs);
    pall = p; ptall = ptrack; 
    p = p(astartcue:end); 
    ptrack = ptrack(astartcue:end,:); 
    
    
    %figure, hold on
    %plott(head_rs,0.1,'.') % downsampled and recomputed data
    %plott(head,fs) % original data
    
    % diff
    myDiff=diff(head_rs);
    myDiff(myDiff>pi)=myDiff(myDiff>pi)-2*pi;
    myDiff(myDiff<-pi)=myDiff(myDiff<-pi)+2*pi;
    
    % get new indices for dives for down-sampled data
    % T = finddives(p,fs,50,1);
    t_rs = (1:length(head_rs))/0.1; % time vector for downsampled series
%     % find nearest values for start and end
%     for j = tags{i,9}'
%         st = nearest(t_rs',T(j,1));
%         ed = nearest(t_rs',T(j,2));
%         endd = size(d_RCD,1); 
%         d_RCD(endd+1,1:2) = [circ_mean(myDiff(st:ed)) circ_std(myDiff(st:ed))]; % mean/STD RCD in dive in Radians
%         d_RCD(endd+1,3:4) = [j i]; 
%         % figure(3), hold on, rose(myDiff(st:ed))
%         endd = length(alld);
%         alld(endd+1:endd+length(st:ed),1) = myDiff(st:ed); % all RCD in dive
%         alld(endd+1:endd+length(st:ed),2) = repmat(j,length(st:ed),1); % store dive number
%         alld(endd+1:endd+length(st:ed),3) = repmat(ID,length(st:ed),1); % store tag ID
%     end
%     for j = 1:size(T,1)-1
%         st = nearest(t_rs',T(j,2)); % end of one dive
%         ed = nearest(t_rs',T(j+1,1)); % start of next dive
%         endd = size(s_RCD,1); 
%         s_RCD(endd+1,1:2) = [circ_mean(myDiff(st:ed)) circ_std(myDiff(st:ed))]; % mean/STD RCD at surface
%         s_RCD(endd+1,3:4) = [j i]; 
%         % figure(4), hold on, rose(myDiff(st:ed))
%         endd = length(alls);
%         alls(endd+1:endd+length(st:ed),1) = myDiff(st:ed); % all RCD in dive
%         alls(endd+1:endd+length(st:ed),2) = repmat(j,length(st:ed),1);
%         alls(endd+1:endd+length(st:ed),3) = repmat(ID,length(st:ed),1); % store tag ID
%     end
    
    % plot pitch track with coloured RCD just to check
    figure(1), clf
    xx = [ptrack(1:50:end-50,1) ptrack(1:50:end-50,1)]; % x coords, downsampled
    yy = [ptrack(1:50:end-50,2) ptrack(1:50:end-50,2)]; % y coords, downsampled
    zz = [-p(1:50:end-50) -p(1:50:end-50)]; % zeros(size(xx));
    cc = [abs(rad2deg(myDiff)) abs(rad2deg(myDiff))];
    hs = surf(xx,yy,zz,cc,'EdgeColor','Interp','LineWidth',3);
    view(2), colorbar, caxis([0 rad2deg(pi/4)])
    % pause
    
    mnRCD(i,1) = circ_mean(myDiff); 
    mnRCD(i,2) = circ_std(myDiff); 
    
    figure(3), hold on 
    bins = -180:5:180;
    histogram(rad2deg(myDiff),bins)
end
return 

mean(rad2deg(mnRCD))

adjustfigurefont('Helvetica',14)
xlim([-180 180])
xlabel('Rate of Change in Direction (^o/10 s)')
print('RCD_NARW_BoF','-dpng','-r300')

% compare between dives and surfacings
circ_wwtest(alls(:,1),alld(:,1))

% get NF from NARW_totalVolume
NF =     [6     1
    2     2
    1     3
    2     3
    3     3
    20     4
    21     4
    1     5
    2     5
    3     5
    4     5
    5     5
    6     5
    1     7
    2     7
    3     7
    4     7
    15     8
    16     8
    17     8
    20     8];

% we want to compare between foraging and non-foraging dives
% find RCD in dives with same indices as NF
NFd_RCDind = zeros(length(alld),1);
for i = 1:length(tags)
    % make index for d_RCD non-foraging dives
    ii = find(alld(:,3) == i); % all RCD values for dive i
    if sum(ismember(NF(:,2),i)) > 0 % if there are non-foraging dives in the deployment
        % find NF dives in that record
        NFd = NF(NF(:,2) == i,1);
        % for all of those non-foraging dives
        for d = 1:length(NFd)
        NFi = find(alld(ii,2) == NFd(d));
        NFd_RCDind(ii(NFi)) = 1;
        end
    end
end

% remove the 10 dives from tag with no .wav files
d_RCD = d_RCD([1:117 128:end],:);
s_RCD = s_RCD([1:117 128:end],:);

% compare the mean RCD between those 
