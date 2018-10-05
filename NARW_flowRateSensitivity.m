% NARW_flowratesensitivity

cis = predint(c,log10(medFN(i,:)));
% test figure in case
figure(1), clf, hold on
plot(flowEst(btm))
plot(cis(btm,:))

% calculate flow rate with average and low and high estimates
frate = gape*flowEst(btm); % filtration rate = gape*flow speed
vol = cumsum(frate(~isinf(frate))); % integrate rate for filtered volume
figure(10), clf, hold on
plot(dcue(btm(~isinf(frate)))-dcue(btm(1)),vol), xlabel('Seconds into dive'), ylabel('Cumulative Filtered Volume (m^3)')
plot(stops(:,2)-dcue(btm(1)),vol(round(stops(:,2)-dcue(btm(1)))),'o')
frate_low = gape*cis(btm,1);
frate_hi = gape*cis(btm,2);
vol_low = cumsum(frate_low(~isinf(frate_low))); % integrate rate for filtered volume
vol_hi = cumsum(frate_hi(~isinf(frate_hi))); % integrate rate for filtered volume

plot(dcue(btm(~isinf(frate)))-dcue(btm(1)),[vol_low vol_hi])

% calculate volumes
vperblock = []; mnspeedperblock = [];
for k = 1:size(stops,1)
    vperblock(:,k) = sum(frate(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1))))));
    vperblock_lo(:,k) = sum(frate_low(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1))))));
    vperblock_hi(:,k) = sum(frate_hi(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1))))));
    
    % mnspeedperblock(:,k) = mean(flowEst(stops(k,1)-dcue(1):stops(k,2)-dcue(1)));
    % check
    % plot(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1)))),frate(round(stops(k,1)-dcue(btm(1)):round(stops(k,2)-dcue(btm(1))))))
end

figure(11), hold on 
plot(vperblock)
plot([vperblock_lo' vperblock_hi'])

[sum(vperblock) sum(vperblock_lo) sum(vperblock_hi)]



