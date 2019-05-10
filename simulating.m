close all; clear all; clc;

fid = fopen('text.txt');
file = fread(fid,'*char');
binary = dec2bin(file,8);
binary_t = transpose(binary);
bin = binary_t(:)-'0';

%>>>>>>>>> MATLAB code for binary FSK modulation >>>>>>>%

%bp=.000001;                                          % bit period
bp = 1/200;    % 100; 300      must find the right frequency for the signal!
fm = 100;    % modulating frequency (sea sound ~ 100 Hz)
 
%disp(' Binary information at Transmitter :');
%disp(bin);

% representation of transmitting binary information as digital signal
d = bin;
bit = []; 
for n = 1:1:length(d)
    if d(n) == 1
       se = ones(1,100);
    else d(n) == 0
        se = zeros(1,100);
    end
     bit = [bit se];
end

t1 = bp/100:bp/100:100*length(d)*(bp/100);
subplot(3,1,1);
plot(t1, bit, 'lineWidth', 2.5); grid on;
axis([ 0 bp*length(d) -.5 1.5]);
ylabel('Amplitude(V)');
xlabel(' Time(s)');
title('Transmitting information as digital signal');

% x = x / length(f);                  % signal normalization (any signal)

% Binary-FSK modulation %

A = 5;                                          % Amplitude of carrier signal
br = 1/bp;                                                         % bit rate (freq)
%f1 = br*8;                           % carrier frequency for information as 1
%f2 = br*2;                           % carrier frequency for information as 0
f1 = br + 1000;
f2 = br - 1000;
t2 = bp/99:bp/99:bp;                 
ss = length(t2);
m = [];

%fs = 44100;
%samples = [1,99];
clear fs
%[yA,fs] = audioread('OceanWaves.wav', samples);
[yA,fs] = audioread('OceanWaves.wav');
yA_seg = [1:44100*(1/445)];  % 0 to 40s
%yA = yA / length(d);         % signal normalization
%mod = bit.*yA;    % message * white noise (sound)

%audiowrite('Fast.wav', yA, fs*2);
%audiowrite('Fast.wav', yA, fs + (10*fm));
%audiowrite('Slow.wav', yA, fs/2);
%audiowrite('Slow.wav', yA, fs - (10*fm));
%[yF,fF] = audioread('Fast.wav');
%[yS,fS] = audioread('Slow.wav');

for (i=1:1:length(d))
    
    if (d(i) == 1)
        %y = A*cos(2*pi*f1*t2);     % alter carrier (freq) accordingly
        y = (A*cos(2*pi*f1*t2)).*yA_seg;
        %yR = yF*d(i);
    else
        %y = A*cos(2*pi*f2*t2);     % alter carrier (freq) accordingly
        y = (A*cos(2*pi*f2*t2)).*yA_seg;
        %yR = yS*d(i);
    end
    
    m = [m y];
end

%m = transpose(m);
t3 = bp/99:bp/99:bp*length(bin);
%t3 = 0:1:39;
subplot(3,1,2);
plot(t3,m);
xlabel('Time(s)');
ylabel('Amplitude(V)');
title('Waveform for binary FSK modulation coresponding to binary information');

% ----------------------------------------------------------------------- %
audiowrite('TRsound.wav', m, 1200);
[yOut,fs2] = audioread('TRsound.wav');

% Display the sampling info and length
sz2 = size(yOut);
n2  = sz2(1);
%fprintf('File: %s\nSamples: %d\nTime   : %d s\n',fname,n,n/fs);

% If longer than 500,000 samples cut if down else things are too slow!
if (n2>500000)
   n2=500000;
   %fprintf('Samples cropped to %d\n',n);
end

% create time stamps for graph
x2 = [0:1/fs2:(n2-1)/fs2];

% Display the graph
plot(x2,yOut(1:n2));

% Play the sea sound
player2 = audioplayer(yOut,fs2);
%play(player2);
