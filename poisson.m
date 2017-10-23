lambda=10;
n=20;
f=(zeros(n,1)); 
for k=1:20
f(k)=exp(-lambda)*lambda^(k)/factorial(k);
end;
stem(1:n, f);