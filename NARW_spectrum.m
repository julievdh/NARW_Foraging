% define the constants
N = 1024 ;	% 1024 point FFT
T = 1 ;	% 5 second spectral averages
sens = -172 ;	% sensitivity of the recorder in dB re U/uPa
fname = 'eg231b01.wav' ; % 'noise_recording.wav' ;	% name of the file to process
cue = 0 ;	% time cue to start from in the wav file

SL = [] ;	% variable for storing results
t = [] ;		% variable for storing the time of each spectral average
[x,fs] = audioread(fname,[1 10]) ;	% dummy read to get the sampling rate, fs

% Now we are going to go through a long recording and compute the spectral 
% level of each successive 30 s segment. We will use a for-loop to do this: 

for k=1:780,		% just do 2 hours of data. Normally you would do the entire recording.
    [x,fs] = audioread(fname,1+fs*[cue cue+T]) ;	% read the next 30 seconds
    [sl,f] = spectrum_level(x(:,1),N,fs) ;	% do the spectrum level of this segment
    SL(:,end+1) = sl-sens ;		% add it to the results matrix
    t(k) = cue + T/2 ;	% store the centre time of each measurement
    cue = cue + T; 		% update cue and print it to the screen so you can see progress
end

% SL contains the 30 s spectral averages, one per column (check that the 
% size of SL makes sense - it should have N/2 rows, i.e., one half of the 
% FFT length, and 240 columns). What are the units of SL?

% You can plot SL as an image:
figure(1), clf, hold on
imagesc(t,f,SL), axis xy

% Like a spectrogram, the axes of this plot are time and frequency but now 
% each vertical line is a 30 s spectral average rather than a single FFT. 
% Put axis labels and a colorbar (with units) on your plot.
xlabel('Time (seconds)')
ylabel('Frequency (Hz)') 
h = colorbar; 
ylabel(h,'dB re 1 uPa^2/Hz') 
%%
loadprh('eg05_231b')
figure(2), clf, hold on 
plot((1:length(p))/fs,-p/10)
plot((1:length(p))/fs,pitch)
xlim([0 cue])
