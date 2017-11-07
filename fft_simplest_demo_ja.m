%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 最もシンプルな FFT のデモ for 電子応用（神戸高専）
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
fs = 8000;     % サンプリングレート [Hz]
N  = 128;      % 波形の点数 [点]

amp  = 1.00;   % 信号の振幅 [arb.]
freq = 440.0;  % 信号の周波数 [Hz]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dt = 1/fs;     % 時間解像度 [s]

% 表示用ウィンドウの準備
fig1 = figure;
set(fig1,'Name','最もシンプルな FFT のデモ','position',[10 100 1200 900]);

% 時間軸
t = [0:N-1]*dt;

% 波形の生成
Sig = amp * sin(2*pi()*freq*t);

% 波形の表示
subplot(2,1,1);
plot(t,Sig,'ko-');
grid on;
title('元の波形');
ylabel('振幅');
xlabel('時刻 [s]');

% FFT
SigFFT = fft(Sig);

% 周波数軸
f = [0:N-1]/(N*dt);   % N*dt = 時間長 [s]

% スペクトルの表示
subplot(2,1,2);
plot(f,abs(SigFFT),'ko-');
grid on;
title('振幅スペクトル');
ylabel('振幅スペクトル');
xlabel('周波数 [Hz]');

% 音の再生
soundsc(Sig,fs);
