% traveltime and filtered volume

% plot time versus volume
figure(6), clf
% for a dive
for k = 1:size(T,1); 
dcue = T(k,1):T(k,2); % cues for that dive

% dive(k).btm(1) is the first at depth, so descent is until then
subplot('position',[0.07 0.1 0.55 0.8]), hold on
if isempty(dive(k).btm) == 0 
plot([0 dive(k).btm(1)],[0 0])
% add stops
plot([dive(k).stops(1,1)-dcue(1) dive(k).stops(1,2)-dcue(1)],[0 dive(k).vperblock(1)]) % first starts at zero
for j = 2:size(dive(k).stops,1)
plot([dive(k).stops(j,1)-dcue(1) dive(k).stops(j,2)-dcue(1)],[sum(dive(k).vperblock(1:j-1)) sum(dive(k).vperblock(1:j))])
end
plot([dive(k).stops(j,2)-dcue(1) dcue(end)-dcue(1)],[sum(dive(k).vperblock(1:j)) sum(dive(k).vperblock(1:j))]) % first starts at zero
end 
if isempty(dive(k).btm) == 1
    plot([0 T(k,2)-T(k,1)],[0 0])
end
plot(-p(dcue*fs))

% plot total volume filtered and dive duration 
subplot('position',[0.65 0.1 0.3 0.8]), hold on
if isempty(dive(k).btm) == 0
plot(T(k,2)-T(k,1),sum(dive(k).vperblock(1:j)),'o')
else if isempty(dive(k).btm) == 1
plot(T(k,2)-T(k,1),0,'o')
    end
end

pause
end


xlabel('Time (seconds)'), ylabel('Depth (m)        Volume Filtered (m^3)')

%% also plot all through time
figure(7), clf, hold on 
for k = 1:size(T,1);
dcue = T(k,1):T(k,2); % cues for that dive

if isempty(dive(k).btm) == 0 
plot([dcue(1) dive(k).btm(1)+dcue(1)],[0 0])
% add stops
plot([dive(k).stops(1,1) dive(k).stops(1,2)],[0 dive(k).vperblock(1)]) % first starts at zero
for j = 2:size(dive(k).stops,1)
plot([dive(k).stops(j,1) dive(k).stops(j,2)],[sum(dive(k).vperblock(1:j-1)) sum(dive(k).vperblock(1:j))])
end
plot([dive(k).stops(j,2) dcue(end)],[sum(dive(k).vperblock(1:j)) sum(dive(k).vperblock(1:j))]) % first starts at zero
end 
if isempty(dive(k).btm) == 1
    plot([dcue(1) dcue(end)],[0 0])
end
plot(dcue,-p(dcue*fs))
end

xlabel('Time (seconds)'), ylabel('Depth (m)        Volume Filtered (m^3)')