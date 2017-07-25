%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Averaging Demo on Improving SNR for Applied Electronic Engineering Class
%  (compatible with Matlab/Octave)
%    by Yoshiki NAGATANI, Kobe City College of Technology
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170725: First version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% Edit this part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Original Waveform
fs = 8000;   % Sampling rate [Hz]
N  = 512;    % Number of samples [points]

% Target signal
amp  = 1.000;  % Signal: Amplitude [arb.]
freq = 250.0;  % Signal: Frequency [Hz]
burst = 10;    % Signal: Number of waves [number]

% SNR
SNR_dB = 6.0;  % Signal-to-noise ratio [dB]

% Averaging number
AveN = 128;    % Number of averaging [times]

% Refresh
pause_s = 0.1;  % Refresh speed [s]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Time axes
dt = 1.0/fs;
t = [0:N-1]*dt;

% Frequency axes
df = 1/(N/fs);
f = [0:N-1]*df;

SNR_ratio = 10^(SNR_dB/20);

% Prepare figure window
fig1 = figure;
set(fig1,'Name','Averaging Demo on Improving SNR','position',[10 100 1900 900]);

% Create clean signal
Sig_clean = zeros(1,N);
Sig_clean(1:round(burst/freq*fs)) = amp * sin(2*pi()*freq*t(1:round(burst/freq*fs)) );

% Plot clean signal (waveform)
subplot(3,2,1);
plot(t,Sig_clean,'k-');
grid on;
axis([0 N/fs -amp*(1+1/SNR_ratio)*2.0 amp*(1+1/SNR_ratio)*2.0]);
title('Clean signal (target)');
ylabel('Amplitude');
xlabel('Time [s]');

% Plot clean signal (FFT)
Sig_clean_fft_dB = 20*log10(abs(fft(Sig_clean.*hanning(N)')));
Sig_clean_fft_dB_norm = Sig_clean_fft_dB - max(Sig_clean_fft_dB);
subplot(3,2,2);
plot(f,Sig_clean_fft_dB_norm,'k-');
grid on;
axis([0 N*df/2 -55 5]);
title('Clean signal (target)');
ylabel('Normalized Amplitude Spectrum [dB]');
xlabel('Frequency [Hz]');
drawnow;

% Add noise & averaging
Sig_sum = zeros(1,N);

for i=1:AveN
    % Create dirty signal
    Sig_dirty = Sig_clean + amp/SNR_ratio*randn(1,N);

    % Plot dirty signal (waveform)
    subplot(3,2,3);
    plot(t,Sig_dirty,'r-');
    grid on;
    axis([0 N/fs -amp*(1+1/SNR_ratio)*2.0 amp*(1+1/SNR_ratio)*2.0]);
    title(sprintf('Dirty signals with Gaussian noise : SNR = %d dB',round(SNR_dB)));
    ylabel('Amplitude');
    xlabel('Time [s]');

    % Plot dirty signal (FFT)
    Sig_dirty_fft_dB = 20*log10(abs(fft(Sig_dirty.*hanning(N)')));
    Sig_dirty_fft_dB_norm = Sig_dirty_fft_dB - max(Sig_clean_fft_dB);
    subplot(3,2,4);
    plot(f,Sig_dirty_fft_dB_norm,'r-');
    grid on;
    axis([0 N*df/2 -55 5]);
    title(sprintf('Dirty signals with Gaussian noise : SNR = %d dB',round(SNR_dB)));
    ylabel('Normalized Amplitude Spectrum [dB]');
    xlabel('Frequency [Hz]');

    % Averaging
    Sig_sum = Sig_sum + Sig_dirty;
    Sig_ave = Sig_sum / i;

    % Plot avaraged signal
    subplot(3,2,5);
    plot(t,Sig_ave,'b-');
    grid on;
    axis([0 N/fs -amp*(1+1/SNR_ratio)*2.0 amp*(1+1/SNR_ratio)*2.0]);
    title(sprintf('Averaged signal : %d / %d times',i,AveN));
    ylabel('Amplitude');
    xlabel('Time [s]');
    
    % Plot avaraged signal (FFT)
    Sig_ave_fft_dB = 20*log10(abs(fft(Sig_ave.*hanning(N)')));
    Sig_ave_fft_dB_norm = Sig_ave_fft_dB - max(Sig_clean_fft_dB);
    subplot(3,2,6);
    plot(f,Sig_ave_fft_dB_norm,'b-');
    grid on;
    axis([0 N*df/2 -55 5]);
    title(sprintf('Averaged signal : %d / %d times',i,AveN));
    ylabel('Normalized Amplitude Spectrum [dB]');
    xlabel('Frequency [Hz]');
    drawnow;
    
    if i==1
        pause(2.0);
    else
        pause(pause_s);
    end

end


