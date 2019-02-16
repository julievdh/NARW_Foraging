% data from Table 4 Moore et al 2005 Morphometry
lnth = [1030 760 1100 479 457 1090 412 1005 1360 473 1155 1266 1030 478 ...
    1415 513 1270 417 1259 455 1460 1370 1350 771 910 1455 1200 1100];
age = [NaN NaN 3 0 0 NaN 0 2 12 0 NaN 4 2.5 0 12 0 5 0 4 0 21 28 10 0 0 19 NaN 1];

% find Nans in age and remove 
ii = isnan(age); 
lnth(ii) = []; 
age(ii) = []; 
% remove age zero
ii = find(age ~= 0);


% plot
figure(1), clf, hold on 
plot(age,lnth,'o')
% plot Michael's Fit
whaleAge = 1:30;
lnthFit(whaleAge) = 1011.033+320.501*log10(whaleAge); % MOORE ET AL 2004
plot(whaleAge,lnthFit)

% fit
ft = fit(log10(age(ii)'),lnth(ii)','poly1');
% good, same fit as Michael's 

% prediction interval 
ci = predint(ft,log10(whaleAge));
plot(whaleAge,ci(:,1))
plot(whaleAge,ci(:,2))

