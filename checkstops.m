pdeg = rad2deg(pitch);

for j = 1:size(T,1); % have to make some rule on dive shape
    %%
    q1 = [];
    
    figure(9), clf, hold on % for this example
    dcue = T(j,1):T(j,2); % time in seconds
    % plot signals: depth, pitch, etc
    plot(dcue/60, -p(round(dcue*fs)),'color',[0.7 0.7 0.7])
    
    % plot selected stops
    btm = dive(j).btm;
    gape = getgape(tags{1,6});
    flowEst = dive(j).flowEst;
    plot(dcue/60,pdeg(round(dcue*fs)),'b') % plot pitch through time
    plot(dcue(btm)/60,ph(round(dcue(btm)*fs))*100) % plot pitch deviation signal during bottom
    
    stops = dive(j).stops;
    if isempty(dive(j).stops) ~= 1
        plot(stops(:,2)/60,zeros(length(stops(:,2)),1),'r*') % plot selected stops
        plot(stops(:,1)/60,zeros(length(stops(:,2)),1),'g*')
        
        % ask if happy
        q1 = input('happy with selections?');
        while q1 == 0
            disp('select start')
            figure(9), temp1 = ginput(1); % click on screen
            % find nearest glide selected by algorithm
            plot(temp1(1),0,'g*')
            disp('select end')
            temp2 = ginput(1);
            plot(temp2(1),0,'r*')
            stops(end+1,:) = [temp1(1)*60 temp2(1)*60];
            % ask if happy
            q1 = input('happy with selections?');
        end
        % are any overlapping? stops start shouldn't overlap previous start's stop
        diffs = stops(1:end-1,2)-stops(2:end,1);
        stops(find(diffs>0)+1,1) = stops(find(diffs>0)+1,1) + diffs(diffs>0);
       if ~isempty(find(dive(j).stops(:,2)-dive(j).stops(:,1) < 3))
       break 
       end
       
        
        dive(j).stops = sort(stops);
        
        % recompute volume
        frate = gape*flowEst(btm); % filtration rate = gape*flow speed
        vol = cumsum(frate(~isinf(frate))); % integrate rate for filtered volume
        vperblock = []; mnspeedperblock = [];
        for k = 1:size(stops,1)
            vperblock(:,k) = sum(frate(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1))))));
            mnspeedperblock(:,k) = mean(flowEst(stops(k,1)-dcue(1):stops(k,2)-dcue(1)));
            % check
            % plot(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1)))),frate(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1))))))
        end
        dive(j).vperblock = vperblock;
        dive(j).mnspeedperblock = mnspeedperblock;
        dive(j).btm = btm;
        
        
    end
end

