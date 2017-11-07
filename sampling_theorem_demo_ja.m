%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �T���v�����O�藝�̃f�� for �d�q���p�i�_�ˍ���j
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
fs = 8000;  % �T���v�����O���[�g [Hz]
N  = 800;   % �g�`�̓_�� [�_]

amp  = 1.000;    % �M���̐U�� [arb.]
freqmin =  200;  % �M���̍Œ���g�� [Hz]
freqmax = 7800;  % �M���̍ō����g�� [Hz]

freqinc  = 50; % ���g���̑��� [Hz]
UpsamplingRatio = 16;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �\���p�E�B���h�E�̏���
fig1 = figure;
set(fig1,'Name','�T���v�����O�藝�̃f��','position',[10 100 1900 900]);

dt = 1/fs;

% ���Ԏ�
t1 = [0:N-1]*dt;
t2 = [0:(N*UpsamplingRatio)-1]*(dt/UpsamplingRatio);

% ���g����
f = [-N*2:N*2-1]/(N*dt);

timeaxis = [0 (N-1)*dt*1000/16 -abs(amp*1.1) abs(amp*1.1)];
freqaxis = [-fs*2/1000 fs*2/1000 -40 60];

freq = freqmin;

while freq <= freqmax

    % �M���̐���
    Sig1 = amp*sin(2*pi()*freq*t1);
    Sig2 = amp*sin(2*pi()*freq*t2);
   
    Sig1Hann = Sig1.*hann(N)';
    
    % �g�`�̕\��
    subplot(2,1,1);
    hold off;
    plot(t2*1000,Sig2,'b-');
    hold on;
    stem(t1*1000,Sig1,'ko--');
    plot(t1*1000,Sig1,'k-');
    grid on;
    grid minor;
    axis(timeaxis);
    title(sprintf('���̐M���g�` ����� �T���v�����O���ꂽ�M���̔g�`�i %d Hz @ fs = %d Hz )',round(freq),round(fs)));
    ylabel('�U��');
    xlabel('���� [ms]');

    % �X�y�N�g���̕\��
    subplot(2,1,2);
    Sig1FFTdB = 20*log10(abs(fft(Sig1Hann)));
    hold off;
    stem(freq/1000,100,'b--','BaseValue',-100);
    hold on;
    stem((fs-freq)/1000,100,'r--','BaseValue',-100);
    stem([-fs 0 fs]/1000,[1 1 1]*100,'k-','BaseValue',-100);
    stem([-3*fs/2 -fs/2 fs/2 3*fs/2]/1000,[1 1 1 1]*100,'k--','BaseValue',-100);
    plot(f/1000,[Sig1FFTdB Sig1FFTdB Sig1FFTdB Sig1FFTdB],'k-');
    grid on;
    grid minor;
    axis(freqaxis);
    title(sprintf('�T���v�����O���ꂽ�M���iHann�����|�������́j�̐U���X�y�N�g��'));
    ylabel('�U���X�y�N�g�� [dB]');
    xlabel('���g�� [kHz]');
    xtics = [-4:1:4]*fs/2/1000;
    set(gca,'XTick',xtics);
    drawnow;

    % ���̍Đ�
    sound(Sig1Hann/(amp*1.1),fs);
    pause(N*dt+0.1);
    
    % ���g���̏㉺
    if (fs/2*0.95 < freq && freq < fs/2*1.05)
        freq = freq + freqinc/5; % �ω�����������
    else   
        freq = freq + freqinc;
    end
    
end

