% gape effect
load('NARW_foraging_tags')
ID = 7;
tag = tags{ID};

% import flow speed for the tag
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])

for i = 5:length(dive) % because first 4 dives are not foraging dives
    
    dcue = T(i,1):T(i,2); % cues for that dive
    
    % set up variables from stored
    stops = dive(i).stops;
    flowEst = dive(i).flowEst;
    btm = dive(i).btm;
    vperblock = dive(i).vperblock;
    
    gape = getgape(tags{ID,6});
    
    frate_var = gape*flowEst(btm);
    frate_12 = 1.2*flowEst(btm);
    
    vperblock_12 = [];
    for k = 1:size(stops,1)
        vperblock_12(:,k) = sum(frate_12(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1))))));
    end
    vtot_var(:,i) = sum(vperblock); 
    vtot_12(:,i) = sum(vperblock_12); 
end

figure(1), hold on 
plot(vtot_var), plot(vtot_12)
xlabel('Dive Number'), ylabel('Total Volume Filtered (m^3)')
adjustfigurefont

% values for paper
% actual filtered volume with 1.6 m^2 gape
[mean(vtot_var(5:end)) std(vtot_var(5:end))]
% if assume 1.2 m^2 
[mean(vtot_12(5:end)) std(vtot_12(5:end))]
% difference in filtered volume assuming 1.2 m^3 
[mean(vtot_var(5:end)-vtot_12(5:end)) std(vtot_var(5:end)-vtot_12(5:end))]
% percent difference 
(mean(vtot_12(5:end))-mean(vtot_var(5:end)))/mean(vtot_var(5:end))