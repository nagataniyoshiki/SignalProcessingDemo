%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sinc関数の畳み込みによるアップサンプリングのデモ for 電子応用（神戸高専）
%  (Matlab/Octaveで動作します)
%    by Yoshiki NAGATANI, Kobe City College of Technology（長谷 芳樹）
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170509: First version
%   rev. 20170509b: Show the repetition of frequency component
%   rev. 20170530: Use stem function
%   rev. 20171107: 日本語版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% この部分を編集して下さい %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 元の波形
Sig = [0 0 0 0 0 -1 1 -3 3 -4 5 0 0 0 0 0];

% アップサンプリングの倍率 [倍]
UpsamplingRatio = 8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 波形の点数と時間解像度
Na = size(Sig,2);
dta = 1;
Nb = Na * UpsamplingRatio;
dtb = dta / UpsamplingRatio;

% 時間軸
ta = [0:Na-1]*dta;
tb = [0:Nb-1]*dtb;

% 周波数軸
fa = [0:Na-1]*dta;
fb = [0:Nb-1]*dta;

% 表示用ウィンドウの準備
fig1 = figure;
set(fig1,'Name','Sinc関数の畳み込みによるアップサンプリングのデモ','position',[10 100 1900 900]);

% 元の波形の表示
subplot(3,2,1);
plot(ta,Sig,'ko-');
grid on;
axis([0 Na min(Sig)*1.2 max(Sig)*1.2]);
title([sprintf('元の波形 [ %d 点: ',Na) sprintf('%d ',Sig) ']']);
ylabel('振幅');
xlabel('時刻 [点]');
drawnow;

% 元の波形のスペクトルの表示
FFT_Sig = fft(Sig)/Na;
FFT_Sig_repeat = FFT_Sig;
for i=2:UpsamplingRatio
    FFT_Sig_repeat = [FFT_Sig_repeat FFT_Sig];
end
subplot(3,2,2);
stem(fb,abs(FFT_Sig_repeat),'k');
grid on;
axis([0 Nb 0 max(abs(FFT_Sig_repeat))*1.2]);
title('元の波形の振幅スペクトル');
ylabel('振幅スペクトル');
xlabel('周波数（波の数）');
drawnow;

% 元の波形の表示
subplot(3,2,3);
stem(ta,Sig','k');
hold on;
grid on;
axis([0 Na min(Sig)*1.2 max(Sig)*1.2]);
title('各点に対応した Sinc 関数');
ylabel('振幅');
xlabel('時刻 [点]');
drawnow;

% Sinc 関数の計算と表示
for n=1:Na
    % Sinc 関数
    sincwaves(:,n) = Sig(n)*sinc(tb-(n-1));
    % 波形の表示
    subplot(3,2,3);
    plot(tb,sincwaves(:,n),'-');
    drawnow;
end;

% Sinc 関数の波形の合計
UpsampledWave = sum(sincwaves,2);

% 波形の表示
subplot(3,2,5);
stem(ta,Sig','k');
hold on;
grid on;
axis([0 Na min(Sig)*1.2 max(Sig)*1.2]);
title('元の波形 および アップサンプリングされた波形（全ての Sinc 関数の合計）');
ylabel('振幅');
xlabel('時刻 [点]');
drawnow;

% アップサンプリングされた波形の表示
subplot(3,2,5);
plot(tb,UpsampledWave','r*-');
drawnow;

% アップサンプリングされた波形のスペクトルの表示
FFT_UpsampledWave = fft(UpsampledWave)/Nb;
subplot(3,2,6);
stem(fb,abs(FFT_UpsampledWave),'r');
grid on;
axis([0 Nb 0 max(abs(FFT_UpsampledWave))*1.2]);
title('アップサンプリングされた波形の振幅スペクトル');
ylabel('振幅スペクトル');
xlabel('周波数（波の数）');
