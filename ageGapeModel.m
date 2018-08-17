% NARW mouth gape model test
for whaleAge = 1:20; 

lnth = 1011.033+320.501*log10(whaleAge); % MOORE ET AL 2004
lnth = lnth/100;

[width,stations] = bodywidth(lnth); % this is mesomorphic but I don't really like it for going across age stages. 
figure(19), hold on 
plot(stations, width)

snt(whaleAge) = width(1)*2; % fix this relationship but you get the idea

end

figure(20), clf, hold on, 
plot(snt)
A = (snt.^2)./2;
plot(A)

plot(1/12,0.68,'o','color',[0    0.4470    0.7410]) % width data for calves from Carolyn Miller
plot(3.5/12,1.01,'o','color',[0    0.4470    0.7410]) % width data for calves from Carolyn Miller 

plot(1/12,(0.68.^2)./2,'o','color',[    0.8500    0.3250    0.0980]) % area for calves 
plot(3.5/12,(1.01.^2)./2,'o','color',[    0.8500    0.3250    0.0980]) % are for calves 

xlabel('Age (years)'), ylabel({'Head Width (m)'; 'Gape Area (m^2)'})
adjustfigurefont

print('NARW_gape_length','-dpng','-r300')