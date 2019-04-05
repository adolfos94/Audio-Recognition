close all;
clear all;
clc;

%1. Capturar Sonido Muestra

micro = audiorecorder(44100, 16, 2);
get(micro)

micro = audiorecorder;
disp('Grabando muestra..')
recordblocking(micro, 7);
disp('Fin de Grabacion..');

% 1.1 Arreglo de Bits muestra completa
% Store data in double-precision array.
datos = getaudiodata(micro);
% Save
audiowrite('template1.wav',datos,8000);

[T1,Fs1] = audioread('template1.wav');

%2. Capturar sonido test

disp('Grabando prueba..')
recordblocking(micro, 3);
disp('Fin de Grabacion..');

% 2.1 Arreglo de Bits muestra completa
% Store data in double-precision array.
datos = getaudiodata(micro);
audiowrite('sample.wav',datos,8000);

[S,Fs] = audioread('sample.wav');


% Correlacion cruzada de T1 con S
% siendo T1 el audio grabado
% siendo S el audio de muestra

[C1, lag1] = xcorr(T1,S);


    % Correlacion cruzada nos da un valor maximo que es la poscion donde
    % encuentra la simulitud
    [~,I] = max(abs(C1));
    SampleDiff = lag1(I)

    % La poscion entre frecuencia nos da el tiempo apartir del match    
    timeDiff = SampleDiff/Fs

    % Desfazamos la señal para que coincidan
    S1 = alignsignals(S,T1);
    
    playerObj = audioplayer(T1,Fs);
    play(playerObj,[SampleDiff,length(T1)]);

    figure(1)
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

