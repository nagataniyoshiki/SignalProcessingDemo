%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sampling Theorem Demo for Applied Electronic Engineering Class
%  (compatible with Matlab/Octave)
%    by Yoshiki NAGATANI, Kobe City College of Technology
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170724: First version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% Edit this part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Original Signal
fs = 8000;  % Sampling rate [Hz]
N  = 800;   % Number of points [points]

amp  = 1.000;    % Amplitude of signal [arb.]
freqmin =  200;  % Minimum frequency of signal [Hz]
freqmax = 7800;  % Maximum frequency of signal [Hz]

freqinc  = 50; % increment of frequency [Hz]
UpsamplingRatio = 16;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prepare figure window
fig1 = figure;
set(fig1,'Name','Sampling Theorem Demo','position',[10 100 1900 900]);

dt = 1/fs;

% Time axes
t1 = [0:N-1]*dt;
t2 = [0:(N*UpsamplingRatio)-1]*(dt/UpsamplingRatio);

% Frequency axis
f = [-N*2:N*2-1]/(N*dt);

timeaxis = [0 (N-1)*dt*1000/16 -abs(amp*1.1) abs(amp*1.1)];
freqaxis = [-fs*2/1000 fs*2/1000 -40 60];

freq = freqmin;

while freq <= freqmax

    % Signal
    Sig1 = amp*sin(2*pi()*freq*t1);
    Sig2 = amp*sin(2*pi()*freq*t2);
   
    Sig1Hann = Sig1.*hann(N)';
    
    % Plot waveform
    subplot(2,1,1);
    hold off;
    plot(t2*1000,Sig2,'b-');
    hold on;
    stem(t1*1000,Sig1,'ko--');
    plot(t1*1000,Sig1,'k-');
    grid on;
    grid minor;
    axis(timeaxis);
    title(sprintf('Original signal and the sampled signal (signal: %d Hz @ fs = %d Hz )',round(freq),round(fs)));
    ylabel('Amplitude');
    xlabel('Time [ms]');

    % Plot spectrum
    subplot(2,1,2);
    Sig1FFTdB = 20*log10(abs(fft(Sig1Hann)));
    hold off;
    stem(freq/1000,100,'b--','BaseValue',-100);
    hold on;
    stem((fs-freq)/1000,100,'r--','BaseValue',-100);
    stem([-fs 0 fs]/1000,[1 1 1]*100,'k-','BaseValue',-100);
    stem([-3*fs/2 -fs/2 fs/2 3*fs/2]/1000,[1 1 1 1]*100,'k--','BaseValue',-100);
    plot(f/1000,[Sig1FFTdB Sig1FFTdB Sig1FFTdB Sig1FFTdB],'k-');
    grid on;
    grid minor;
    axis(freqaxis);
    title(sprintf('Amplitude Spectrum of the sampled signal with Hann window'));
    ylabel('Amplitude Spectrum [dB]');
    xlabel('Frequency [kHz]');
    xtics = [-4:1:4]*fs/2/1000;
    set(gca,'XTick',xtics);
    drawnow;

    % Play sound
    sound(Sig1Hann/(amp*1.1),fs);
    pause(N*dt+0.1);
    
    % Increase or decrease frequency
    if (fs/2*0.95 < freq && freq < fs/2*1.05)
        freq = freq + freqinc/5; % Slow down
    else   
        freq = freq + freqinc;
    end
    
end

