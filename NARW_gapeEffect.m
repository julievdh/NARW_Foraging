% gape effect

ID = 7;
tag = tags{ID};

% import flow speed for the tag
load(['/Users/julievanderhoop/Dropbox (Personal)/tag/tagdata/' tag '_flowspeed.mat'])

for i = 5 %:length(dive) % because first 4 dives are not foraging dives
    
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
        vperblock_12(:,k) = sum(frate2(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1))))));
    end
    vtot_var = sum(vperblock); 
    vtot_12 = sum(vperblock_12); 
end
