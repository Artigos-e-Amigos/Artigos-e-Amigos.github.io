% Transform�e de Walsh rapide
function res = fwt(a)
% N doit �tre une puissance de 2
N = length(a);
res = zeros(N,1);
if N==1
    % fin de l'algorithme
    res = a;
    return;
end
% appels r�cursifs
P = N/2;
a(1:P) = fwt(a(1:P));
a((P+1):N) = fwt(a((P+1):N));
for i=1:P
    tmp = a(i);
    a(i) = tmp + a(i+P);
    a(i+P) = tmp - a(i+P);
end;
res = a;