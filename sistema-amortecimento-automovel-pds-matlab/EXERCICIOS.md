# Exercícios — sistema de amortecimento do automóvel

Abra o [script MATLAB](suspensao_BE_R2018b_SCRIPT_UNICO.m), execute-o sem modificações e salve cópias para suas experiências. Entregue a dedução, os valores calculados e gráficos pertinentes; justifique as conclusões com base no modelo físico e na equação de diferenças. Não utilize variáveis de estado para os exercícios 1 a 8.

## Bloco A — compreender o sistema e a discretização

1. **Identificar as parcelas físicas.** Na equação $m\ddot x+c\dot x+kx=F$, indique a unidade e o papel dos quatro termos. Por que não se pode somar $x$, $\dot x$ e $\ddot x$ sem os respectivos coeficientes?

2. **Fazer a derivada segunda a partir da primeira.** Escreva $\dot x[n]$ e $\dot x[n-1]$ por Backward Euler; subtraia ambas e divida por $T$. Mostre cada etapa até obter $\bigl(x[n]-2x[n-1]+x[n-2]\bigr)/T^2$. Explique por que aparecem **duas** amostras passadas.

3. **Isolar a recorrência.** Substitua as duas derivadas discretas no modelo físico, agrupe os coeficientes de $x[n]$, $x[n-1]$ e $x[n-2]$, e isole $x[n]$. Localize no script as linhas correspondentes a `A`, `B`, `D` e ao laço que calcula `x(n)`.

4. **Indexação e condição inicial.** Explique por que `x(1)` no MATLAB corresponde a $x[0]$. A partir de $x[0]=0$, $\dot x[0]=0$ e $T=0{,}01$ s, calcule $x[-1]$. Qual é a primeira posição do vetor `x` calculada pela recorrência? Qual será a primeira amostra **não nula** quando o degrau começar em 0,5 s? Faça uma previsão em milímetros antes de executar.

5. **Equilíbrio e resposta transitória.** Calcule $x_{eq}$ usando a equação contínua em regime permanente. Compare-o com o deslocamento final e o pico exibidos no Command Window. Explique por que o pico pode ultrapassar o equilíbrio sem que o sistema seja instável.

## Bloco B — experiências com o código

6. **Papel do amortecedor.** Teste `c = 0`, `c = 1500` e `c = 4000` N·s/m, mantendo os demais parâmetros. Compare o pico e o tempo de acomodação. Ao usar `c = 0`, a resposta discreta ainda parece perder amplitude? Separe a dissipação *física* do amortecimento *numérico* introduzido pelo método.

7. **Mola mais rígida ou mais macia.** Teste `k = 7500` e `k = 30000` N/m. Antes de executar, calcule o equilíbrio para ambos. Verifique se o resultado final segue $F_0/k$ e discuta o que aconteceu com as oscilações.

8. **Amostragem não é apenas estabilidade.** Rode com `T = 0.01`, `T = 0.05` e `T = 0.10` s; examine a terceira figura. Compare amplitude do primeiro pico, instante aproximado do pico e deslocamento final. Se os três resultados convergem ao mesmo equilíbrio, isso basta para afirmar que os transitórios são igualmente precisos? Justifique.

9. **Massa e inércia.** Teste `m = 125` e `m = 500` kg. Preveja o que deve acontecer com o valor final e com a rapidez das oscilações. Confira no gráfico e explique fisicamente.

10. **Conferência da equação discreta.** Após executar o script, calcule no Command Window:

    ```matlab
    residuo = m*aceleracao(2:end) + c*velocidade(2:end) + k*x(2:end) - F(2:end);
    max(abs(residuo))
    ```

    Por que esse valor deve ficar muito próximo de zero, apesar de não ser exatamente zero em aritmética de ponto flutuante? Por que começamos na segunda posição?

## Desafio opcional

11. **Excitação temporária.** Troque o degrau por um pulso de força entre 0,5 s e 1,0 s:

    ```matlab
    F = F0 * double(t >= 0.5 & t < 1.0);
    ```

    Compare as respostas. Para que a terceira figura compare o **mesmo** pulso, substitua também a expressão de `Fj` pela condição análoga em `tj`. Nesse caso, a linha horizontal `F0/k` na primeira figura não representa o equilíbrio final: remova-a ou explique por quê. Que deslocamento final você prevê para o pulso?

## Pontos de autocorreção

- Com os parâmetros originais e degrau permanente, $F_0/k = 66{,}67$ mm; o pico fica próximo de 82,31 mm.
- Com $T=0{,}01$ s, $m/T^2+c/T+k=2.665.000$; na primeira amostra excitada, se as anteriores ainda são nulas, $x\approx F_0/2.665.000=0{,}375$ mm.
- Reduzir $k$ à metade duplica o deslocamento final. Mudar apenas $m$ não altera $F_0/k$, mas altera o transitório.
- O resultado não descreve a transposição geométrica de uma lombada: a entrada deste programa é uma força equivalente.
