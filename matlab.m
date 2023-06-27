%% 振動解析授業用ｍファイル
% a m-file for the class of vibration analysis

% 運動方程式　my"(t)+cy'(t)+ky(t)=F0exp(iwt) の解を時刻歴波形で表示
% Time history curve of an equation of motion

% 2012.11.8  Y. Miyamori
% 2021.5.19 Y. Miyamori 内容の見直しと修正
% 2023.5.2 Y. Miyamori Add comments in English

clear
close all

%% 入力条件 Inputs
% m:質量 mass、k:剛性 stiffness、c:粘性減衰係数 damping coeeficient
% F0:入力外力の振幅 amplitude of input
% w:入力外力の円振動数（固有振動数ではない） circular frequency of input
% t:時間軸 time axis
% 自由振動の場合はF0=0とする。 Set F0=0 for free vibration
m = 4;
k = 50;
c = 1;
F0 = 1;
w = 3;
% w = sqrt(k/m); % 共振させる場合 for resonance
t = 0:0.01:50;

% 初期条件 Intial conditoins
y0 = 0.1;  %初期変位 initial displacement
yd0 = 0; %初期速度 initial vibration

%% 基本的特性 Fundamental characteristics
% 静的変位、固有振動数と減衰定数
% static displacement, natular frequency, damping ratio
yst = F0/k;
p = sqrt(k/m);
h = c/(2*sqrt(k*m));
p1 = p*sqrt(1-h^2);

%% 動的応答倍率 Dynamic Amplitude Factor と強制振動の振幅、位相差
DAF = 1/(sqrt((1-(w/p)^2)^2+(2*h*(w/p))^2));
Y = yst*DAF; % amplitude of forced excitation
fai = atan(2*h*(w/p)/(1-(w/p)^2)); % phase lag

%% 積分定数(C1,C2) Intefral constants
C2 = (yd0-Y*1i*w*exp(-1i*fai)+(y0-Y*exp(-1i*fai))*(p*h-1i*p1))/(-2*1i*p1);
C1 = y0-Y*exp(-1i*fai)-C2;

%% 過渡応答 Transient response
% 自由振動（同次解） free vabration (homogeneous solution)
yh = C1*exp((-p*h+1i*p1).*t)+C2*exp((-p*h-1i*p1).*t);
% 強制振動（特解） force vibration (particular solution)
yp = Y*exp(1i*(w.*t-fai));
% 過渡応答 total response (general solution)
y = yh+yp;

    
%% 描画 Visualization
figure
plot3(t,imag(yh),real(yh),t,imag(yp),real(yp),t,imag(y),real(y),'LineWidth',2.0); grid on;
xlabel('time','FontSize',20)
ylabel('imag(y)','FontSize',20)
zlabel('real(y)','FontSize',20)
%title(['固有円振動数　p=',num2str(p),', p1=',num2str(p1),', 加振円振動数　w=',num2str(w),' 減衰定数　h=',num2str(h)],'FontSize',14)
%legend('自由振動解','強制振動解','過渡応答')
title(['Nat. Circular Freq. p=',num2str(p),', p1=',num2str(p1),', Excit. Circular Freq. w=',num2str(w),' Damping Ratio h=',num2str(h)],'FontSize',14)
legend('Homogeneous Response','Particular Response','Total Response','Location','Northeast')
%view([0,-90,0]) % 時間軸-実軸で見る場合はこの行を生かす for real axis
%view([0,0,90]) % 時間軸-虚軸で見る場合はこの行を生かす for imaginary axis
