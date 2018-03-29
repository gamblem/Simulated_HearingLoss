% This script was created to simulate what a person with severe hearingloss
% above 1k Hz hears. 
% Please note: that this was created to simulate a specific person's
% audiogram. The filter may not accurately describe others.
%
% Also- the lowpass filter was a matlab generated filter

%-------------------------------------------------------------------
%                   Recording Stimulus
%--------------------------------------------------------------------
%Record Sound
fs=48000; % Sampling Rate
recObj = audiorecorder(fs,16,1);

%Indicate in the command window- Ready to record?
prompt = 'Press enter when ready to Record? ';
str = input(prompt,'s');
if isempty(str)
    str = 'Y';
end

%Actual recording
disp('Start Speaking')
recordblocking(recObj, 16)% 15 seconds of recording 
disp('End of recording')

% cut off the first second to remove recording artifact;
x=getaudiodata(recObj);
x=x(fs:end-1); 


% -------------------------------------------------------------------
%                Plot Speech
%--------------------------------------------------------------------

prompt = 'Plot Original Speech? Y/N: ';
str = input(prompt,'s');
if strcmp(str,'y')==1 || strcmp(str,'Y')==1
    % Plotting the original Speech
    time=(length(x)/fs);
    t=0:1/fs:(time-1/fs);
    figure;plot(t,x);
     title('Original Recorded Speech')
    xlabel('Time (ms)')
elseif strcmp(str,'n')==1 || strcmp(str,'N')==1  
end


%-------------------------------------------------------------------
%               Play back of original Speech
%--------------------------------------------------------------------

prompt = 'Play Original Speech? Y/N: ';
str = input(prompt,'s');
if strcmp(str,'y')==1 || strcmp(str,'Y')==1  
    %Playing the original sound
    sound(x,fs);
elseif strcmp(str,'n')==1 || strcmp(str,'N')==1  
end


% -------------------------------------------------------------------
%             % Plot The Frequency Content Of original Speech
%--------------------------------------------------------------------


NFFT=fs*2;
X=fftshift(fft(x,NFFT)); % Fast Fourier Transform
p=(length(X))/2;
Y=abs(X);
nVals=fs*(0:NFFT/2-1)/NFFT;

prompt = 'Plot Frequency Content of Recorded Speech? Y/N: ';
str = input(prompt,'s');
if strcmp(str,'y')==1 || strcmp(str,'Y')==1  
    % Plot The Frequency Content Of original Speech
    figure;plot(nVals,Y(p:end-1));
    title('Frequency Content of Recorded Speech')
    set(gca, 'Ylim', [0 40])
    set(gca, 'XLim',[0 3000]);
    xlabel('Frequency Hz')
    hold on
elseif strcmp(str,'n')==1 || strcmp(str,'N')==1  
end

% -------------------------------------------------------------------
%             % Plot The Filter Response
%--------------------------------------------------------------------

%Load low pass filter created
load('lpFilt');

prompt = 'Plot Filter? Y/N: ';
str = input(prompt,'s');
if strcmp(str,'y')==1 || strcmp(str,'Y')==1  
    %Plot filter response Filter response
    mag=(freqz(lpFilt,512));
    plot(((1:512)/512)*(fs/2),((20*log10(abs(mag(1:512)))+160)*.35));
    set(gca, 'XLim',[0 3000]);  
elseif strcmp(str,'n')==1 || strcmp(str,'N')==1  
end

% -------------------------------------------------------------------
%             % Filter Speech and plot filtered frequency Content
%--------------------------------------------------------------------

%Filter the sounds out (50% cutoff at 1000)
[xfilt]=lpfiltData(x);

NFFT=fs*2;
Xfilt=fftshift(fft(xfilt,NFFT)); % Fast Fourier Transform of filtered speech
p=(length(Xfilt))/2;
Yfilt=abs(Xfilt);
nVals=fs*(0:NFFT/2-1)/NFFT;

prompt = 'Plot Frequency Content of Filtered Speech? Y/N: ';
str = input(prompt,'s');
if strcmp(str,'y')==1 || strcmp(str,'Y')==1  
    % Plot The Frequency Content Of the Filtered  Speech
    figure;plot(nVals,Yfilt(p:end-1));
    title('Frequency content of filtered speech')
    set(gca, 'Ylim', [0 40])
    set(gca, 'XLim',[0 3000]);
    xlabel('Frequency Hz');
elseif strcmp(str,'n')==1 || strcmp(str,'N')==1  
end


% -------------------------------------------------------------------
%             % Plot Filtered and Original Speech
%--------------------------------------------------------------------
prompt = 'Plot Original & Filtered Speech? Y/N: ';
str = input(prompt,'s');
if strcmp(str,'y')==1 || strcmp(str,'Y')==1 
    %Plot Filtered and Original speech
    figure;plot(t*1000,x); %Original Speech
    hold on
    plot(t*1000,xfilt); % Filtered Speech
    title('Recorded Speech')
    xlabel('Time (ms)')
    legend('Original Speech','Filtered Speech')
elseif strcmp(str,'n')==1 || strcmp(str,'N')==1  
end

% 
% -------------------------------------------------------------------
%             % Play Filtered Speech
%--------------------------------------------------------------------

prompt = 'Play Filtered Speech? Y/N: ';
str = input(prompt,'s');
if strcmp(str,'y')==1 || strcmp(str,'Y')==1  
   %Play Filtered Speech
    sound(xfilt,fs);
elseif strcmp(str,'n')==1 || strcmp(str,'N')==1  
end



%




