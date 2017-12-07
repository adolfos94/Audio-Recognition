
%1. Capturar Sonido Muestra

micro = audiorecorder(44100, 16, 2);
get(micro)

micro = audiorecorder;
disp('Grabando muestra..')
recordblocking(micro, 90);
disp('Fin de Grabacion..');

% 1.1 Arreglo de Bits muestra completa
% Store data in double-precision array.
datos = getaudiodata(micro);
% Save
audiowrite('template1.wav',datos,8000);

[T1,Fs1] = audioread('template1.wav');


%2. Capturar Sonido Muestra

disp('Grabando prueba..')
recordblocking(micro, 90);
disp('Fin de Grabacion..');

% 2.1 Arreglo de Bits muestra completa
% Store data in double-precision array.
datos = getaudiodata(micro);
audiowrite('template2.wav',datos,8000);

[T2,Fs2] = audioread('template2.wav');

%3. Capturar sonido test

disp('Grabando prueba..')
recordblocking(micro, 45);
disp('Fin de Grabacion..');

% 3.1 Arreglo de Bits muestra completa
% Store data in double-precision array.
datos = getaudiodata(micro);
audiowrite('sample.wav',datos,8000);

[S,Fs] = audioread('sample.wav');

[C1, lag1] = xcorr(T1,S);
[C2, lag2] = xcorr(T2,S);

figure(2)
ax(1) = subplot(2,1,1);
plot(lag1/Fs,C1,'m')
ylabel('Amplitud')
grid on
title('Diferencia Muestra 1 con la Prueba')
ax(2) = subplot(2,1,2);
plot(lag2/Fs,C2,'r')
ylabel('Amplitud')
grid on
title('Diferencia Muestra 2 con la Prueba')
xlabel('Tiempo (segundos)')
axis(ax(1:2),[-5 5 -10 10])

if(max(abs(C2)) > max(abs(C1)))

    [~,I] = max(abs(C2));
    SampleDiff = lag2(I)

    timeDiff = SampleDiff/Fs

    S1 = alignsignals(S,T2);
    
    playerObj = audioplayer(T2,Fs);
    play(playerObj,[SampleDiff,length(T2)]);
    
    figure(3)
    ax(1) = subplot(2,1,1);
    plot(T2)
    grid on 
    title('T2')
    axis tight
    ax(2) = subplot(2,1,2);
    plot(S1)
    grid on 
    title('S')
    axis tight
    linkaxes(ax,'xy')
else
    [~,I] = max(abs(C1));
    SampleDiff = lag1(I)

    timeDiff = SampleDiff/Fs

    S1 = alignsignals(S,T1);
    
    playerObj = audioplayer(T1,Fs);
    play(playerObj,[SampleDiff,length(T1)]);

    figure(4)
    ax(1) = subplot(2,1,1);
    plot(T1)
    grid on 
    title('T1')
    axis tight
    ax(2) = subplot(2,1,2);
    plot(S1)
    grid on 
    title('S')
    axis tight
    linkaxes(ax,'xy')
end

figure(1)
ax(1) = subplot(3,1,1);
plot((0:numel(T1)-1)/Fs1,T1)
ylabel('Muestra 1')
grid on
ax(2) = subplot(3,1,2);
plot((0:numel(T2)-1)/Fs2,T2)
ylabel('Muestra 2')
grid on
ax(3) = subplot(3,1,3);
plot((0:numel(S)-1)/Fs,S)
ylabel('Signal')
grid on
xlabel('Tiempo (segundos)')
linkaxes(ax(1:3),'x')
axis([0 5 -1 1])