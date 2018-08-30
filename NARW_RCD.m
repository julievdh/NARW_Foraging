% NARW_RCD
% obtain rate of change in direction every 10 s 


% load prh
load('NARW_foraging_tags')
ID = 8; loadprh(tags{ID})

% downsample everything to every 10 seconds 
[pf,qf] = rat(0.1/fs,0.0001); % obtain resampling factors
Aw_rs = resample(Aw,pf,qf);
Mw_rs = resample(Mw,pf,qf);
[pitch_rs,roll_rs] = a2pr(Aw_rs); 
head_rs = m2h(Mw_rs,pitch_rs,roll_rs); 

figure, hold on
plott(head_rs,0.1,'.') % downsampled and recomputed data
plott(head,fs) % original data

% diff 
myDiff=diff(head_rs); 
myDiff(myDiff>pi)=myDiff(myDiff>pi)-2*pi;
myDiff(myDiff<-pi)=myDiff(myDiff<-pi)+2*pi;

% get new indices for dives for down-sampled data
T = finddives(p,fs,50,1);
t_rs = (1:length(head_rs))/0.1; % time vector for downsampled series
% find nearest values for start and end
for i = 1:size(T,1)
    st = nearest(t_rs',T(i,1));
    ed = nearest(t_rs',T(i,2)); 
    d_RCD(i,1:2) = [mean(myDiff(st:ed)) std(myDiff(st:ed))]; % mean/STD RCD in dive
    figure(3), rose(myDiff(st:ed))
end
for i = 1:size(T,1)-1
    st = nearest(t_rs',T(i,2)); % end of one dive
    ed = nearest(t_rs',T(i+1,1)); % start of next dive
    s_RCD(i,1:2) = [mean(myDiff(st:ed)) std(myDiff(st:ed))]; % mean/STD RCD at surface
    figure(4), rose(myDiff(st:ed))
end

% plot pitch track with coloured RCD just to check 
figure
xx = [ptrack(1:50:end-50,1) ptrack(1:50:end-50,1)]; % x coords, downsampled
yy = [ptrack(1:50:end-50,2) ptrack(1:50:end-50,2)]; % y coords, downsampled
zz = zeros(size(xx));
cc = [myDiff myDiff];
hs = surf(xx,yy,zz,cc,'EdgeColor','Interp','LineWidth',3);
view(2), colorbar, caxis([-pi/4 pi/4])
    
    
