function dur = gettagdur(tag)
% get tag duration from sensor data
% input is tag id 
% output is duration of sensor data from deployment, in seconds 
% julie van der Hoop August 2018 
loadprh(tag,'p','fs')

dur = length(p)/fs; 