%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DFT時の信号長のデモ for 電子応用（神戸高専）
%  (Matlab/Octaveで動作します)
%    by Yoshiki NAGATANI, Kobe City College of Technology（長谷 芳樹）
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170725: First version
%   rev. 20171107: 日本語版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% この部分を編集して下さい %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 波形の設定
fs = 8000;   % サンプリングレート [Hz]
Nmin = 8;    % 最短の波形点数 [点]
Nmax = 1200; % 最長の波形点数 [点]

amp1  = 0.200;  % 信号１: 振幅 [arb.]
freq1 = 345.0;  % 信号１: 周波数 [Hz]

amp2  = 0.800;  % 信号２: 振幅 [arb.]
freq2 = 456.0;  % 信号２: 周波数 [Hz]

Ninc  = 1.1;   % 点数 N の増分 [比]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 表示用ウィンドウの準備
fig1 = figure;
set(fig1,'Name','DFT時の信号長のデモ','position',[10 100 1900 900]);

dt = 1.0/fs;

% 時間軸
t = [0:Nmax-1]*dt;

% 元の信号の生成
Sig = amp1*sin(2*pi()*freq1*t) + amp2*sin(2*pi()*freq2*t);

timeaxis = [0 (Nmax-1)*dt*1000 -abs((amp1+amp2)*1.1) abs((amp1+amp2)*1.1)];
freqaxis = [0 fs -90 50];

N = Nmin;

while Nmin <= N && N < Nmax

    Sig_Hann = Sig(1:N).*hanning(N)';
    
    % 波形の表示
    subplot(2,1,1);
    hold off;
    plot(t*1000,Sig,'k-');
    hold on;
    plot(t(1:N)*1000,hanning(N'),'g-');
    plot(t(1:N)*1000,-hanning(N'),'g-');
    plot(t(1:N)*1000,Sig_Hann,'bo-');
    grid on;
    axis(timeaxis);
    title(sprintf('元の波形 ( %d Hz & %d Hz @ fs = %d Hz ) : N = %d点 → 信号長 = %.2f ms',round(freq1),round(freq2),round(fs),round(N),N*dt*1000));
    ylabel('振幅');
    xlabel('時刻 [ms]');

    % スペクトルの表示（連続波形）
    f = [0:round(N)-1]/(round(N)*dt);
    subplot(2,1,2);
    stem(f,20*log10(abs(fft(Sig_Hann))),'bo-','BaseValue',-100);
    grid on;
    axis(freqaxis);
    title(sprintf('振幅スペクトル ( 周波数解像度 df = %.2f Hz )',1/(N*dt)));
    ylabel('振幅スペクトル [dB]');
    xlabel('周波数 [Hz]');
    drawnow;

    % 音の再生
    sound([zeros(1,0.1*fs) Sig_Hann/((amp1+amp2)*1.1) zeros(1,0.1*fs)],fs);
    pause(N*dt+0.2);
    
    % N の増加または減少
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
