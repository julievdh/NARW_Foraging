% Functional Ecology Revision Calculations

%% How much volume is 9 million copepods? 
% one copepod = 2 - 4 mm^3
cop_vol_low = 9E6*2;
cop_vol_high = 9E6*4;
% convert mm^3 to m^3 
cop_vol_low*1E-9
cop_vol_high*1E-9

%% What makes the biggest difference? 

gape = 1:0.1:2.0; 
speed = 1.1; 
frate = gape*speed; 
figure(1), clf, hold on 
plot(gape,frate)

speed = 0.7:0.1:1.5; 
gape = 1.2; 
frate = gape*speed; 
plot(speed,frate)
plot([0.6 2],[0.6 2],'k')

figure(2)
gape = 0.9:0.1:1.9;
speed = 0.7:0.1:1.5;
frate = gape'*speed; 
imagesc(frate)