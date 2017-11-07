%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sinc�֐��̏�ݍ��݂ɂ��A�b�v�T���v�����O�̃f�� for �d�q���p�i�_�ˍ���j
%  (Matlab/Octave�œ��삵�܂�)
%    by Yoshiki NAGATANI, Kobe City College of Technology�i���J �F���j
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170509: First version
%   rev. 20170509b: Show the repetition of frequency component
%   rev. 20170530: Use stem function
%   rev. 20171107: ���{���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% ���̕�����ҏW���ĉ����� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���̔g�`
Sig = [0 0 0 0 0 -1 1 -3 3 -4 5 0 0 0 0 0];

% �A�b�v�T���v�����O�̔{�� [�{]
UpsamplingRatio = 8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �g�`�̓_���Ǝ��ԉ𑜓x
Na = size(Sig,2);
dta = 1;
Nb = Na * UpsamplingRatio;
dtb = dta / UpsamplingRatio;

% ���Ԏ�
ta = [0:Na-1]*dta;
tb = [0:Nb-1]*dtb;

% ���g����
fa = [0:Na-1]*dta;
fb = [0:Nb-1]*dta;

% �\���p�E�B���h�E�̏���
fig1 = figure;
set(fig1,'Name','Sinc�֐��̏�ݍ��݂ɂ��A�b�v�T���v�����O�̃f��','position',[10 100 1900 900]);

% ���̔g�`�̕\��
subplot(3,2,1);
plot(ta,Sig,'ko-');
grid on;
axis([0 Na min(Sig)*1.2 max(Sig)*1.2]);
title([sprintf('���̔g�` [ %d �_: ',Na) sprintf('%d ',Sig) ']']);
ylabel('�U��');
xlabel('���� [�_]');
drawnow;

% ���̔g�`�̃X�y�N�g���̕\��
FFT_Sig = fft(Sig)/Na;
FFT_Sig_repeat = FFT_Sig;
for i=2:UpsamplingRatio
    FFT_Sig_repeat = [FFT_Sig_repeat FFT_Sig];
end
subplot(3,2,2);
stem(fb,abs(FFT_Sig_repeat),'k');
grid on;
axis([0 Nb 0 max(abs(FFT_Sig_repeat))*1.2]);
title('���̔g�`�̐U���X�y�N�g��');
ylabel('�U���X�y�N�g��');
xlabel('���g���i�g�̐��j');
drawnow;

% ���̔g�`�̕\��
subplot(3,2,3);
stem(ta,Sig','k');
hold on;
grid on;
axis([0 Na min(Sig)*1.2 max(Sig)*1.2]);
title('�e�_�ɑΉ����� Sinc �֐�');
ylabel('�U��');
xlabel('���� [�_]');
drawnow;

% Sinc �֐��̌v�Z�ƕ\��
for n=1:Na
    % Sinc �֐�
    sincwaves(:,n) = Sig(n)*sinc(tb-(n-1));
    % �g�`�̕\��
    subplot(3,2,3);
    plot(tb,sincwaves(:,n),'-');
    drawnow;
end;

% Sinc �֐��̔g�`�̍��v
UpsampledWave = sum(sincwaves,2);

% �g�`�̕\��
subplot(3,2,5);
stem(ta,Sig','k');
hold on;
grid on;
axis([0 Na min(Sig)*1.2 max(Sig)*1.2]);
title('���̔g�` ����� �A�b�v�T���v�����O���ꂽ�g�`�i�S�Ă� Sinc �֐��̍��v�j');
ylabel('�U��');
xlabel('���� [�_]');
drawnow;

% �A�b�v�T���v�����O���ꂽ�g�`�̕\��
subplot(3,2,5);
plot(tb,UpsampledWave','r*-');
drawnow;

% �A�b�v�T���v�����O���ꂽ�g�`�̃X�y�N�g���̕\��
FFT_UpsampledWave = fft(UpsampledWave)/Nb;
subplot(3,2,6);
stem(fb,abs(FFT_UpsampledWave),'r');
grid on;
axis([0 Nb 0 max(abs(FFT_UpsampledWave))*1.2]);
title('�A�b�v�T���v�����O���ꂽ�g�`�̐U���X�y�N�g��');
ylabel('�U���X�y�N�g��');
xlabel('���g���i�g�̐��j');
