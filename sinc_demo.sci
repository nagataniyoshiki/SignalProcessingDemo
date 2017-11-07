///////////////////////////////////////////////////////////////////////////
// Sinc Interpolation Demo for Applied Electronic Engineering Class
//  (compatible with Scilab)
//    by Yoshiki NAGATANI, Kobe City College of Technology
//    https://github.com/nagataniyoshiki
// 
//   rev. 20170509: First version
//   rev. 20170509b: Show the repetition of frequency component
//   rev. 20170517: Scilab version
//   rev. 20171107: Set the background color to white
///////////////////////////////////////////////////////////////////////////

clear;

// Edit this part ////////////////////////////////////////////////
// Original Signal
Sig = [0 0 0 0 0 -1 1 -3 3 -4 5 0 0 0 0 0];

// Ratio for Upsampling
UpsamplingRatio = 8;
///////////////////////////////////////////////////////////////////////////

// Number of samples / Temporal resolution
Na = size(Sig,2);
dta = 1;
Nb = Na * UpsamplingRatio;
dtb = dta / UpsamplingRatio;

// Time axes
ta = [0:Na-1]*dta;
tb = [0:Nb-1]*dtb;

// Frequency axes
fa = [0:Na-1]*dta;
fb = [0:Nb-1]*dta;

// Prepare figure window
fig1 = figure("Figure_name", "Sinc Interpolation Demo", "position", [0 0 1900 900], "BackgroundColor", [1 1 1]);

// Plot original signal
drawlater();
subplot(3,2,1);
plot(ta,Sig,'ko-');
xgrid(1, 1, 3);
ax=get("current_axes"); ax.data_bounds=[0, min(Sig)*1.2; Na, max(Sig)*1.2];
title([sprintf("Original signal [ %d points ]",Na)]);
ylabel('Amplitude');
xlabel('Time [sample]');
drawnow();

// Plot spectrum of original signal
FFT_Sig = fft(Sig)/Na;
FFT_Sig_repeat = FFT_Sig;
for i=2:UpsamplingRatio
    FFT_Sig_repeat = [FFT_Sig_repeat FFT_Sig];
end
drawlater();
subplot(3,2,2);
bar(fb,abs(FFT_Sig_repeat),0.01,'k');
plot(fb,abs(FFT_Sig_repeat),'ko');
//xgrid(1, 1, 3);
ax=get("current_axes"); ax.data_bounds=[0, 0; Nb, max(abs(FFT_Sig_repeat))*1.2];
title('Amplitude Spectrum of the Original signal');
ylabel('Amplitude Spectrum');
xlabel('Frequency');
drawnow();

// Plot original signal
drawlater();
subplot(3,2,3);
bar(ta,Sig',0.01,'k');
plot(ta,Sig,'ko');
xgrid(1, 1, 3);
ax=get("current_axes"); ax.data_bounds=[0, min(Sig)*1.2; Na, max(Sig)*1.2];
title('Sinc functions for each point');
ylabel('Amplitude');
xlabel('Time [sample]');
drawnow();

// Calculate and Show Sinc functions
for n=1:Na
    // Sinc function
    sincwaves(:,n) = Sig(n)*sinc(%pi*(tb-(n-1)))';
    // Show waveforms
    subplot(3,2,3);
    plot(tb,sincwaves(:,n)','-');
    drawnow();
end;

// Summation of sinc waves
UpsampledWave = sum(sincwaves,2);

// Plot original signal
drawlater();
subplot(3,2,5);
bar(ta,Sig,0.01,'k');
plot(ta,Sig,'ko');
xgrid(1, 1, 3);
ax=get("current_axes"); ax.data_bounds=[0, min(Sig)*1.2; Na, max(Sig)*1.2];
title('Original signal and Upsampled waveform (summation of all sinc waveforms)');
ylabel('Amplitude');
xlabel('Time [sample]');
drawnow();

// Show upsampled waveform
drawlater();
subplot(3,2,5);
plot(tb,UpsampledWave','r*-');
drawnow();

// Plot spectrum of upsampled waveform
drawlater();
FFT_UpsampledWave = fft(UpsampledWave)/Nb;
subplot(3,2,6);
bar(fb,abs(FFT_UpsampledWave),0.01,'r');
plot(fb,abs(FFT_UpsampledWave'),'ro');
//xgrid(1, 1, 3);
ax=get("current_axes"); ax.data_bounds=[0, 0; Nb, max(abs(FFT_UpsampledWave))*1.2];
title('Amplitude Spectrum of the Upsampled waveform');
ylabel('Amplitude Spectrum');
xlabel('Frequency');
drawnow();
