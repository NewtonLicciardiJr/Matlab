%de acordo com RNP
% funcionamento de controle de congestioamento
%newton
% congestion avoidance
n=10 % numero de repeticoes

segsize=1000;
cwnd=zeros(1,n);
cwnd(1)=1;
for i=1:n
    cwnd(i+1)=segsize^2/cwnd(i);
end
plot(1:n+1,cwnd);

    