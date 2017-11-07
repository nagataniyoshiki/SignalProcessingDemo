%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% アベレージングによる量子化精度向上のデモ for 電子応用（神戸高専）
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
N  = 128;    % 波形の点数 [点]

% ターゲット波形
amp  = 2.50;    % 信号の振幅 [arb.]
freq = 300.0;   % 信号の周波数 [Hz]
burst = 4;      % 信号に含まれる端数 [個]

% ノイズ
amp_noise = 1.0;  % Amplitude of noise

% アベレージング回数
AveN = 128;       % アベレージング回数 [回]

% 画面の書き換え速度
pause_s = 0.1;  % 書き換え速度 [s]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 時間軸
dt = 1.0/fs;
t = [0:N-1]*dt;

% 周波数軸
df = 1/(N/fs);
f = [0:N-1]*df;

% 表示用ウィンドウの準備
fig1 = figure;
set(fig1,'Name','アベレージングによる量子化精度向上のデモ','position',[10 100 1900 900]);

% 元の波形（ノイズ無し）の生成
Sig_original = zeros(1,N);
Sig_original(1:round(burst/freq*fs)) = (amp * sin(2*pi()*freq*t(1:round(burst/freq*fs))));
Sig_quantized = round(Sig_original);

% 元の波形（ノイズ無し）の表示
subplot(3,1,1);
plot(t,Sig_original,'g--');
hold on;
plot(t,Sig_quantized,'ko-');
grid on;
axis([0 N/fs -(amp+amp_noise) (amp+amp_noise)]);
title('量子化された元の波形（ノイズ無し）');
ylabel('振幅');
xlabel('時刻 [s]');
drawnow;

% ノイズ付与とアベレージング
Sig_sum = zeros(1,N);

for i=1:AveN
    % ノイズ入り波形の生成
    Sig_dirty = round(Sig_original + amp_noise*(rand(1,N)-0.5));

    % ノイズ入り波形の表示
    subplot(3,1,2);
    hold off;
    plot(t,Sig_original,'g--');
    hold on;
    plot(t,Sig_dirty,'ro-');
    grid on;
    axis([0 N/fs -(amp+amp_noise) (amp+amp_noise)]);
    title(sprintf('量子化された波形（ノイズ有り） : SNR = %d dB',round(20*log10(amp/amp_noise))));
    ylabel('振幅');
    xlabel('時刻 [s]');

    % アベレージング処理
    Sig_sum = Sig_sum + Sig_dirty;
    Sig_ave = Sig_sum / i;

    % アベレージング後の波形の表示
    subplot(3,1,3);
    hold off;
    plot(t,Sig_original,'g--');
    hold on;
    plot(t,Sig_ave,'bo-');
    grid on;
    grid minor;
    axis([0 N/fs -(amp+amp_noise) (amp+amp_noise)]);
    title(sprintf('アベレージング後の波形 : %d / %d 回',i,AveN));
    ylabel('振幅');
    xlabel('時刻 [s]');
    drawnow;
    
    if i==1
        pause(2.0);
    else
        pause(pause_s);
    end

end


