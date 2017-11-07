%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �A�x���[�W���O�ɂ��ʎq�����x����̃f�� for �d�q���p�i�_�ˍ���j
%  (Matlab/Octave�œ��삵�܂�)
%    by Yoshiki NAGATANI, Kobe City College of Technology�i���J �F���j
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170725: First version
%   rev. 20171107: ���{���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% ���̕�����ҏW���ĉ����� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �g�`�̐ݒ�
fs = 8000;   % �T���v�����O���[�g [Hz]
N  = 128;    % �g�`�̓_�� [�_]

% �^�[�Q�b�g�g�`
amp  = 2.50;    % �M���̐U�� [arb.]
freq = 300.0;   % �M���̎��g�� [Hz]
burst = 4;      % �M���Ɋ܂܂��[�� [��]

% �m�C�Y
amp_noise = 1.0;  % Amplitude of noise

% �A�x���[�W���O��
AveN = 128;       % �A�x���[�W���O�� [��]

% ��ʂ̏����������x
pause_s = 0.1;  % �����������x [s]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ���Ԏ�
dt = 1.0/fs;
t = [0:N-1]*dt;

% ���g����
df = 1/(N/fs);
f = [0:N-1]*df;

% �\���p�E�B���h�E�̏���
fig1 = figure;
set(fig1,'Name','�A�x���[�W���O�ɂ��ʎq�����x����̃f��','position',[10 100 1900 900]);

% ���̔g�`�i�m�C�Y�����j�̐���
Sig_original = zeros(1,N);
Sig_original(1:round(burst/freq*fs)) = (amp * sin(2*pi()*freq*t(1:round(burst/freq*fs))));
Sig_quantized = round(Sig_original);

% ���̔g�`�i�m�C�Y�����j�̕\��
subplot(3,1,1);
plot(t,Sig_original,'g--');
hold on;
plot(t,Sig_quantized,'ko-');
grid on;
axis([0 N/fs -(amp+amp_noise) (amp+amp_noise)]);
title('�ʎq�����ꂽ���̔g�`�i�m�C�Y�����j');
ylabel('�U��');
xlabel('���� [s]');
drawnow;

% �m�C�Y�t�^�ƃA�x���[�W���O
Sig_sum = zeros(1,N);

for i=1:AveN
    % �m�C�Y����g�`�̐���
    Sig_dirty = round(Sig_original + amp_noise*(rand(1,N)-0.5));

    % �m�C�Y����g�`�̕\��
    subplot(3,1,2);
    hold off;
    plot(t,Sig_original,'g--');
    hold on;
    plot(t,Sig_dirty,'ro-');
    grid on;
    axis([0 N/fs -(amp+amp_noise) (amp+amp_noise)]);
    title(sprintf('�ʎq�����ꂽ�g�`�i�m�C�Y�L��j : SNR = %d dB',round(20*log10(amp/amp_noise))));
    ylabel('�U��');
    xlabel('���� [s]');

    % �A�x���[�W���O����
    Sig_sum = Sig_sum + Sig_dirty;
    Sig_ave = Sig_sum / i;

    % �A�x���[�W���O��̔g�`�̕\��
    subplot(3,1,3);
    hold off;
    plot(t,Sig_original,'g--');
    hold on;
    plot(t,Sig_ave,'bo-');
    grid on;
    grid minor;
    axis([0 N/fs -(amp+amp_noise) (amp+amp_noise)]);
    title(sprintf('�A�x���[�W���O��̔g�` : %d / %d ��',i,AveN));
    ylabel('�U��');
    xlabel('���� [s]');
    drawnow;
    
    if i==1
        pause(2.0);
    else
        pause(pause_s);
    end

end


