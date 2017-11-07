%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �A�x���[�W���O�ɂ��m�C�Y�����̃f�� for �d�q���p�i�_�ˍ���j
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
N  = 512;    % �g�`�̓_�� [�_]

% Target signal
amp  = 1.000;  % �M���̐U�� [arb.]
freq = 250.0;  % �M���̎��g�� [Hz]
burst = 10;    % �M���Ɋ܂܂��[�� [��]

% SNR�iS/N��j
SNR_dB = 6.0;  % S/N�� [dB]

% �A�x���[�W���O��
AveN = 128;    % �A�x���[�W���O�� [��]

% ��ʂ̏����������x
pause_s = 0.1;  % �����������x [s]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ���Ԏ�
dt = 1.0/fs;
t = [0:N-1]*dt;

% ���g����
df = 1/(N/fs);
f = [0:N-1]*df;

SNR_ratio = 10^(SNR_dB/20);

% �\���p�E�B���h�E�̏���
fig1 = figure;
set(fig1,'Name','�A�x���[�W���O�ɂ��m�C�Y�����̃f��','position',[10 100 1900 900]);

% ���̔g�`�̐���
Sig_clean = zeros(1,N);
Sig_clean(1:round(burst/freq*fs)) = amp * sin(2*pi()*freq*t(1:round(burst/freq*fs)) );

% ���̔g�`�i�m�C�Y�����j�̕\��
subplot(3,2,1);
plot(t,Sig_clean,'k-');
grid on;
axis([0 N/fs -amp*(1+1/SNR_ratio)*2.0 amp*(1+1/SNR_ratio)*2.0]);
title('���̔g�`�i�m�C�Y�����j�i�^�[�Q�b�g�j');
ylabel('�U��');
xlabel('���� [s]');

% ���̔g�`�i�m�C�Y�����j�̃X�y�N�g���̕\��
Sig_clean_fft_dB = 20*log10(abs(fft(Sig_clean.*hanning(N)')));
Sig_clean_fft_dB_norm = Sig_clean_fft_dB - max(Sig_clean_fft_dB);
subplot(3,2,2);
plot(f,Sig_clean_fft_dB_norm,'k-');
grid on;
axis([0 N*df/2 -55 5]);
title('���̔g�`�i�m�C�Y�����j�i�^�[�Q�b�g�j');
ylabel('���K�����ꂽ�U���X�y�N�g�� [dB]');
xlabel('���g�� [Hz]');
drawnow;

% �m�C�Y�t�^�ƃA�x���[�W���O
Sig_sum = zeros(1,N);

for i=1:AveN
    % �m�C�Y����g�`�̐���
    Sig_dirty = Sig_clean + amp/SNR_ratio*randn(1,N);

    % �m�C�Y����g�`�̕\��
    subplot(3,2,3);
    plot(t,Sig_dirty,'r-');
    grid on;
    axis([0 N/fs -amp*(1+1/SNR_ratio)*2.0 amp*(1+1/SNR_ratio)*2.0]);
    title(sprintf('�K�E�X�m�C�Y����̔g�` : SNR = %d dB',round(SNR_dB)));
    ylabel('�U��');
    xlabel('���� [s]');

    % �m�C�Y����g�`�̃X�y�N�g���̕\��
    Sig_dirty_fft_dB = 20*log10(abs(fft(Sig_dirty.*hanning(N)')));
    Sig_dirty_fft_dB_norm = Sig_dirty_fft_dB - max(Sig_clean_fft_dB);
    subplot(3,2,4);
    plot(f,Sig_dirty_fft_dB_norm,'r-');
    grid on;
    axis([0 N*df/2 -55 5]);
    title(sprintf('�K�E�X�m�C�Y����̔g�` : SNR = %d dB',round(SNR_dB)));
    ylabel('���K�����ꂽ�U���X�y�N�g�� [dB]');
    xlabel('���g�� [Hz]');

    % �A�x���[�W���O����
    Sig_sum = Sig_sum + Sig_dirty;
    Sig_ave = Sig_sum / i;

    % �A�x���[�W���O��̔g�`�̕\��
    subplot(3,2,5);
    plot(t,Sig_ave,'b-');
    grid on;
    axis([0 N/fs -amp*(1+1/SNR_ratio)*2.0 amp*(1+1/SNR_ratio)*2.0]);
    title(sprintf('�A�x���[�W���O��̔g�` : %d / %d ��',i,AveN));
    ylabel('�U��');
    xlabel('���� [s]');
    
    % �A�x���[�W���O��̔g�`�̃X�y�N�g���̕\��
    Sig_ave_fft_dB = 20*log10(abs(fft(Sig_ave.*hanning(N)')));
    Sig_ave_fft_dB_norm = Sig_ave_fft_dB - max(Sig_clean_fft_dB);
    subplot(3,2,6);
    plot(f,Sig_ave_fft_dB_norm,'b-');
    grid on;
    axis([0 N*df/2 -55 5]);
    title(sprintf('�A�x���[�W���O��̔g�` : %d / %d ��',i,AveN));
    ylabel('���K�����ꂽ�U���X�y�N�g�� [dB]');
    xlabel('���g�� [Hz]');
    drawnow;
    
    if i==1
        pause(2.0);
    else
        pause(pause_s);
    end

end


