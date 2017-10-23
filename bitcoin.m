% Simulação Modelo Bitcoin
%  por A. Newton Licciardi
%
q=0.4;
% q - probabilidade do atacante ter sucesso em encontrar o proximo bloco 
p=1-q;
% probibilidade do no honesto encontrar o proximo bloco
z=10;
% z - tamanho do bloco que se espero que o atacante seja capaz de alcancar os nos honestos
% grafico qz - probabilidade em que se espero que o atacante consiga
% alcançar os nós honestos estando z nós atras

% grafico 1
n=101; %n- numero de pontos
q=zeros(n,1);
p=zeros(n,1);
qz=zeros(n,1);
for i=1:n
    q(i)=(i-1)/(n-1);
    p(i)=1-q(i);
    if p(i)>q(i)
        qz(i)=(q(i)/p(i))^z;
    else
        qz(i)=1;
    end
end

%figura(1)
clf;
plot(q,qz);
xlabel('q - p do atacante encontrar o proximo bloco');
yl=(sprintf('qz - p atacante alcançar nós honestos em %d nós', z));
ylabel(yl);
title('Prababilidade do Atacante ter sucesso - modelo Bitcoin');    
hold on;
stem (1, 1.2,'b');
hold off;

% distribuição de Poisson
lambda=zeros(length(q),1);
k=1:2*z;
poisson=zeros(length(k), length(q));
for i=1:length(k)
    for j=1:length(q)
        lambda(j)=z*q(j)/p(j);
        poisson(i,j)=exp(-lambda(j))*lambda(j)^(k(i))/factorial(k(i));
    end
end
figure(2);
clf;
mesh(lambda,k,poisson);
xlabel('lambda - Ocorrencias atacante');
xlim([0 10]);
ylabel('k - n. ocorrencias esperadas');
zlabel('Distribuição ocorrencias em tempo-bloco');
title('Progresso Blocos Ataque');    

figure(3)
clf;
%qn=0.1;
pn=1-qn;
zmax=20;
proba=zeros(zmax+1,1);
for qn=0:0.1:0.5
for z=0:zmax
    ln=z*qn/pn;
    proba(z+1)=0;
    for k=0:z
        proba(z+1)=proba(z+1)+((ln^k*exp(-ln))/factorial(k))*(1-(qn/pn)^(z-k));
    end
    proba(z+1)=1-proba(z+1);

 
end
plot(0:zmax,proba);
hold on;
%legend (sprintf('q=%f', qn));
end
hold off;
xlabel('z - tamanho da cadeia em blocos)');
ylabel('Probabilidade de Sucesso Atacante');
title(sprintf('Probabilidade Sucesso Atacante pelo Tamanho da Cadeia q=%f', qn));   
legend (sprintf('q=%f', 0),sprintf('q=%f', 0.1), sprintf('q=%f', 0.2), sprintf('q=%f', 0.3), sprintf('q=%f', 0.4), sprintf('q=%f', 0.5) );
