%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% アベレージングによるノイズ除去のデモ for 電子応用（神戸高専）
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
N  = 512;    % 波形の点数 [点]

% Target signal
amp  = 1.000;  % 信号の振幅 [arb.]
freq = 250.0;  % 信号の周波数 [Hz]
burst = 10;    % 信号に含まれる端数 [個]

% SNR（S/N比）
SNR_dB = 6.0;  % S/N比 [dB]

% アベレージング回数
AveN = 128;    % アベレージング回数 [回]

% 画面の書き換え速度
pause_s = 0.1;  % 書き換え速度 [s]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 時間軸
dt = 1.0/fs;
t = [0:N-1]*dt;

% 周波数軸
df = 1/(N/fs);
f = [0:N-1]*df;

SNR_ratio = 10^(SNR_dB/20);

% 表示用ウィンドウの準備
fig1 = figure;
set(fig1,'Name','アベレージングによるノイズ除去のデモ','position',[10 100 1900 900]);

% 元の波形の生成
Sig_clean = zeros(1,N);
Sig_clean(1:round(burst/freq*fs)) = amp * sin(2*pi()*freq*t(1:round(burst/freq*fs)) );

% 元の波形（ノイズ無し）の表示
subplot(3,2,1);
plot(t,Sig_clean,'k-');
grid on;
axis([0 N/fs -amp*(1+1/SNR_ratio)*2.0 amp*(1+1/SNR_ratio)*2.0]);
title('元の波形（ノイズ無し）（ターゲット）');
ylabel('振幅');
xlabel('時刻 [s]');

% 元の波形（ノイズ無し）のスペクトルの表示
Sig_clean_fft_dB = 20*log10(abs(fft(Sig_clean.*hanning(N)')));
Sig_clean_fft_dB_norm = Sig_clean_fft_dB - max(Sig_clean_fft_dB);
subplot(3,2,2);
plot(f,Sig_clean_fft_dB_norm,'k-');
grid on;
axis([0 N*df/2 -55 5]);
title('元の波形（ノイズ無し）（ターゲット）');
ylabel('正規化された振幅スペクトル [dB]');
xlabel('周波数 [Hz]');
drawnow;

% ノイズ付与とアベレージング
Sig_sum = zeros(1,N);

for i=1:AveN
    % ノイズ入り波形の生成
    Sig_dirty = Sig_clean + amp/SNR_ratio*randn(1,N);

    % ノイズ入り波形の表示
    subplot(3,2,3);
    plot(t,Sig_dirty,'r-');
    grid on;
    axis([0 N/fs -amp*(1+1/SNR_ratio)*2.0 amp*(1+1/SNR_ratio)*2.0]);
    title(sprintf('ガウスノイズ入りの波形 : SNR = %d dB',round(SNR_dB)));
    ylabel('振幅');
    xlabel('時刻 [s]');

    % ノイズ入り波形のスペクトルの表示
    Sig_dirty_fft_dB = 20*log10(abs(fft(Sig_dirty.*hanning(N)')));
    Sig_dirty_fft_dB_norm = Sig_dirty_fft_dB - max(Sig_clean_fft_dB);
    subplot(3,2,4);
    plot(f,Sig_dirty_fft_dB_norm,'r-');
    grid on;
    axis([0 N*df/2 -55 5]);
    title(sprintf('ガウスノイズ入りの波形 : SNR = %d dB',round(SNR_dB)));
    ylabel('正規化された振幅スペクトル [dB]');
    xlabel('周波数 [Hz]');

    % アベレージング処理
    Sig_sum = Sig_sum + Sig_dirty;
    Sig_ave = Sig_sum / i;

    % アベレージング後の波形の表示
    subplot(3,2,5);
    plot(t,Sig_ave,'b-');
    grid on;
    axis([0 N/fs -amp*(1+1/SNR_ratio)*2.0 amp*(1+1/SNR_ratio)*2.0]);
    title(sprintf('アベレージング後の波形 : %d / %d 回',i,AveN));
    ylabel('振幅');
    xlabel('時刻 [s]');
    
    % アベレージング後の波形のスペクトルの表示
    Sig_ave_fft_dB = 20*log10(abs(fft(Sig_ave.*hanning(N)')));
    Sig_ave_fft_dB_norm = Sig_ave_fft_dB - max(Sig_clean_fft_dB);
    subplot(3,2,6);
    plot(f,Sig_ave_fft_dB_norm,'b-');
    grid on;
    axis([0 N*df/2 -55 5]);
    title(sprintf('アベレージング後の波形 : %d / %d 回',i,AveN));
    ylabel('正規化された振幅スペクトル [dB]');
    xlabel('周波数 [Hz]');
    drawnow;
    
    if i==1
        pause(2.0);
    else
        pause(pause_s);
    end

end


