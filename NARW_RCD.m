function RCD = NARW_RCD(head,fs)
% obtain rate of change in direction every 10 s 
% inputs are:
%   head = whale heading (radians)
%   fs = sampling rate of sensor data
% outputs are: 
%   RCD = rate of change in direction 

% 1. decimate heading to 10 seconds (0.1 Hz)
 [p,q] = rat(0.1/fs,0.0001); % obtain resampling factors
 head_rs = resample(head,p,q); 
% plot to check 
figure(1), clf, hold on 
plott(head,fs)
plott(head_rs,0.1,'.-')

% 2. calculate difference between heading at those intervals
myDiff=diff(head_rs);
