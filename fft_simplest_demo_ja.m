%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �ł��V���v���� FFT �̃f�� for �d�q���p�i�_�ˍ���j
%  (Matlab/Octave�œ��삵�܂�)
%    by Yoshiki NAGATANI, Kobe City College of Technology�i���J �F���j
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170724: First version
%   rev. 20171107: ���{���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% ���̕�����ҏW���ĉ����� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �g�`�̐ݒ�
fs = 8000;     % �T���v�����O���[�g [Hz]
N  = 128;      % �g�`�̓_�� [�_]

amp  = 1.00;   % �M���̐U�� [arb.]
freq = 440.0;  % �M���̎��g�� [Hz]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dt = 1/fs;     % ���ԉ𑜓x [s]

% �\���p�E�B���h�E�̏���
fig1 = figure;
set(fig1,'Name','�ł��V���v���� FFT �̃f��','position',[10 100 1200 900]);

% ���Ԏ�
t = [0:N-1]*dt;

% �g�`�̐���
Sig = amp * sin(2*pi()*freq*t);

% �g�`�̕\��
subplot(2,1,1);
plot(t,Sig,'ko-');
grid on;
title('���̔g�`');
ylabel('�U��');
xlabel('���� [s]');

% FFT
SigFFT = fft(Sig);

% ���g����
f = [0:N-1]/(N*dt);   % N*dt = ���Ԓ� [s]

% �X�y�N�g���̕\��
subplot(2,1,2);
plot(f,abs(SigFFT),'ko-');
grid on;
title('�U���X�y�N�g��');
ylabel('�U���X�y�N�g��');
xlabel('���g�� [Hz]');

% ���̍Đ�
soundsc(Sig,fs);
