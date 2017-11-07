%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% サンプリング定理のデモ for 電子応用（神戸高専）
%  (Matlab/Octaveで動作します)
%    by Yoshiki NAGATANI, Kobe City College of Technology（長谷 芳樹）
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170724: First version
%   rev. 20171107: 日本語版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% この部分を編集して下さい %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 波形の設定
fs = 8000;  % サンプリングレート [Hz]
N  = 800;   % 波形の点数 [点]

amp  = 1.000;    % 信号の振幅 [arb.]
freqmin =  200;  % 信号の最低周波数 [Hz]
freqmax = 7800;  % 信号の最高周波数 [Hz]

freqinc  = 50; % 周波数の増分 [Hz]
UpsamplingRatio = 16;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 表示用ウィンドウの準備
fig1 = figure;
set(fig1,'Name','サンプリング定理のデモ','position',[10 100 1900 900]);

dt = 1/fs;

% 時間軸
t1 = [0:N-1]*dt;
t2 = [0:(N*UpsamplingRatio)-1]*(dt/UpsamplingRatio);

% 周波数軸
f = [-N*2:N*2-1]/(N*dt);

timeaxis = [0 (N-1)*dt*1000/16 -abs(amp*1.1) abs(amp*1.1)];
freqaxis = [-fs*2/1000 fs*2/1000 -40 60];

freq = freqmin;

while freq <= freqmax

    % 信号の生成
    Sig1 = amp*sin(2*pi()*freq*t1);
    Sig2 = amp*sin(2*pi()*freq*t2);
   
    Sig1Hann = Sig1.*hann(N)';
    
    % 波形の表示
    subplot(2,1,1);
    hold off;
    plot(t2*1000,Sig2,'b-');
    hold on;
    stem(t1*1000,Sig1,'ko--');
    plot(t1*1000,Sig1,'k-');
    grid on;
    grid minor;
    axis(timeaxis);
    title(sprintf('元の信号波形 および サンプリングされた信号の波形（ %d Hz @ fs = %d Hz )',round(freq),round(fs)));
    ylabel('振幅');
    xlabel('時刻 [ms]');

    % スペクトルの表示
    subplot(2,1,2);
    Sig1FFTdB = 20*log10(abs(fft(Sig1Hann)));
    hold off;
    stem(freq/1000,100,'b--','BaseValue',-100);
    hold on;
    stem((fs-freq)/1000,100,'r--','BaseValue',-100);
    stem([-fs 0 fs]/1000,[1 1 1]*100,'k-','BaseValue',-100);
    stem([-3*fs/2 -fs/2 fs/2 3*fs/2]/1000,[1 1 1 1]*100,'k--','BaseValue',-100);
    plot(f/1000,[Sig1FFTdB Sig1FFTdB Sig1FFTdB Sig1FFTdB],'k-');
    grid on;
    grid minor;
    axis(freqaxis);
    title(sprintf('サンプリングされた信号（Hann窓を掛けたもの）の振幅スペクトル'));
    ylabel('振幅スペクトル [dB]');
    xlabel('周波数 [kHz]');
    xtics = [-4:1:4]*fs/2/1000;
    set(gca,'XTick',xtics);
    drawnow;

    % 音の再生
    sound(Sig1Hann/(amp*1.1),fs);
    pause(N*dt+0.1);
    
    % 周波数の上下
    if (fs/2*0.95 < freq && freq < fs/2*1.05)
        freq = freq + freqinc/5; % 変化をゆっくりに
    else   
        freq = freq + freqinc;
    end
    
end

