# Sistema de amortecimento do automóvel — simulação por PDS com MATLAB

Exemplo didático de um **sistema de segunda ordem** discretizado pelo método de **Backward Euler**. A dedução usa diretamente o deslocamento (x[n]) e suas amostras anteriores: **não utiliza variáveis de estado, Simulink nem toolboxes**. O script foi executado pelo professor no **MATLAB R2018b**.

> **Alcance do modelo:** trata-se de uma massa equivalente da carroceria apoiada por mola e amortecedor, submetida a uma *força vertical equivalente* (F(t)). O degrau de força é uma excitação didática. Não confundi-lo com um modelo completo de pneu, massa não suspensa ou perfil geométrico de uma lombada.

## Comece por aqui

1. Baixe esta pasta ou o repositório e abra-a como **Current Folder** no MATLAB.
2. Execute somente `suspensao_BE_R2018b_SCRIPT_UNICO.m` (o arquivo não depende de outras funções `.m`).
3. Confira no Command Window a mensagem `EXECUTANDO: suspensao_BE_R2018b_SCRIPT_UNICO.m`.
4. Observe as três janelas gráficas e os PNGs criados automaticamente em `figuras/`.

```matlab
which suspensao_BE_R2018b_SCRIPT_UNICO -all
suspensao_BE_R2018b_SCRIPT_UNICO
```

Se o MATLAB mostrar um erro em `tiledlayout`, ele está executando **outra cópia**, pois este script usa `subplot` e `saveas`, compatíveis com R2018b. Nesse caso, confira o caminho retornado por `which` e abra o arquivo deste diretório. Não execute arquivos antigos com sufixos `2` ou `3`.

## 1. Modelo físico contínuo

A equação da dinâmica vertical é

\[
m\,\frac{d^2x(t)}{dt^2}+c\,\frac{dx(t)}{dt}+k\,x(t)=F(t),
\]

em que (m) é a massa equivalente (kg), (c) o coeficiente do amortecedor (N·s/m), (k) a rigidez da mola (N/m), (x(t)) o deslocamento (m) e (F(t)) a força aplicada (N). Condições iniciais: (x(0)=0) e velocidade inicial igual a zero.

| Parâmetro | Valor | Papel |
| --- | ---: | --- |
| (m) | 250 kg | inércia da massa equivalente |
| (c) | 1.500 N·s/m | dissipação pelo amortecedor |
| (k) | 15.000 N/m | força restauradora da mola |
| (F_0) | 1.000 N | degrau de força a partir de 0,5 s |
| (T) | 0,01 s | intervalo entre amostras |

O valor final previsto é (x_{eq}=F_0/k=0{,}06667\,\mathrm{m}=66{,}67\,\mathrm{mm}). O sobressinal é esperado: a massa possui inércia, enquanto o amortecedor dissipa energia.

## 2. Primeira derivada por Backward Euler

Na amostra atual (n), usamos a amostra atual e a anterior:

\[
\dot x[n]\approx\frac{x[n]-x[n-1]}{T}.
\]

Uma amostra antes, a **mesma regra** fornece

\[
\dot x[n-1]\approx\frac{x[n-1]-x[n-2]}{T}.
\]

## 3. Segunda derivada: backward aplicado à primeira

Aplicando Backward Euler às duas amostras da **primeira derivada**:

\[
\ddot x[n]\approx\frac{\dot x[n]-\dot x[n-1]}{T}
=\frac{\frac{x[n]-x[n-1]}{T}-\frac{x[n-1]-x[n-2]}{T}}{T}
=\boxed{\frac{x[n]-2x[n-1]+x[n-2]}{T^2}}.
\]

Não foi necessário definir novas variáveis físicas para escrever a equação de diferenças: só o histórico de (x\) aparece na recorrência.

## 4. Substituição e isolamento da nova amostra

Substituímos as aproximações na equação contínua, no instante (n):

\[
\frac{m}{T^2}\bigl(x[n]-2x[n-1]+x[n-2]\bigr)
+\frac{c}{T}\bigl(x[n]-x[n-1]\bigr)
+kx[n]=F[n].
\]

Juntando os termos que multiplicam (x[n]):

\[
\left(\frac{m}{T^2}+\frac{c}{T}+k\right)x[n]
=F[n]+\left(\frac{2m}{T^2}+\frac{c}{T}\right)x[n-1]
-\frac{m}{T^2}x[n-2].
\]

Portanto, a amostra que o computador calcula em cada iteração é

\[
\boxed{x[n]=\frac{F[n]+\left(\frac{2m}{T^2}+\frac{c}{T}\right)x[n-1]
-\frac{m}{T^2}x[n-2]}{\frac{m}{T^2}+\frac{c}{T}+k}}.
\]

**Tradução para MATLAB:** o índice do vetor começa em 1. `x(1)` representa (x[0]), `x(2)` representa (x[1]), e `x(n)` usa as posições `x(n-1)` e `x(n-2)`. Para iniciar a recorrência, a condição de velocidade inicial dá (x[-1]=x[0]-T\dot x[0]=0).

A recorrência guarda duas amostras anteriores e, por isso, caracteriza uma equação de diferenças de segunda ordem. Sua resposta possui memória (não é um filtro FIR de dois termos).

## 5. Interprete as figuras

| Figura | O que observar |
| --- | --- |
| [Entrada e deslocamento](figuras/01_forca_e_deslocamento.png) | degrau em 0,5 s, sobressinal e convergência ao equilíbrio (F_0/k) |
| [Deslocamento e derivadas](figuras/02_derivadas.png) | velocidade como primeira diferença e aceleração como diferença da velocidade |
| [Períodos de amostragem](figuras/03_periodos.png) | para (T) maior, aparecem mais erros de discretização e amortecimento numérico; estabilidade não significa precisão |

Os PNGs nesta pasta são **pré-visualizações** calculadas pela mesma recorrência e pelos mesmos parâmetros; ao executar o script no MATLAB, ele os gera novamente no diretório `figuras/` de sua pasta atual. O professor confirmou a execução do script no R2018b.

## 6. Atividades

As questões graduais estão em [EXERCICIOS.md](EXERCICIOS.md). Comece reproduzindo a dedução sem olhar a linha da recorrência no script; depois execute e confronte sua previsão com os três gráficos. Em cada modificação, registre **parâmetro, hipótese antes da execução, resultado observado e explicação física/numérica**.

## Arquivos da pasta

```text
sistema-amortecimento-automovel-pds-matlab/
├── README.md
├── EXERCICIOS.md
├── suspensao_BE_R2018b_SCRIPT_UNICO.m
└── figuras/
    ├── 01_forca_e_deslocamento.png
    ├── 02_derivadas.png
    └── 03_periodos.png
```

