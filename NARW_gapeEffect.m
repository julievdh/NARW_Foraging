% gape effect
load('NARW_foraging_tags')
for ID = 1:8;
tag = tags{ID};

% import flow speed for the tag
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])
d2after = tags{ID,9}; 
for i = d2after' %
    dcue = T(i,1):T(i,2); % cues for that dive
    
    % set up variables from stored
    stops = dive(i).stops;
    flowEst = dive(i).flowEst;
    btm = dive(i).btm;
    vperblock = dive(i).vperblock;
    
    gape = getgape(tags{ID,6});
    
    frate_var = gape*flowEst;
    frate_12 = 1.2*flowEst;
    
    vperblock_12 = [];
    for k = 1:size(stops,1)
        vperblock_12(:,k) = sum(frate_12(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1))))));
    end
    vtot_var(:,i) = sum(vperblock); % vperdive with estimated gape
    vtot_12(:,i) = sum(vperblock_12); %vperdive with 1.2m2 gape
end

figure(1), hold on 
plot(vtot_var), plot(vtot_12)
xlabel('Dive Number'), ylabel('Total Volume Filtered (m^3)')
adjustfigurefont

% values for paper
% actual filtered volume with variable m^2 gape
round([mean(vtot_var(d2after)) std(vtot_var(d2after))])
% if assume 1.2 m^2 
round([mean(vtot_12(d2after)) std(vtot_12(d2after))])
% difference in filtered volume assuming 1.2 m^3 
[mean(vtot_var(d2after)-vtot_12(d2after)) std(vtot_var(d2after)-vtot_12(d2after))]
% percent difference 
pdiff = (mean(vtot_12(d2after))-mean(vtot_var(d2after)))/mean(vtot_var(d2after)); 

figure(111), hold on 
plot(gape,pdiff,'ko')

clear btm stops vperblock 
end
