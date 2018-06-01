%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 離散フーリエ変換（DFT）のデモ for 電子応用（神戸高専）
%  (Matlab/Octaveで動作します)
%    by Yoshiki NAGATANI, Kobe City College of Technology（長谷 芳樹）
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170509: First version
%   rev. 20170530: Use stem function
%   rev. 20171107: 日本語版
%   rev. 20180601: 一番下のグラフ以外の横軸を削除
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% この部分を編集して下さい %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 波形の設定
Sig = [-1 1 -3 3 -4 5 0 0];

% 表示する波形の数
Waves = 12;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 波形の点数と時間解像度
Na = size(Sig,2);
dta = 1;
smoothsampling = 40;
Nb = Na * smoothsampling;
dtb = dta / smoothsampling;

% 時間軸
ta = [0:Na-1]*dta;
tb = [0:Nb-1]*dtb;

% 表示用ウィンドウの準備
fig1 = figure;
set(fig1,'Name','離散フーリエ変換（DFT）のデモ: 波形','position',[10 60 800 940]);

% 元の波形の表示
subplot(Waves+2,2,1);
plot(ta,Sig,'ko--');
grid on;
axis([0 Na min(Sig) max(Sig)]);
title([sprintf('元の波形 [ %d 点: ',Na) sprintf('%d ',Sig) ']']);
subplot(Waves+2,2,2);
plot(ta,Sig,'ko--');
grid on;
axis([0 Na min(Sig) max(Sig)]);
title([sprintf('元の波形 [ %d 点: ',Na) sprintf('%d ',Sig) ']']);

drawnow;

% フーリエ係数の計算と表示
for n=0:Waves-1
    % 実部: cos(2*pi*f*n/N) %%%%%%%%%%%%
    cosa = cos(2*pi()*n*ta/Na);
    cosb = cos(2*pi()*n*tb/Na);
    coefreal(n+1) = sum(Sig.*cosa);
    % 波形の表示
    subplot(Waves+1,2,3+n*2);
    plot(ta,cosa,'k--');
    hold on;
    plot(ta,cosa,'ro');
    plot(tb,cosb,'r-');
    grid on;
    axis([0 Na -1 1]);
    title(sprintf('cos(2*pi*%d*n/%d) : フーリエ係数 = %.3f',n,Na,coefreal(n+1)));
    % 軸のラベル
    if n == round((Waves-1)/2)
        ylabel('振幅');
    end
    if n == Waves-1
        xlabel('時刻 [点]');
    end

    % 虚部: sin(2*pi*f*n/N) %%%%%%%%%%%%
    sina = -sin(2*pi()*n*ta/Na);
    sinb = -sin(2*pi()*n*tb/Na);
    coefimag(n+1) = sum(Sig.*sina);
    % 波形の表示
    subplot(Waves+1,2,4+n*2);
    plot(ta,sina,'k--');
    hold on;
    plot(ta,sina,'bo');
    plot(tb,sinb,'b-');
    grid on;
    axis([0 Na -1 1]);
    title(sprintf('-sin(2*pi*%d*n/%d) : フーリエ係数 = %.3fi',n,Na,coefimag(n+1)));
    % 軸のラベル
    if n == round((Waves-1)/2)
        ylabel('振幅');
    end
    if n == Waves-1
        xlabel('時刻 [点]');
    end
    
    drawnow;
end;

% 一番下のグラフ以外の横軸を削除
Axes= findall(gcf,'type','axes');
set(Axes(3:end),'xticklabel','');
drawnow;

% フーリエ係数 = 実部 + i*虚部
DFT = coefreal + 1i*coefimag;
disp('DFT結果 (手動で計算したもの)')
DFT.'

% DFT結果の表示
fig2 = figure;
set(fig2,'Name','離散フーリエ変換（DFT）デモ: DFT結果','position',[820 300 500 700]);

subplot(3,1,1);
stem([0:Waves-1], real(DFT)','k');
grid on;
axis([-0.5 Waves-0.5 -max(abs(DFT)*1.1) max(abs(DFT)*1.1)]);
title('DFT (実部)');
ylabel('振幅');

subplot(3,1,2);
stem([0:Waves-1], imag(DFT)','b');
grid on;
axis([-0.5 Waves-0.5 -max(abs(DFT)*1.1) max(abs(DFT)*1.1)]);
title('DFT (虚部)');
ylabel('振幅');

subplot(3,1,3);
stem([0:Waves-1], abs(DFT)','k');
grid on;
axis([-0.5 Waves-0.5 0 max(abs(DFT)*1.1)]);
title('DFT (絶対値)');
ylabel('振幅スペクトル');
xlabel('波の数 [個]');

% FFT結果との比較 (Matlab/Octaveで用意されている関数との比較)
disp('FFT結果との比較 (Matlab/Octaveで用意されている関数との比較)')
FFT = fft(Sig).'
