%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DFT Demo for Applied Electronic Engineering Class
%  (compatible with Matlab/Octave)
%    by Yoshiki NAGATANI, Kobe City College of Technology
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170509: First version
%   rev. 20170530: Use stem function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% Edit this part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Original Signal
Sig = [-1 1 -3 3 -4 5 0 0];

% Number of waveforms to display
Waves = 12;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of samples / Temporal resolution
Na = size(Sig,2);
dta = 1;
smoothsampling = 40;
Nb = Na * smoothsampling;
dtb = dta / smoothsampling;

% Time axes
ta = [0:Na-1]*dta;
tb = [0:Nb-1]*dtb;

% Prepare figure window
fig1 = figure;
set(fig1,'Name','DFT Demo: Waveforms','position',[10 60 800 940]);

% Plot original signal
subplot(Waves+2,2,1);
plot(ta,Sig,'ko--');
grid on;
axis([0 Na min(Sig) max(Sig)]);
title([sprintf('Original signal [ %d points: ',Na) sprintf('%d ',Sig) ']']);
subplot(Waves+2,2,2);
plot(ta,Sig,'ko--');
grid on;
axis([0 Na min(Sig) max(Sig)]);
title([sprintf('Original signal [ %d points: ',Na) sprintf('%d ',Sig) ']']);

drawnow;

% Calculate and Show DFT coefficients
for n=0:Waves-1
    % Real Part: cos(2*pi*f*n/N) %%%%%%%%%%%%
    cosa = cos(2*pi()*n*ta/Na);
    cosb = cos(2*pi()*n*tb/Na);
    coefreal(n+1) = sum(Sig.*cosa);
    % Show waveforms
    subplot(Waves+1,2,3+n*2);
    plot(ta,cosa,'k--');
    hold on;
    plot(ta,cosa,'ro');
    plot(tb,cosb,'r-');
    grid on;
    axis([0 Na -1 1]);
    title(sprintf('cos(2*pi*%d*n/%d) : Fourier Coef = %.3f',n,Na,coefreal(n+1)));
    % Axis labels
    if n == round((Waves-1)/2)
        ylabel('Amplitude');
    end
    if n == Waves-1
        xlabel('Time [samples]');
    end

  % Imaginary Part: sin(2*pi*f*n/N) %%%%%%%%%%%%
    sina = -sin(2*pi()*n*ta/Na);
    sinb = -sin(2*pi()*n*tb/Na);
    coefimag(n+1) = sum(Sig.*sina);
    % Show waveforms
    subplot(Waves+1,2,4+n*2);
    plot(ta,sina,'k--');
    hold on;
    plot(ta,sina,'bo');
    plot(tb,sinb,'b-');
    grid on;
    axis([0 Na -1 1]);
    title(sprintf('-sin(2*pi*%d*n/%d) : Fourier Coef = %.3fi',n,Na,coefimag(n+1)));
    % Axis labels
    if n == round((Waves-1)/2)
        ylabel('Amplitude');
    end
    if n == Waves-1
        xlabel('Time [samples]');
    end
    
    drawnow;
end;

% DFT coefficients = Real + i*Imaginary
DFT = coefreal + 1i*coefimag;
disp('DFT result (manually calculated)')
DFT.'

% Show DFT results
fig2 = figure;
set(fig2,'Name','DFT Demo: DFT result','position',[820 300 500 700]);

subplot(3,1,1);
stem([0:Waves-1], real(DFT)','k');
grid on;
axis([-0.5 Waves-0.5 -max(abs(DFT)*1.1) max(abs(DFT)*1.1)]);
title('DFT (Real part)');
ylabel('Amplitude');

subplot(3,1,2);
stem([0:Waves-1], imag(DFT)','b');
grid on;
axis([-0.5 Waves-0.5 -max(abs(DFT)*1.1) max(abs(DFT)*1.1)]);
title('DFT (Imaginary part)');
ylabel('Amplitude');

subplot(3,1,3);
stem([0:Waves-1], abs(DFT)','k');
grid on;
axis([-0.5 Waves-0.5 0 max(abs(DFT)*1.1)]);
title('DFT (Abs)');
ylabel('Amplitude Spectrum');
xlabel('Waves [number]');

% FFT for comparison (built-in function of Matlab/Octave)
disp('FFT for comparison (built-in function of Matlab/Octave)')
FFT = fft(Sig).'
