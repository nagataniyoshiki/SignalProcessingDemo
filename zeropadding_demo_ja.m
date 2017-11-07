%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �[���l�߂������Ȃ����ꍇ�̗��U�t�[���G�ϊ��̃f�� for �d�q���p�i�_�ˍ���j
%  (Matlab/Octave�œ��삵�܂�)
%    by Yoshiki NAGATANI, Kobe City College of Technology�i���J �F���j
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170509: First version
%   rev. 20171107: ���{���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% ���̕�����ҏW���ĉ����� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �g�`�̐ݒ�
fs = 8000;   % �T���v�����O���[�g [Hz]
freq = 1500; % �M���̎��g�� [Hz]
Na = 30;     % �g�`�̓_�� [�_]

% �[���l�߂̔{�� (1: ���̂܂�)
ZeroPaddingRatio = 4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �g�`�̓_���i�[���l�ߌ�j
Nb = Na * ZeroPaddingRatio;

% ���Ԏ�
dt = 1.0/fs;
ta = [0:Na-1]*dt;
tb = [0:Nb-1]*dt;

% Hann���i�n�j���O���j
Win = 0.5-0.5*cos(2*pi()*[0:Na-1]/Na);

% ��͑Ώۂ̔g�`�̏���
Siga_Rect = sin(2*pi()*freq*ta);
Sigb_Rect = [Siga_Rect zeros(1,Na*(ZeroPaddingRatio-1))];
Siga_Hann = sin(2*pi()*freq*ta) .* Win;
Sigb_Hann = [Siga_Hann zeros(1,Na*(ZeroPaddingRatio-1))];

% ���g����
fa = [0:Na-1]/(Na*dt);
fb = [0:Nb-1]/(Nb*dt);

% �\���p�E�B���h�E�̏���
fig1 = figure;
set(fig1,'Name','�[���l�߂������Ȃ����ꍇ�̗��U�t�[���G�ϊ��̃f��','position',[10 100 1800 900]);
timeaxis = [0 max(tb*1000) -1.1 1.1];

% ���̔g�`�̕\���i��`���j
subplot(2,2,1);
plot(tb*1000,Sigb_Rect,'ro-');
hold on;
plot(ta*1000,Siga_Rect,'k*--');
grid on;
axis(timeaxis);
title(sprintf('���̔g�`�i%d Hz�j�ɋ�`�����|�������� [ %d�_ �~ %d�{ = %d�_ ] ( fs = %d Hz )', freq, Na, ZeroPaddingRatio, Nb, fs));
ylabel('�U��');
xlabel('���� [ms]');
drawnow;

% ���̔g�`�̕\���iHann�����|�������́j
subplot(2,2,2);
plot(tb*1000,Sigb_Hann,'bo-');
hold on;
plot(ta*1000,Siga_Hann,'k*--');
grid on;
axis(timeaxis);
title(sprintf('���̔g�`�i%d Hz�j��Hann���i�n�j���O���j���|�������� [ %d�_ �~ %d�{ = %d�_ ] ( fs = %d Hz )', freq, Na, ZeroPaddingRatio, Nb, fs));
ylabel('�U��');
xlabel('���� [ms]');
drawnow;

% FFT
FFT_Siga_Rect = fft(Siga_Rect);
FFT_Sigb_Rect = fft(Sigb_Rect);
FFT_Siga_Hann = fft(Siga_Hann);
FFT_Sigb_Hann = fft(Sigb_Hann);

% dB�X�P�[���ɕϊ�
dB_Siga_Rect = 20*log10(abs(FFT_Siga_Rect)/max(abs(FFT_Sigb_Rect)));
dB_Sigb_Rect = 20*log10(abs(FFT_Sigb_Rect)/max(abs(FFT_Sigb_Rect)));
dB_Siga_Hann = 20*log10(abs(FFT_Siga_Hann)/max(abs(FFT_Sigb_Rect)));
dB_Sigb_Hann = 20*log10(abs(FFT_Sigb_Hann)/max(abs(FFT_Sigb_Rect)));

freqaxis = [0 fs/2 -80 10];

% �X�y�N�g���̕\���i��`���j
subplot(2,2,3);
plot(fb,dB_Sigb_Rect,'ro-');
hold on;
% bar(fa,dB_Siga_Rect,0.01,'k');
plot(fa,dB_Siga_Rect,'k*--');
grid on;
axis(freqaxis);
title(sprintf('��`�����|�����g�`�̐U���X�y�N�g�� ( ���g���𑜓x df = %.1f ����� %.1f Hz )',1/(Na*dt),1/(Nb*dt) ));
ylabel('���K�����ꂽ�U���X�y�N�g�� [dB]');
xlabel('���g�� [Hz]');
drawnow;

% �X�y�N�g���̕\���iHann���j
subplot(2,2,4);
plot(fb,dB_Sigb_Hann,'bo-');
hold on;
% bar(fa,dB_Siga_Hann,0.01,'k');
plot(fa,dB_Siga_Hann,'k*--');
grid on;
axis(freqaxis);
title(sprintf('Hann�����|�����g�`�̐U���X�y�N�g�� ( ���g���𑜓x df = %.1f ����� %.1f Hz )',1/(Na*dt),1/(Nb*dt) ));
ylabel('���K�����ꂽ�U���X�y�N�g�� [dB]');
xlabel('���g�� [Hz]');
drawnow;
