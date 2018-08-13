% shark filter feeding
warning off 
% Mota calculations -- 
% With a flow velocity at the mouth of 0.99 m/s (90.4% of 1.1 m/s) the
% smaller shark would filter 0.0914m2 ×0.99 m/s or 0.0905m3/s of
% water = 326m3/h, and the larger shark would filter 614m3/h. With
% an average plankton biomass of 4.5 g/m3 at the feeding sites, the
% sharks would, on average, ingest 1467 and 2763 g of plankton per
% hour

vel = 0.99; % m/s
gape = 0.0914; % m^2

volume = vel*gape; % m^3/s 
conc = 4.5; % g/m^3

plankvol = conc*volume; % g/s
plankvol*3600 % g/hour

%% for Nelson 2007 passive feeding
% close mouth 'every few minutes'
% passive feeding is at low plankton densities

vel = 0.3; % m/s
density = 5.9E3; % individuals/m3 
gape = 0.108; % m^2

prate = vel*density*gape; % individuals/s 
prate*2*60 % every few minutes -- number of individuals filtered before closure

%% basking shark -- Sims 
gape = 0.4; % m^2
vel = 0.85; % m/s 
density = 1.45/1000; %g m-^3

prate = vel*density*gape; % kg/s 
prate*60 % every 30-60 seconds -- number of kg filtered before closure 

%% bowhead - Simon et al. 
gape = 4.23; % m^2
speed = 0.75; % m/s

volrate = gape*speed; 
% 2.5 minutes 
volrate*2.5*60 % resulting volume filtered per "clear" 

dens = 0.001; % kg m^3
volrate*2.5*60*dens % how many kg per swallow 
%% right whale with our data
load('/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/eg05_230a_flowspeed.mat')

gape = 1.2; % m^2
speed = 0.5:0.3:2.0; % m/s
volrate = gape*speed; 

% volrate*45 %if clearing is every 45 seconds 

dens = 0.01; % kg m^3 

bolus = volrate*45*dens; % how many kg per swallow 

% if the limit is the swallow bolus size 
% then there swallow will be at different densities 
% let's say 

bolus = 0.5; % half a kg 
densities = 0.001:0.001:0.01; 
for i = 1:length(volrate)
cleartime(i,:) = bolus./densities/volrate(i); 
end

figure(10), clf, hold on 
c = viridis(size(cleartime,1)); % color by speeds
for i = 1:size(cleartime,1)
plot(densities, cleartime(i,:),'color',c(i,:))
end
xlabel('Density (kg/m^3)'), ylabel('Inter-Pause Interval (sec)'),
C = regexp(sprintf('speed=%.1f#', speed), '#', 'split');
legend(C)

figure(11), clf, hold on
c = viridis(size(cleartime,2)); % color by densities
for i = 1:size(cleartime,2)
plot(speed, cleartime(:,i),'color',c(i,:))
end
xlabel('Swimming Speed (m/s)'), ylabel('Clearing Time (sec)')
C = regexp(sprintf('density=%.3f#', densities), '#', 'split');
legend(C)

% load sample data from eg05_219a
% load('eg05_219a_flowspeed.mat')
for i = 1:length(dive) % or 1:19 or 1:4 7:length(dive)
    if isempty(dive(i).mnspeedperblock) == 0
plot(dive(i).mnspeedperblock,dive(i).stops(:,2)-dive(i).stops(:,1),'ko')
    end
pause
end

%% as calcs above: 
gape = 1.2; % m^2
speed = [dive(:).mnspeedperblock]; % m/s

for i = 1:length(dive)
     if isempty(dive(i).stops) == 0
    dive(i).clearingtime = [dive(i).stops(:,2)-dive(i).stops(:,1)]';
     end
end

dur = [dive(:).clearingtime]; 

volrate = gape*speed; 
vol = gape.*speed.*dur; % m^3 per mouth closure

dens = 0.01; % kg m^3
mass = vol*dens; 
figure(18), hold on 
plot(mass)
plot([0 150],[4.23*0.75*2.5*60*0.0001 4.23*0.75*2.5*60*0.0001])

%% 