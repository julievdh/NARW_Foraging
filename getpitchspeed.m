
for i = 1:length(tags)
    
    phs_spd = [tags{i,7}];
    phs_ptch = [tags{i,8}];
    if i == 5
        NFdive_spd(i,1:2) = nanmean(phs_spd([tags{i,9}],1:2));
        Fdive_spd(i,1:3) = NaN;
    else     if sum([tags{i,9}]) >= 0
        NFdive_spd(i,:) = nanmean(phs_spd([tags{i,9}],1:3));
        Fdive_spd(i,:) = nanmean(phs_spd(~[tags{i,9}],1:size(phs_spd,2)));
        end
    end
    
    if sum([tags{i,9}]) == 1
        NFdive_spd(i,:) = phs_spd([tags{i,9}],1:3);
    end

    
    if sum([tags{i,9}]) > 0
        NFdive_ptch(i,:) = nanmean(phs_ptch([tags{i,9}],1:2));
    else
        NFdive_ptch(i,1:2) = [NaN NaN];
    end
    
    Fdive_ptch(i,:) = nanmean(phs_ptch(~[tags{i,9}],1:2));
end

% replace zeros with NaNs
Fdive_spd(Fdive_spd == 0) = NaN; 
Fdive_ptch(Fdive_ptch == 0) = NaN;
NFdive_ptch(NFdive_ptch == 0) = NaN;
NFdive_spd(NFdive_spd == 0) = NaN;

% take NaN mean of each 
nanmean(Fdive_spd)
nanstd(Fdive_spd)