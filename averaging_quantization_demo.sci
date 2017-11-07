///////////////////////////////////////////////////////////////////////////
// Averaging Demo on Quantization Resolution for Applied Electronic Engineering Class
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
N  = 128;    // Number of samples [points]

// Target signal
amp  = 2.50;    // Signal: Amplitude [arb.]
freq = 300.0;   // Signal: Frequency [Hz]
burst = 4;      // Signal: Number of waves [number]

// Noise
amp_noise = 1.0;  // Amplitude of noise

// Averaging number
AveN = 128;       // Number of averaging [times]

// Refresh
pause_s = 0.1;  // Refresh speed [s]
///////////////////////////////////////////////////////////////////////////

// Time axes
dt = 1.0/fs;
t = [0:N-1]*dt;

// Frequency axes
df = 1/(N/fs);
f = [0:N-1]*df;

// Prepare figure window
fig1 = figure("Figure_name", "Averaging Demo on Quantization Resolution", "position", [0 0 1900 900], "BackgroundColor", [1 1 1]);
timeaxis = [0,-(amp+amp_noise); N/fs, (amp+amp_noise)];

// Create original signal
Sig_original = zeros(1,N);
Sig_original(1:round(burst/freq*fs)) = (amp * sin(2*%pi*freq*t(1:round(burst/freq*fs))));
Sig_quantized = round(Sig_original);

// Plot clean signal (waveform)
drawlater();
subplot(3,1,1);
plot(t,Sig_original,'g--');
plot(t,Sig_quantized,'ko-');
xgrid(1, 1, 3);
ax=get("current_axes"); ax.data_bounds=timeaxis;
title('Quantized signal WITHOUT noise');
ylabel('Amplitude');
xlabel('Time [s]');
drawnow();
plot(t,Sig_original,'g--');

// Add noise & averaging
Sig_sum = zeros(1,N);

for i=1:AveN
    // Create dirty signal
    Sig_dirty = round(Sig_original + amp_noise*(rand(1,N)-0.5));

    // Plot dirty signal (waveform)
    drawlater();
    subplot(3,1,2);
    set(gca(),"auto_clear","on");
    plot(t,Sig_original,'g--');
    set(gca(),"auto_clear","off");
    plot(t,Sig_dirty,'ro-');
    xgrid(1, 1, 3);
    ax=get("current_axes"); ax.data_bounds=timeaxis;
    title(sprintf('Quantized signals WITH white noise : SNR = %d dB',round(20*log10(amp/amp_noise))));
    ylabel('Amplitude');
    xlabel('Time [s]');

    // Averaging
    Sig_sum = Sig_sum + Sig_dirty;
    Sig_ave = Sig_sum / i;

    // Plot avaraged signal
    subplot(3,1,3);
    set(gca(),"auto_clear","on");
    plot(t,Sig_original,'g--');
    set(gca(),"auto_clear","off");
    plot(t,Sig_ave,'bo-');
    xgrid(1, 1, 3);
    ax=get("current_axes"); ax.data_bounds=timeaxis;
    title(sprintf('Averaged signal : %d / %d times',i,AveN));
    ylabel('Amplitude');
    xlabel('Time [s]');
    drawnow();
    
    if i==1
        xpause(2.0*1.0e6);
    else
        xpause(pause_s*1.0e6);
    end

end


