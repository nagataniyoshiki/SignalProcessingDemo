%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 離散フーリエ変換の窓関数のデモ for 電子応用（神戸高専）
%  (Matlab/Octaveで動作します)
%    by Yoshiki NAGATANI, Kobe City College of Technology（長谷 芳樹）
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170512: First version
%   rev. 20171107: 日本語版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% この部分を編集して下さい %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 波形の設定
fs = 8000;   % サンプリングレート [Hz]
N = 128;     % 波形の点数 [点]

amp1  = 1.000;  % 信号１: 振幅 [arb.]
freq1 = 880.0;  % 信号１: 周波数 [Hz]   % A（♪ラ）

amp2  = 0.707;  % 信号２: 振幅 [arb.] % -3dB
freq2 = 987.8;  % 信号２: 周波数 [Hz]   % B（♪シ）
% freq2 = 1046.5; % 信号２: 周波数 [Hz]   % C（♪ド）

amp3  = 0.050;  % 信号３: 振幅 [arb.] % -26dB
freq3 = 1320.0; % 信号３: 周波数 [Hz]   % E（♪ミ）

% ゼロ詰めの比率 (1: 元のまま)
ZeroPaddingRatio = 128;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 時間軸
dt = 1.0/fs;
t1 = [0:N-1]*dt;
t2 = [0:N*ZeroPaddingRatio-1]*dt;

% 各種の窓
rad = 2*pi()*[0:N-1]/N;
Win_Rect = [ones(1,N) zeros(1,N*(ZeroPaddingRatio-1))];
Win_Hann = [0.5-0.5*cos(rad) zeros(1,N*(ZeroPaddingRatio-1))];
Win_BlHr = [0.35875-0.48829*cos(rad)+0.14128*cos(2*rad)-0.01168*cos(3*rad) zeros(1,N*(ZeroPaddingRatio-1))];
Win_Bart = [1.0-2.0*abs([0:N-1]/N-0.5) zeros(1,N*(ZeroPaddingRatio-1))];

% 解析対象の波形の準備
Sig = [amp1*sin(2*pi()*freq1*t1) + amp2*sin(2*pi()*freq2*t1) + amp3*sin(2*pi()*freq3*t1) zeros(1,N*(ZeroPaddingRatio-1))];
Sig_Cont = amp1*sin(2*pi()*freq1*t2) + amp2*sin(2*pi()*freq2*t2) + amp3*sin(2*pi()*freq3*t2);
Sig_Rect = Sig .* Win_Rect;
Sig_Hann = Sig .* Win_Hann;
Sig_BlHr = Sig .* Win_BlHr;
Sig_Bart = Sig .* Win_Bart;

% 音として再生する波形の準備
t3 = [0:round(1/dt)-1]*dt; % １秒
Sig_Listen  = amp1*sin(2*pi()*freq1*t3) + amp2*sin(2*pi()*freq2*t3) + amp3*sin(2*pi()*freq3*t3);
Sig1_Listen = amp1*sin(2*pi()*freq1*t3);
Sig2_Listen = amp2*sin(2*pi()*freq2*t3);
Sig3_Listen = amp3*sin(2*pi()*freq3*t3);

% 周波数軸
f_Win = [-N/2*ZeroPaddingRatio:N/2*ZeroPaddingRatio-1]/(N*ZeroPaddingRatio*dt);
f_Sig = [0:N*ZeroPaddingRatio-1]/(N*ZeroPaddingRatio*dt);

% 表示用ウィンドウの準備
fig1 = figure;
set(fig1,'Name','離散フーリエ変換の窓関数のデモ','position',[10 40 1900 960]);

timeaxis_SigWin  = [0 N*1.5*dt*1000 -abs(max(Sig)*1.1) abs(max(Sig)*1.1)];
timeaxis_SigCont = [0 (N*ZeroPaddingRatio-1)*dt*1000 -abs(max(Sig)*1.1) abs(max(Sig)*1.1)];

% 波形の表示（連続波形）
subplot(3,5,1);
plot(t2*1000,Sig_Cont,'k-');
grid on;
axis(timeaxis_SigCont);
title(sprintf('元の連続波形'));
ylabel('振幅');
xlabel('時刻 [ms]');
drawnow;

% 波形の表示（矩形窓）
subplot(3,5,2);
plot(t2*1000,Sig_Rect,'r.-');
hold on;
plot(t2*1000,Win_Rect,'k--');
grid on;
axis(timeaxis_SigWin);
% title(sprintf('Original signal at [%.2f @ %.1fHz] + [%.2f @ %.1fHz] + [%.2f @ %.1fHz] with Rectangular window', amp1, freq1, amp2, freq2, amp3, freq3 ));
title(sprintf('元の連続波形に矩形窓を掛けたもの'));
ylabel('振幅');
xlabel('時刻 [ms]');
drawnow;

% 波形の表示（Hann窓）
subplot(3,5,3);
plot(t2*1000,Sig_Hann,'b.-');
hold on;
plot(t2*1000,Win_Hann,'k--');
grid on;
axis(timeaxis_SigWin);
title(sprintf('元の連続波形にHann窓（ハニング窓）を掛けたもの'));
ylabel('振幅');
xlabel('時刻 [ms]');
drawnow;

% 波形の表示（Blackman-Harris窓）
subplot(3,5,4);
plot(t2*1000,Sig_BlHr,'m.-');
hold on;
plot(t2*1000,Win_BlHr,'k--');
grid on;
axis(timeaxis_SigWin);
title(sprintf('元の連続波形にBlackman-Harris窓を掛けたもの'));
ylabel('振幅');
xlabel('時刻 [ms]');
drawnow;

% 波形の表示（Bartlett窓）
subplot(3,5,5);
plot(t2*1000,Sig_Bart,'g.-');
hold on;
plot(t2*1000,Win_Bart,'k--');
grid on;
axis(timeaxis_SigWin);
title(sprintf('元の連続波形にBartlett窓を掛けたもの'));
ylabel('振幅');
xlabel('時刻 [ms]');
drawnow;

% FFT
FFT_Win_Rect = fft(Win_Rect);
FFT_Win_Hann = fft(Win_Hann);
FFT_Win_BlHr = fft(Win_BlHr);
FFT_Win_Bart = fft(Win_Bart);
FFT_Win_Rect = [FFT_Win_Rect(N*ZeroPaddingRatio/2+1:N*ZeroPaddingRatio) FFT_Win_Rect(1:N*ZeroPaddingRatio/2)];
FFT_Win_Hann = [FFT_Win_Hann(N*ZeroPaddingRatio/2+1:N*ZeroPaddingRatio) FFT_Win_Hann(1:N*ZeroPaddingRatio/2)];
FFT_Win_BlHr = [FFT_Win_BlHr(N*ZeroPaddingRatio/2+1:N*ZeroPaddingRatio) FFT_Win_BlHr(1:N*ZeroPaddingRatio/2)];
FFT_Win_Bart = [FFT_Win_Bart(N*ZeroPaddingRatio/2+1:N*ZeroPaddingRatio) FFT_Win_Bart(1:N*ZeroPaddingRatio/2)];

FFT_Sig_Cont = fft(Sig_Cont);
FFT_Sig_Rect = fft(Sig_Rect);
FFT_Sig_Hann = fft(Sig_Hann);
FFT_Sig_BlHr = fft(Sig_BlHr);
FFT_Sig_Bart = fft(Sig_Bart);

% dBスケールに変換
dB_Win_Rect = 20*log10(abs(FFT_Win_Rect)/max(abs(FFT_Win_Rect)));
dB_Win_Hann = 20*log10(abs(FFT_Win_Hann)/max(abs(FFT_Win_Rect)));
dB_Win_BlHr = 20*log10(abs(FFT_Win_BlHr)/max(abs(FFT_Win_Rect)));
dB_Win_Bart = 20*log10(abs(FFT_Win_Bart)/max(abs(FFT_Win_Rect)));
dB_Sig_Cont = 20*log10(abs(FFT_Sig_Cont)/max(abs(FFT_Sig_Cont)));
dB_Sig_Rect = 20*log10(abs(FFT_Sig_Rect)/max(abs(FFT_Sig_Rect)));
dB_Sig_Hann = 20*log10(abs(FFT_Sig_Hann)/max(abs(FFT_Sig_Rect)));
dB_Sig_BlHr = 20*log10(abs(FFT_Sig_BlHr)/max(abs(FFT_Sig_Rect)));
dB_Sig_Bart = 20*log10(abs(FFT_Sig_Bart)/max(abs(FFT_Sig_Rect)));

freqaxis_Win = [-fs/8 fs/8 -120 10];
freqaxis_Sig = [0 fs/4 -60 10];

% スペクトルの表示（連続波形）
subplot(3,5,6);
plot(f_Sig,dB_Sig_Cont,'k-');
grid on;
axis(freqaxis_Sig);
title(sprintf('振幅スペクトル（連続波形）'));
ylabel('正規化された振幅スペクトル [dB]');
xlabel('周波数 [Hz]');
drawnow;

% スペクトルの表示（矩形窓）
subplot(3,5,7);
plot(f_Sig,dB_Sig_Rect,'r-');
grid on;
axis(freqaxis_Sig);
title(sprintf('振幅スペクトル（矩形窓を掛けたもの）'));
ylabel('正規化された振幅スペクトル [dB]');
xlabel('周波数 [Hz]');
drawnow;

% スペクトルの表示（Hann窓）
subplot(3,5,8);
plot(f_Sig,dB_Sig_Hann,'b-');
grid on;
axis(freqaxis_Sig);
title(sprintf('振幅スペクトル（Hann窓を掛けたもの）'));
ylabel('正規化された振幅スペクトル [dB]');
xlabel('周波数 [Hz]');
drawnow;

% スペクトルの表示（Blackman-Harris窓）
subplot(3,5,9);
plot(f_Sig,dB_Sig_BlHr,'m-');
grid on;
axis(freqaxis_Sig);
title(sprintf('振幅スペクトル（Blackman-Harris窓を掛けたもの）'));
ylabel('正規化された振幅スペクトル [dB]');
xlabel('Frequency [Hz]');
drawnow;

% スペクトルの表示（Bartlett）
subplot(3,5,10);
plot(f_Sig,dB_Sig_Bart,'g-');
grid on;
axis(freqaxis_Sig);
title(sprintf('振幅スペクトル（Bartlett窓を掛けたもの）'));
ylabel('正規化された振幅スペクトル [dB]');
xlabel('周波数 [Hz]');
drawnow;

% 窓関数のスペクトルの表示（矩形窓）
subplot(3,5,12);
plot(f_Win,dB_Win_Rect,'k-');
grid on;
axis(freqaxis_Win);
title(sprintf('窓関数自身の振幅スペクトル（矩形窓）'));
ylabel('正規化された振幅スペクトル [dB]');
xlabel('周波数 [Hz]');
drawnow;

% 窓関数のスペクトルの表示（Hann窓）
subplot(3,5,13);
plot(f_Win,dB_Win_Hann,'k-');
grid on;
axis(freqaxis_Win);
title(sprintf('窓関数自身の振幅スペクトル（Hann窓）'));
ylabel('正規化された振幅スペクトル [dB]');
xlabel('周波数 [Hz]');
drawnow;

% 窓関数のスペクトルの表示（Blackman-Harris窓）
subplot(3,5,14);
plot(f_Win,dB_Win_BlHr,'k-');
grid on;
axis(freqaxis_Win);
title(sprintf('窓関数自身の振幅スペクトル（Blackman-Harris窓）'));
ylabel('正規化された振幅スペクトル [dB]');
xlabel('周波数 [Hz]');
drawnow;

% 窓関数のスペクトルの表示（Bartlett窓）
subplot(3,5,15);
plot(f_Win,dB_Win_Bart,'k-');
grid on;
axis(freqaxis_Win);
title(sprintf('窓関数自身の振幅スペクトル（Bartlett窓）'));
ylabel('正規化された振幅スペクトル [dB]');
xlabel('周波数 [Hz]');
drawnow;

% 音の再生
sound(Sig1_Listen/max(abs(Sig_Listen)),fs);
pause(1.2);
sound(Sig2_Listen/max(abs(Sig_Listen)),fs);
pause(1.2);
sound(Sig3_Listen/max(abs(Sig_Listen)),fs);
pause(1.8);
sound(Sig_Listen/max(abs(Sig_Listen)),fs);
pause(1.2);
