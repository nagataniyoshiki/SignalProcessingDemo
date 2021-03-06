///////////////////////////////////////////////////////////////////////////
// Zero Padding Demo for Applied Electronic Engineering Class
//  (compatible with Matlab/Octave)
//    by Yoshiki NAGATANI, Kobe City College of Technology
//    https://github.com/nagataniyoshiki
// 
//   rev. 20170509: First version
//   rev. 20170517: Scilab version
//   rev. 20171107: Set the background color to white
///////////////////////////////////////////////////////////////////////////

clear;

// Edit this part ////////////////////////////////////////////////
// Original Signal
fs = 8000;   // Sampling rate [Hz]
freq = 1500; // Signal Frequency [Hz]
Na = 30;     // Number of samples [points]

// Ratio for Zero Padding (1: original)
ZeroPaddingRatio = 4;
///////////////////////////////////////////////////////////////////////////

// Number of samples
Nb = Na * ZeroPaddingRatio;

// Time axes
dt = 1.0/fs;
ta = [0:Na-1]*dt;
tb = [0:Nb-1]*dt;

// Hann Window
Win = 0.5-0.5*cos(2*%pi*[0:Na-1]/Na);

// Signal
Siga_Rect = sin(2*%pi*freq*ta);
Sigb_Rect = [Siga_Rect zeros(1,Na*(ZeroPaddingRatio-1))];
Siga_Hann = sin(2*%pi*freq*ta) .* Win;
Sigb_Hann = [Siga_Hann zeros(1,Na*(ZeroPaddingRatio-1))];

// Frequency axes
fa = [0:Na-1]/(Na*dt);
fb = [0:Nb-1]/(Nb*dt);

// Prepare figure window
fig1 = figure("Figure_name", "Zero Padding Demo", "position", [0 0 1800 900], "BackgroundColor", [1 1 1]);
timeaxis = [0, -1.1; max(tb*1000), 1.1];

// Plot original signal (Rect)
drawlater();
subplot(2,2,1);
plot(tb*1000,Sigb_Rect,'ro-');
plot(ta*1000,Siga_Rect,'k*--');
xgrid(1, 1, 3);
ax=get("current_axes"); ax.data_bounds=timeaxis;
title(sprintf('Original signal at %d Hz with Rectangular window [ %d points x %d = %d points ] ( fs = %d Hz )', freq, Na, ZeroPaddingRatio, Nb, fs));
ylabel('Amplitude');
xlabel('Time [ms]');
drawnow();

// Plot original signal (Hann)
drawlater();
subplot(2,2,2);
plot(tb*1000,Sigb_Hann,'bo-');
plot(ta*1000,Siga_Hann,'k*--');
xgrid(1, 1, 3);
ax=get("current_axes"); ax.data_bounds=timeaxis;
title(sprintf('Original signal at %d Hz with Hann window [ %d points x %d = %d points ] ( fs = %d Hz )', freq, Na, ZeroPaddingRatio, Nb, fs));
ylabel('Amplitude');
xlabel('Time [ms]');
drawnow();

// FFT
FFT_Siga_Rect = fft(Siga_Rect);
FFT_Sigb_Rect = fft(Sigb_Rect);
FFT_Siga_Hann = fft(Siga_Hann);
FFT_Sigb_Hann = fft(Sigb_Hann);

// convert to dB scale
dB_Siga_Rect = 20*log10(abs(FFT_Siga_Rect)/max(abs(FFT_Sigb_Rect)));
dB_Sigb_Rect = 20*log10(abs(FFT_Sigb_Rect)/max(abs(FFT_Sigb_Rect)));
dB_Siga_Hann = 20*log10(abs(FFT_Siga_Hann)/max(abs(FFT_Sigb_Rect)));
dB_Sigb_Hann = 20*log10(abs(FFT_Sigb_Hann)/max(abs(FFT_Sigb_Rect)));

freqaxis = [0, -80; fs/2, 10];

// Plot spectrum (Rect)
drawlater();
subplot(2,2,3);
plot(fb,dB_Sigb_Rect,'ro-');
// bar(fa,dB_Siga_Rect,0.01,'k');
plot(fa,dB_Siga_Rect,'k*--');
xgrid(1, 1, 3);
ax=get("current_axes"); ax.data_bounds=freqaxis;
title(sprintf('Amplitude Spectrum of the Original Signal with Rectangular window ( df = %.1f and %.1f Hz )',1/(Na*dt),1/(Nb*dt) ));
ylabel('Normalized Amplitude Spectrum [dB]');
xlabel('Frequency [Hz]');
drawnow();

// Plot spectrum (Hann)
drawlater();
subplot(2,2,4);
plot(fb,dB_Sigb_Hann,'bo-');
// bar(fa,dB_Siga_Hann,0.01,'k');
plot(fa,dB_Siga_Hann,'k*--');
xgrid(1, 1, 3);
ax=get("current_axes"); ax.data_bounds=freqaxis;
title(sprintf('Amplitude Spectrum of the Original Signal with Hann window ( df = %.1f and %.1f Hz )',1/(Na*dt),1/(Nb*dt) ));
ylabel('Normalized Amplitude Spectrum [dB]');
xlabel('Frequency [Hz]');
drawnow();
