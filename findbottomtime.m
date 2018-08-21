function [frst,lst] = findbottomtime(pitch,fs,th)
% find bottom time of foraging dive based on pitch angle
% inputs:
% pitch = pitch during dive 
% th = pitch threshold in degrees, default value = 5 

if nargin < 3
    th = 0;
end
if max(pitch) < 40 
    disp ('check pitch units -- please input in degrees') 
    frst = NaN; lst = NaN; 
    return 
end

% remove first and last few seconds of dive to eliminate any surface values
frst = find((pitch(10:end-10)) > th,1,'first');
% find last 
lst = find(pitch(10:end-10) < th,1,'last');

% plot to check 
%figure(100), hold on 
%plot(pitch)
%plot(frst+10,abs(pitch(frst+10)),'*')
%plot(lst+10,abs(pitch(lst+10)),'*')

frst = frst+10; lst = lst+10; % fix indices for output