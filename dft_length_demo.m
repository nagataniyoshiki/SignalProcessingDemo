%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DFT Length Demo for Applied Electronic Engineering Class
%  (compatible with Matlab/Octave)
%    by Yoshiki NAGATANI, Kobe City College of Technology
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170725: First version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% Edit this part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Original Signal
fs = 8000;   % Sampling rate [Hz]
Nmin = 8;    % Minimum number of samples [points]
Nmax = 1200; % Maximum number of samples [points]

amp1  = 0.200;  % Signal1: Amplitude [arb.]
freq1 = 345.0;  % Signal1: Frequency [Hz]

amp2  = 0.800;  % Signal2: Amplitude [arb.]
freq2 = 456.0;  % Signal2: Frequency [Hz]

Ninc  = 1.1;   % increment of N [ratio]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prepare figure window
fig1 = figure;
set(fig1,'Name','DFT Length Demo','position',[10 100 1900 900]);

dt = 1.0/fs;

% Time axes
t = [0:Nmax-1]*dt;

% Signal
Sig = amp1*sin(2*pi()*freq1*t) + amp2*sin(2*pi()*freq2*t);

timeaxis = [0 (Nmax-1)*dt*1000 -abs((amp1+amp2)*1.1) abs((amp1+amp2)*1.1)];
freqaxis = [0 fs -90 50];

N = Nmin;

while Nmin <= N && N < Nmax

    Sig_Hann = Sig(1:N).*hanning(N)';
    
    % Plot waveform
    subplot(2,1,1);
    hold off;
    plot(t*1000,Sig,'k-');
    hold on;
    plot(t(1:N)*1000,hanning(N'),'g-');
    plot(t(1:N)*1000,-hanning(N'),'g-');
    plot(t(1:N)*1000,Sig_Hann,'bo-');
    grid on;
    axis(timeaxis);
    title(sprintf('Original signal ( signal: %d Hz & %d Hz @ fs = %d Hz ) : N = %d points ==> Length = %.2f ms',round(freq1),round(freq2),round(fs),round(N),N*dt*1000));
    ylabel('Amplitude');
    xlabel('Time [ms]');

    % Plot spectrum (Continuous)
    f = [0:round(N)-1]/(round(N)*dt);
    subplot(2,1,2);
    stem(f,20*log10(abs(fft(Sig_Hann))),'bo-','BaseValue',-100);
    grid on;
    axis(freqaxis);
    title(sprintf('Amplitude Spectrum of the Original signal with Hann window ( frequency resolution df = %.2f Hz )',1/(N*dt)));
    ylabel('Amplitude Spectrum [dB]');
    xlabel('Frequency [Hz]');
    drawnow;

    % Play sound
    sound([zeros(1,0.1*fs) Sig_Hann/((amp1+amp2)*1.1) zeros(1,0.1*fs)],fs);
    pause(N*dt+0.2);
    
    % Increase or decrease N
    if Ninc > 1.0
        N = ceil(N * Ninc);
        if N > Nmax
            Ninc = 1/Ninc;
        end
    end
    if Ninc < 1.0
        N = floor(N * Ninc);
    end

end
