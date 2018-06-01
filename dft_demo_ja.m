%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���U�t�[���G�ϊ��iDFT�j�̃f�� for �d�q���p�i�_�ˍ���j
%  (Matlab/Octave�œ��삵�܂�)
%    by Yoshiki NAGATANI, Kobe City College of Technology�i���J �F���j
%    https://github.com/nagataniyoshiki
% 
%   rev. 20170509: First version
%   rev. 20170530: Use stem function
%   rev. 20171107: ���{���
%   rev. 20180601: ��ԉ��̃O���t�ȊO�̉������폜
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% ���̕�����ҏW���ĉ����� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �g�`�̐ݒ�
Sig = [-1 1 -3 3 -4 5 0 0];

% �\������g�`�̐�
Waves = 12;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �g�`�̓_���Ǝ��ԉ𑜓x
Na = size(Sig,2);
dta = 1;
smoothsampling = 40;
Nb = Na * smoothsampling;
dtb = dta / smoothsampling;

% ���Ԏ�
ta = [0:Na-1]*dta;
tb = [0:Nb-1]*dtb;

% �\���p�E�B���h�E�̏���
fig1 = figure;
set(fig1,'Name','���U�t�[���G�ϊ��iDFT�j�̃f��: �g�`','position',[10 60 800 940]);

% ���̔g�`�̕\��
subplot(Waves+2,2,1);
plot(ta,Sig,'ko--');
grid on;
axis([0 Na min(Sig) max(Sig)]);
title([sprintf('���̔g�` [ %d �_: ',Na) sprintf('%d ',Sig) ']']);
subplot(Waves+2,2,2);
plot(ta,Sig,'ko--');
grid on;
axis([0 Na min(Sig) max(Sig)]);
title([sprintf('���̔g�` [ %d �_: ',Na) sprintf('%d ',Sig) ']']);

drawnow;

% �t�[���G�W���̌v�Z�ƕ\��
for n=0:Waves-1
    % ����: cos(2*pi*f*n/N) %%%%%%%%%%%%
    cosa = cos(2*pi()*n*ta/Na);
    cosb = cos(2*pi()*n*tb/Na);
    coefreal(n+1) = sum(Sig.*cosa);
    % �g�`�̕\��
    subplot(Waves+1,2,3+n*2);
    plot(ta,cosa,'k--');
    hold on;
    plot(ta,cosa,'ro');
    plot(tb,cosb,'r-');
    grid on;
    axis([0 Na -1 1]);
    title(sprintf('cos(2*pi*%d*n/%d) : �t�[���G�W�� = %.3f',n,Na,coefreal(n+1)));
    % ���̃��x��
    if n == round((Waves-1)/2)
        ylabel('�U��');
    end
    if n == Waves-1
        xlabel('���� [�_]');
    end

    % ����: sin(2*pi*f*n/N) %%%%%%%%%%%%
    sina = -sin(2*pi()*n*ta/Na);
    sinb = -sin(2*pi()*n*tb/Na);
    coefimag(n+1) = sum(Sig.*sina);
    % �g�`�̕\��
    subplot(Waves+1,2,4+n*2);
    plot(ta,sina,'k--');
    hold on;
    plot(ta,sina,'bo');
    plot(tb,sinb,'b-');
    grid on;
    axis([0 Na -1 1]);
    title(sprintf('-sin(2*pi*%d*n/%d) : �t�[���G�W�� = %.3fi',n,Na,coefimag(n+1)));
    % ���̃��x��
    if n == round((Waves-1)/2)
        ylabel('�U��');
    end
    if n == Waves-1
        xlabel('���� [�_]');
    end
    
    drawnow;
end;

% ��ԉ��̃O���t�ȊO�̉������폜
Axes= findall(gcf,'type','axes');
set(Axes(3:end),'xticklabel','');
drawnow;

% �t�[���G�W�� = ���� + i*����
DFT = coefreal + 1i*coefimag;
disp('DFT���� (�蓮�Ōv�Z��������)')
DFT.'

% DFT���ʂ̕\��
fig2 = figure;
set(fig2,'Name','���U�t�[���G�ϊ��iDFT�j�f��: DFT����','position',[820 300 500 700]);

subplot(3,1,1);
stem([0:Waves-1], real(DFT)','k');
grid on;
axis([-0.5 Waves-0.5 -max(abs(DFT)*1.1) max(abs(DFT)*1.1)]);
title('DFT (����)');
ylabel('�U��');

subplot(3,1,2);
stem([0:Waves-1], imag(DFT)','b');
grid on;
axis([-0.5 Waves-0.5 -max(abs(DFT)*1.1) max(abs(DFT)*1.1)]);
title('DFT (����)');
ylabel('�U��');

subplot(3,1,3);
stem([0:Waves-1], abs(DFT)','k');
grid on;
axis([-0.5 Waves-0.5 0 max(abs(DFT)*1.1)]);
title('DFT (��Βl)');
ylabel('�U���X�y�N�g��');
xlabel('�g�̐� [��]');

% FFT���ʂƂ̔�r (Matlab/Octave�ŗp�ӂ���Ă���֐��Ƃ̔�r)
disp('FFT���ʂƂ̔�r (Matlab/Octave�ŗp�ӂ���Ă���֐��Ƃ̔�r)')
FFT = fft(Sig).'
