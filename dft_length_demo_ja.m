%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DFT���̐M�����̃f�� for �d�q���p�i�_�ˍ���j
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
Nmin = 8;    % �ŒZ�̔g�`�_�� [�_]
Nmax = 1200; % �Œ��̔g�`�_�� [�_]

amp1  = 0.200;  % �M���P: �U�� [arb.]
freq1 = 345.0;  % �M���P: ���g�� [Hz]

amp2  = 0.800;  % �M���Q: �U�� [arb.]
freq2 = 456.0;  % �M���Q: ���g�� [Hz]

Ninc  = 1.1;   % �_�� N �̑��� [��]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �\���p�E�B���h�E�̏���
fig1 = figure;
set(fig1,'Name','DFT���̐M�����̃f��','position',[10 100 1900 900]);

dt = 1.0/fs;

% ���Ԏ�
t = [0:Nmax-1]*dt;

% ���̐M���̐���
Sig = amp1*sin(2*pi()*freq1*t) + amp2*sin(2*pi()*freq2*t);

timeaxis = [0 (Nmax-1)*dt*1000 -abs((amp1+amp2)*1.1) abs((amp1+amp2)*1.1)];
freqaxis = [0 fs -90 50];

N = Nmin;

while Nmin <= N && N < Nmax

    Sig_Hann = Sig(1:N).*hanning(N)';
    
    % �g�`�̕\��
    subplot(2,1,1);
    hold off;
    plot(t*1000,Sig,'k-');
    hold on;
    plot(t(1:N)*1000,hanning(N'),'g-');
    plot(t(1:N)*1000,-hanning(N'),'g-');
    plot(t(1:N)*1000,Sig_Hann,'bo-');
    grid on;
    axis(timeaxis);
    title(sprintf('���̔g�` ( %d Hz & %d Hz @ fs = %d Hz ) : N = %d�_ �� �M���� = %.2f ms',round(freq1),round(freq2),round(fs),round(N),N*dt*1000));
    ylabel('�U��');
    xlabel('���� [ms]');

    % �X�y�N�g���̕\���i�A���g�`�j
    f = [0:round(N)-1]/(round(N)*dt);
    subplot(2,1,2);
    stem(f,20*log10(abs(fft(Sig_Hann))),'bo-','BaseValue',-100);
    grid on;
    axis(freqaxis);
    title(sprintf('�U���X�y�N�g�� ( ���g���𑜓x df = %.2f Hz )',1/(N*dt)));
    ylabel('�U���X�y�N�g�� [dB]');
    xlabel('���g�� [Hz]');
    drawnow;

    % ���̍Đ�
    sound([zeros(1,0.1*fs) Sig_Hann/((amp1+amp2)*1.1) zeros(1,0.1*fs)],fs);
    pause(N*dt+0.2);
    
    % N �̑����܂��͌���
    if Ninc > 1.0
        N = ceil(N * Ninc);
        if N > Nmax
            Ninc = 1/Ninc;
        end
    end
    if Ninc < 1.0
        N = floor(N * Ninc);
    end

end
