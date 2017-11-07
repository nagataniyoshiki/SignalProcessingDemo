%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ゼロ詰めをおこなった場合の離散フーリエ変換のデモ for 電子応用（神戸高専）
%  (Matlab/Octaveで動作します)
%    by Yoshiki NAGATANI, Kobe City College of Technology（長谷 芳樹）
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170509: First version
%   rev. 20171107: 日本語版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% この部分を編集して下さい %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 波形の設定
fs = 8000;   % サンプリングレート [Hz]
freq = 1500; % 信号の周波数 [Hz]
Na = 30;     % 波形の点数 [点]

% ゼロ詰めの倍率 (1: 元のまま)
ZeroPaddingRatio = 4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 波形の点数（ゼロ詰め後）
Nb = Na * ZeroPaddingRatio;

% 時間軸
dt = 1.0/fs;
ta = [0:Na-1]*dt;
tb = [0:Nb-1]*dt;

% Hann窓（ハニング窓）
Win = 0.5-0.5*cos(2*pi()*[0:Na-1]/Na);

% 解析対象の波形の準備
Siga_Rect = sin(2*pi()*freq*ta);
Sigb_Rect = [Siga_Rect zeros(1,Na*(ZeroPaddingRatio-1))];
Siga_Hann = sin(2*pi()*freq*ta) .* Win;
Sigb_Hann = [Siga_Hann zeros(1,Na*(ZeroPaddingRatio-1))];

% 周波数軸
fa = [0:Na-1]/(Na*dt);
fb = [0:Nb-1]/(Nb*dt);

% 表示用ウィンドウの準備
fig1 = figure;
set(fig1,'Name','ゼロ詰めをおこなった場合の離散フーリエ変換のデモ','position',[10 100 1800 900]);
timeaxis = [0 max(tb*1000) -1.1 1.1];

% 元の波形の表示（矩形窓）
subplot(2,2,1);
plot(tb*1000,Sigb_Rect,'ro-');
hold on;
plot(ta*1000,Siga_Rect,'k*--');
grid on;
axis(timeaxis);
title(sprintf('元の波形（%d Hz）に矩形窓を掛けたもの [ %d点 × %d倍 = %d点 ] ( fs = %d Hz )', freq, Na, ZeroPaddingRatio, Nb, fs));
ylabel('振幅');
xlabel('時刻 [ms]');
drawnow;

% 元の波形の表示（Hann窓を掛けたもの）
subplot(2,2,2);
plot(tb*1000,Sigb_Hann,'bo-');
hold on;
plot(ta*1000,Siga_Hann,'k*--');
grid on;
axis(timeaxis);
title(sprintf('元の波形（%d Hz）にHann窓（ハニング窓）を掛けたもの [ %d点 × %d倍 = %d点 ] ( fs = %d Hz )', freq, Na, ZeroPaddingRatio, Nb, fs));
ylabel('振幅');
xlabel('時刻 [ms]');
drawnow;

% FFT
FFT_Siga_Rect = fft(Siga_Rect);
FFT_Sigb_Rect = fft(Sigb_Rect);
FFT_Siga_Hann = fft(Siga_Hann);
FFT_Sigb_Hann = fft(Sigb_Hann);

% dBスケールに変換
dB_Siga_Rect = 20*log10(abs(FFT_Siga_Rect)/max(abs(FFT_Sigb_Rect)));
dB_Sigb_Rect = 20*log10(abs(FFT_Sigb_Rect)/max(abs(FFT_Sigb_Rect)));
dB_Siga_Hann = 20*log10(abs(FFT_Siga_Hann)/max(abs(FFT_Sigb_Rect)));
dB_Sigb_Hann = 20*log10(abs(FFT_Sigb_Hann)/max(abs(FFT_Sigb_Rect)));

freqaxis = [0 fs/2 -80 10];

% スペクトルの表示（矩形窓）
subplot(2,2,3);
plot(fb,dB_Sigb_Rect,'ro-');
hold on;
% bar(fa,dB_Siga_Rect,0.01,'k');
plot(fa,dB_Siga_Rect,'k*--');
grid on;
axis(freqaxis);
title(sprintf('矩形窓を掛けた波形の振幅スペクトル ( 周波数解像度 df = %.1f および %.1f Hz )',1/(Na*dt),1/(Nb*dt) ));
ylabel('正規化された振幅スペクトル [dB]');
xlabel('周波数 [Hz]');
drawnow;

% スペクトルの表示（Hann窓）
subplot(2,2,4);
plot(fb,dB_Sigb_Hann,'bo-');
hold on;
% bar(fa,dB_Siga_Hann,0.01,'k');
plot(fa,dB_Siga_Hann,'k*--');
grid on;
axis(freqaxis);
title(sprintf('Hann窓を掛けた波形の振幅スペクトル ( 周波数解像度 df = %.1f および %.1f Hz )',1/(Na*dt),1/(Nb*dt) ));
ylabel('正規化された振幅スペクトル [dB]');
xlabel('周波数 [Hz]');
drawnow;
