%% SUSPENSAO - BACKWARD EULER - MATLAB R2018b
% Execute ESTE arquivo inteiro. Nao depende de nenhum outro arquivo .m.
% Usa subplot em vez de tiledlayout e saveas em vez de exportgraphics.

clear;
close all;
clc;
disp('EXECUTANDO: suspensao_BE_R2018b_SCRIPT_UNICO.m');

%% 1. Modelo fisico: massa, amortecedor, mola
% m*d2x/dt2 + c*dx/dt + k*x = F(t)
% x: deslocamento vertical em metros; F: forca equivalente em newtons.

m = 250;                 % kg
c = 1500;                % N*s/m
k = 15000;               % N/m
F0 = 1000;               % N, amplitude do degrau de forca
instante_degrau = 0.5;   % s
T = 0.01;                % s, periodo de amostragem
tempo_final = 8;         % s

%% 2. Derivacao por Backward Euler, SEM variaveis de estado
% Primeira derivada:  dx[n] = (x[n] - x[n-1])/T.
% Primeira derivada na amostra anterior:
%                     dx[n-1] = (x[n-1] - x[n-2])/T.
% Aplicar backward outra vez a primeira derivada:
% d2x[n] = (dx[n] - dx[n-1])/T
%         = (x[n] - 2*x[n-1] + x[n-2])/T^2.
%
% Substituir no modelo:
% (m/T^2)*(x[n]-2*x[n-1]+x[n-2])
% + (c/T)*(x[n]-x[n-1]) + k*x[n] = F[n].
%
% Reunir os termos em x[n] e isolar a nova amostra:
% x[n] = ( F[n] + (2*m/T^2+c/T)*x[n-1] - (m/T^2)*x[n-2] )
%        / (m/T^2 + c/T + k).

%% 3. Simular a equacao de diferencas
t = (0:T:tempo_final)';
F = F0 * double(t >= instante_degrau);
x = zeros(size(t));

% Condicoes iniciais x[0] = 0 e velocidade[0] = 0.
% Pela diferenca backward, x[-1] = x[0] - T*velocidade[0] = 0.
x_anterior_ao_inicio = 0;
A = 2*m/T^2 + c/T;
B = m/T^2;
D = m/T^2 + c/T + k;

% MATLAB indexa a partir de 1: x(1) e x[0]; x(2) e x[1].
x(2) = (F(2) + A*x(1) - B*x_anterior_ao_inicio)/D;
for n = 3:length(t)
    x(n) = (F(n) + A*x(n-1) - B*x(n-2))/D;
end

% Obter as derivadas do proprio deslocamento, por diferencas backward.
velocidade = zeros(size(t));
aceleracao = zeros(size(t));
for n = 2:length(t)
    velocidade(n) = (x(n)-x(n-1))/T;
    aceleracao(n) = (velocidade(n)-velocidade(n-1))/T;
end

%% 4. Figuras (comandos disponiveis no MATLAB R2018b)
if exist('figuras', 'dir') ~= 7
    mkdir('figuras');
end

f1 = figure('Color','w');
subplot(2,1,1);
stairs(t,F,'LineWidth',1.5);
grid on;
xlabel('Tempo (s)'); ylabel('Forca (N)');
title('Forca vertical equivalente: degrau em 0,5 s');
subplot(2,1,2);
plot(t,1000*x,'b','LineWidth',1.5);
hold on;
plot([t(1) t(end)],[1000*F0/k 1000*F0/k],'r--');
hold off;
grid on;
xlabel('Tempo (s)'); ylabel('Deslocamento (mm)');
title('Resposta vertical por Backward Euler');
legend('Resposta','Equilibrio F/k');
saveas(f1,fullfile('figuras','01_forca_e_deslocamento.png'));

f2 = figure('Color','w');
subplot(3,1,1);
plot(t,1000*x,'LineWidth',1.4); grid on;
ylabel('x (mm)'); title('Deslocamento');
subplot(3,1,2);
plot(t,velocidade,'LineWidth',1.4); grid on;
ylabel('dx/dt (m/s)'); title('Primeira diferenca backward');
subplot(3,1,3);
plot(t,aceleracao,'LineWidth',1.4); grid on;
xlabel('Tempo (s)'); ylabel('d2x/dt2 (m/s2)');
title('Backward aplicado novamente a primeira derivada');
saveas(f2,fullfile('figuras','02_derivadas.png'));

%% 5. Comparar tres periodos sem funcoes auxiliares
f3 = figure('Color','w');
hold on;
periodos = [0.01 0.05 0.10];
for j = 1:length(periodos)
    Tj = periodos(j);
    tj = (0:Tj:tempo_final)';
    Fj = F0*double(tj >= instante_degrau);
    xj = zeros(size(tj));
    Aj = 2*m/Tj^2 + c/Tj;
    Bj = m/Tj^2;
    Dj = m/Tj^2 + c/Tj + k;
    xj(2) = (Fj(2) + Aj*xj(1) - Bj*x_anterior_ao_inicio)/Dj;
    for n = 3:length(tj)
        xj(n) = (Fj(n) + Aj*xj(n-1) - Bj*xj(n-2))/Dj;
    end
    plot(tj,1000*xj,'LineWidth',1.4);
end
hold off;
grid on;
xlabel('Tempo (s)'); ylabel('Deslocamento (mm)');
title('Influencia do periodo de amostragem');
legend('T = 0,01 s','T = 0,05 s','T = 0,10 s');
saveas(f3,fullfile('figuras','03_periodos.png'));

fprintf('Equilibrio teorico: %.2f mm\n',1000*F0/k);
fprintf('Posicao final: %.2f mm\n',1000*x(end));
fprintf('Pico de deslocamento: %.2f mm\n',1000*max(x));
disp('CONCLUIDO: figuras salvas na subpasta figuras.');
