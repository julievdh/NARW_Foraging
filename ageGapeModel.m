% NARW mouth gape model test
for whaleAge = 1:20; 

lnth = 1011.033+320.501*log10(whaleAge); % MOORE ET AL 2004
lnth = lnth/100;

[width,stations] = bodywidth(lnth);

snt(whaleAge) = width(2); % fix this relationship but you get the idea

end

figure(20), clf, hold on, plot(snt)

A = (snt.^2)./2;
plot(A)
xlabel('Age (years)'), ylabel({'Head Width (m)'; 'Gape Area (m^2)'})