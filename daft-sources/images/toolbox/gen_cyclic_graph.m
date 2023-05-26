function [A,xy] = gen_cyclic_graph( n, S )

% gen_cyclic_graph - g�n�re un graphe cyclique de Z/nZ
%   associ� � la partie g�n�ratrice S.
%
%   A : matrice d'adjacence de taille n x n
%   xy : matrice de position de taille n x 2.
%
%   Copyright (c) 2003 Gabriel Peyr�

A = zeros(n,n);
x = (0:(n-1))'*2*pi/n;
xy = [ cos(x) sin(x) ];

for i=0:n-1
    for s = S
        A( i+1, mod(i+s,n)+1 ) = 1;
    end
end