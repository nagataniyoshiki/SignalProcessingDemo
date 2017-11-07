///////////////////////////////////////////////////////////////////////////
// Sampling Theorem Demo for Applied Electronic Engineering Class
//  (compatible with Scilab)
//    by Yoshiki NAGATANI, Kobe City College of Technology
//    https://github.com/nagataniyoshiki
// 
//   rev. 20171107: First version
///////////////////////////////////////////////////////////////////////////

clear;

// Edit this part ////////////////////////////////////////////////
// Original Signal
fs = 8000;  // Sampling rate [Hz]
N  = 800;   // Number of points [points]

amp  = 1.000;    // Amplitude of signal [arb.]
freqmin =  200;  // Minimum frequency of signal [Hz]
freqmax = 7800;  // Maximum frequency of signal [Hz]

freqinc  = 50; // increment of frequency [Hz]
UpsamplingRatio = 16;
///////////////////////////////////////////////////////////////////////////

// Prepare figure window
fig1 = figure("Figure_name", "Sampling Theorem Demo", "position", [0 0 1900 900], "BackgroundColor", [1 1 1]);

dt = 1/fs;

// Time axes
t1 = [0:N-1]*dt;
t2 = [0:(N*UpsamplingRatio)-1]*(dt/UpsamplingRatio);

// Frequency axis
f = [-N*2:N*2-1]/(N*dt);

timeaxis = [0, -abs(amp*1.1); (N-1)*dt*1000/16, abs(amp*1.1)];
freqaxis = [-fs*2/1000, -40; fs*2/1000, 60];

freq = freqmin;

while freq <= freqmax

    // Signal
    Sig1 = amp*sin(2*%pi*freq*t1);
    Sig2 = amp*sin(2*%pi*freq*t2);
   
    Sig1Hann = Sig1.*window('hn',N);
    
    // Plot waveform
    drawlater();
    subplot(2,1,1);
    set(gca(),"auto_clear","on");
    plot(t2*1000,Sig2,'b-');
    set(gca(),"auto_clear","off");
    bar(t1*1000, Sig1,0.01,'ko--');
    plot(t1*1000,Sig1,'k-');
    xgrid(1, 1, 3);
    ax=get("current_axes"); ax.data_bounds=timeaxis;
    title(sprintf('Original signal (signal: %d Hz @ fs = %d Hz )',round(freq),round(fs)));
    ylabel('Amplitude');
    xlabel('Time [ms]');

    // Plot spectrum
    subplot(2,1,2);
    Sig1FFTdB = 20*log10(abs(fft(Sig1Hann)));
    set(gca(),"auto_clear","on");
//    bar(freq/1000,100,0.2,'b--');
//    bar((fs-freq)/1000,100,0.2,'r--');
    bar([-fs 0 fs]/1000,[1 1 1]*100,0.00,'k-');
    set(gca(),"auto_clear","off");
    bar([-3*fs/2 -fs/2 fs/2 3*fs/2]/1000,[1 1 1 1]*100,0.00,'k--');
//     bar(f/1000,[Sig1FFTdB Sig1FFTdB Sig1FFTdB Sig1FFTdB],'k-');
    plot(f/1000,[Sig1FFTdB Sig1FFTdB Sig1FFTdB Sig1FFTdB],'k-');
    xgrid(1, 1, 3);
    ax=get("current_axes"); ax.data_bounds=freqaxis;
    title(sprintf('Amplitude Spectrum of the sampled signal with Hann window'));
    ylabel('Amplitude Spectrum [dB]');
    xlabel('Frequency [kHz]');
    drawnow();

    // Play sound
    sound(Sig1Hann/(amp*1.1),fs);
    xpause((N*dt+0.1)*1.0e6);
    
    // Increase or decrease frequency
    if (fs/2*0.95 < freq & freq < fs/2*1.05)
        freq = freq + freqinc/5; // Slow down
    else   
        freq = freq + freqinc;
    end
    
end

