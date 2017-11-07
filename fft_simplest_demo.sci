///////////////////////////////////////////////////////////////////////////
// Simplest FFT Demo for Applied Electronic Engineering Class
//  (compatible with Matlab/Octave)
//    by Yoshiki NAGATANI, Kobe City College of Technology
//    https://github.com/nagataniyoshiki
// 
//   rev. 20170724: First version
///////////////////////////////////////////////////////////////////////////

clear;

// Edit this part ////////////////////////////////////////////////
// Original Signal
fs = 8000;     // Sampling rate [Hz]
N  = 128;      // Number of points [points]

amp  = 1.00;   // Amplitude of signal [arb.]
freq = 440.0;  // Frequency of signal [Hz]
///////////////////////////////////////////////////////////////////////////

dt = 1/fs;     // temporal resolution [s]

// Prepare figure window
fig1 = figure("Figure_name", "Simplest FFT Demo", "position", [0 0 1200 900], "BackgroundColor", [1 1 1]);

// Time axis
t = [0:N-1]*dt;

// Create signal
Sig = amp * sin(2*%pi*freq*t);

// Plot waveform
subplot(2,1,1);
plot(t,Sig,'ko-');
xgrid(1, 1, 3);
title('Original signal');
ylabel('Amplitude');
xlabel('Time [s]');

// FFT
SigFFT = fft(Sig);

// Frequency axis
f = [0:N-1]/(N*dt);   // N*dt = Total time [s]

// Plot spectrum
subplot(2,1,2);
plot(f,abs(SigFFT),'ko-');
xgrid(1, 1, 3);
title('Amplitude Spectrum');
ylabel('Amplitude Spectrum');
xlabel('Frequency [Hz]');

// Play sound
sound([zeros(1,0.1*fs) Sig/max(Sig) zeros(1,0.1*fs)],fs);
