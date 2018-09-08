% GoSL2018_rangetest
% dtag range test calculations

MacareuxLats = [48.56706901
48.56767897
48.57082
48.57386003];
MacareuxLons = [-63.87822004
-63.87746098
-63.87381099
-63.86937596];
%MacareuxTime = [2018-09-05T 21:38:23Z
%2018-09-05T 21:41:16Z
%2018-09-05T 21:58:39Z
%2018-09-05T 22:18:07Z]; 

CetusLats = [48.58585, 48.586067, 48.591583, 48.59698, 48.60038]; 
CetusLons = [-63.96682, -63.969683, -63.997117, -64.032, -64.0524]; 
% CetusTimes = 17:57:22, 17:58:29, 18:05:48, 18:12:35, 18:16:22

figure(1), clf, hold on
plot(MacareuxLons,MacareuxLats,'k^-'), plot(MacareuxLons(end),MacareuxLats(end),'k^','MarkerFaceColor','k')
plot(CetusLons,CetusLats,'r>-'), plot(CetusLons(end),CetusLats(end),'k>','MarkerFaceColor','r')

% calculate distances, working backwards
lldistkm([MacareuxLats(4) MacareuxLons(4)], [CetusLats(end) CetusLons(end)])/1.852 % nm, lost d3 on large antenna
lldistkm([MacareuxLats(4) MacareuxLons(4)], [CetusLats(4) CetusLons(4)])/1.852 % lost d3 on handheld
lldistkm([MacareuxLats(3) MacareuxLons(3)], [CetusLats(3) CetusLons(3)])/1.852 % lost d4 on large antenna
lldistkm([MacareuxLats(3) MacareuxLons(3)], [CetusLats(2) CetusLons(2)])/1.852 % lost d3 on handheld

