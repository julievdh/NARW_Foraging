function [whaleDf,U] = getdrag(whaleAge,lnth)
% get drag force on NARW of given age or length across range of speeds
% inputs: whaleAge = age of whale
%         lnth = length of whale (cm) if known
% 

if nargin < 2 
    lnth = MooreAgeLength(whaleAge); % length in cm 
    lnth = lnth/100; % change lnth to m 
end

% estimated whale mass
% Moore et al. 2005 weight at age relationship (NOT FORTUNE)
M = 3169.39+1773.666*whaleAge; 


% speed, ms-1
U = 0.5:0.1:2.5;

% kinematic viscosity of seawater, m2s-1
v = 10^-6;

% calculate reynolds number
Re = (lnth*U)./v;

% coefficient of friction [Eqn. 4]
Cf = 0.072*Re.^(-1/5);

% seawater density
rho = 1025;

% estimated wetted surface area
Sw = 0.08*M.^0.65;

% max diameter of body, m
% Fortune et al. 2012, width to length relationship from photogrammetry
% (NOT NECROPSY)
d = (38.63+0.21*lnth*100)/100;

% Fineness Ratio
FR = lnth./d;

% drag augmentation factor for oscillation, = 1-3 as per Frank Fish, pers comm
k = 1.5;
% appendages
g = 1.3;

for i = 1:length(Cf)
    whaleCD0(:,i) = Cf(:,i).*(1+1.5*(d./lnth).^(3/2) + 7*(d./lnth).^3);
    
    % calculate drag force on the whale body (N)
    whaleDf(:,i) = (1/2)*rho*(U(i).^2)*Sw.*whaleCD0(:,i)*g*k;
    whaleDf_lower(:,i) = whaleDf(:,i)*0.9;
    whaleDf_upper(:,i) = whaleDf(:,i)*1.1; % error for oscillation: use 1.35 to 1.65
    
    % back-calculate Cd
    whaleCD(:,i) = (2*whaleDf(:,i))./(rho*(U(i).^2)*Sw);
    
end