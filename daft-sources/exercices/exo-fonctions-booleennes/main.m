% test du d�codage de R(1,n)
n = 6;
d = 2^n;                        % taille
e = 2^(n-2);                    % nbr d'erreurs max
a = floor( rand*d );            % num�ro � encoder
b = rand>0.5;                   % signe

f = encode_rm(a,b,n);
err = floor( 1+rand(e,1)*d );   % e positions tir�es au hasard
g = f; g(err) = 1-g(err);       % vecteur perturb�
gg = decode_rm(g);
norm( f-gg )                    % doit valoir z�ro