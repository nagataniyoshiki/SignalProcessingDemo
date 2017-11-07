///////////////////////////////////////////////////////////////////////////
// Averaging Demo on Improving SNR for Applied Electronic Engineering Class
//  (compatible with Scilab)
//    by Yoshiki NAGATANI, Kobe City College of Technology
//    https://github.com/nagataniyoshiki
// 
//   rev. 20170725: First version
//   rev. 20171107: Set the background color to white
///////////////////////////////////////////////////////////////////////////

clear;

// Edit this part ////////////////////////////////////////////////
// Original Waveform
fs = 8000;   // Sampling rate [Hz]
N  = 512;    // Number of samples [points]

// Target signal
amp  = 1.000;  // Signal: Amplitude [arb.]
freq = 250.0;  // Signal: Frequency [Hz]
burst = 10;    // Signal: Number of waves [number]

// SNR
SNR_dB = 6.0;  // Signal-to-noise ratio [dB]

// Averaging number
AveN = 128;    // Number of averaging [times]

// Refresh
pause_s = 0.1;  // Refresh speed [s]
///////////////////////////////////////////////////////////////////////////

// Time axes
dt = 1.0/fs;
t = [0:N-1]*dt;

// Frequency axes
df = 1/(N/fs);
f = [0:N-1]*df;

SNR_ratio = 10^(SNR_dB/20);

// Prepare figure window
fig1 = figure("Figure_name", "Averaging Demo on Improving SNR", "position", [0 0 1900 900], "BackgroundColor", [1 1 1]);
timeaxis = [0, -amp*(1+1/SNR_ratio)*2.0; N/fs, amp*(1+1/SNR_ratio)*2.0];
freqaxis = [0, -55; N*df/2, 5];

// Create clean signal
Sig_clean = zeros(1,N);
Sig_clean(1:round(burst/freq*fs)) = amp * sin(2*%pi*freq*t(1:round(burst/freq*fs)) );

// Plot clean signal (waveform)
drawlater();
subplot(3,2,1);
plot(t,Sig_clean,'k-');
xgrid(1, 1, 3);
ax=get("current_axes"); ax.data_bounds=timeaxis;
title('Clean signal (target)');
ylabel('Amplitude');
xlabel('Time [s]');

// Plot clean signal (FFT)
Sig_clean_fft_dB = 20*log10(abs(fft(Sig_clean.*window('hn',N))));
Sig_clean_fft_dB_norm = Sig_clean_fft_dB - max(Sig_clean_fft_dB);
subplot(3,2,2);
plot(f,Sig_clean_fft_dB_norm,'k-');
xgrid(1, 1, 3);
ax=get("current_axes"); ax.data_bounds=freqaxis;
title('Clean signal (target)');
ylabel('Normalized Amplitude Spectrum [dB]');
xlabel('Frequency [Hz]');
drawnow();

// Add noise & averaging
Sig_sum = zeros(1,N);

for i=1:AveN
    // Create dirty signal
    Sig_dirty = Sig_clean + amp/SNR_ratio*rand(1,N,"normal");

    // Plot dirty signal (waveform)
    drawlater();
    subplot(3,2,3);
    set(gca(),"auto_clear","on");
    plot(t,Sig_dirty,'r-');
    xgrid(1, 1, 3);
    ax=get("current_axes"); ax.data_bounds=timeaxis;
    title(sprintf('Dirty signals with Gaussian noise : SNR = %d dB',round(SNR_dB)));
    ylabel('Amplitude');
    xlabel('Time [s]');

    // Plot dirty signal (FFT)
    Sig_dirty_fft_dB = 20*log10(abs(fft(Sig_dirty.*window('hn',N))));
    Sig_dirty_fft_dB_norm = Sig_dirty_fft_dB - max(Sig_clean_fft_dB);
    subplot(3,2,4);
    set(gca(),"auto_clear","on");
    plot(f,Sig_dirty_fft_dB_norm,'r-');
    xgrid(1, 1, 3);
    ax=get("current_axes"); ax.data_bounds=freqaxis;
    title(sprintf('Dirty signals with Gaussian noise : SNR = %d dB',round(SNR_dB)));
    ylabel('Normalized Amplitude Spectrum [dB]');
    xlabel('Frequency [Hz]');

    // Averaging
    Sig_sum = Sig_sum + Sig_dirty;
    Sig_ave = Sig_sum / i;

    // Plot avaraged signal
    subplot(3,2,5);
    set(gca(),"auto_clear","on");
    plot(t,Sig_ave,'b-');
    xgrid(1, 1, 3);
    ax=get("current_axes"); ax.data_bounds=timeaxis;
    title(sprintf('Averaged signal : %d / %d times',i,AveN));
    ylabel('Amplitude');
    xlabel('Time [s]');
    
    // Plot avaraged signal (FFT)
    Sig_ave_fft_dB = 20*log10(abs(fft(Sig_ave.*window('hn',N))));
    Sig_ave_fft_dB_norm = Sig_ave_fft_dB - max(Sig_clean_fft_dB);
    subplot(3,2,6);
    set(gca(),"auto_clear","on");
    plot(f,Sig_ave_fft_dB_norm,'b-');
    xgrid(1, 1, 3);
    ax=get("current_axes"); ax.data_bounds=freqaxis;
    title(sprintf('Averaged signal : %d / %d times',i,AveN));
    ylabel('Normalized Amplitude Spectrum [dB]');
    xlabel('Frequency [Hz]');
    drawnow();
    
    if i==1
        xpause(2.0*1.0e6);
    else
        xpause(pause_s*1.0e6);
    end

end


