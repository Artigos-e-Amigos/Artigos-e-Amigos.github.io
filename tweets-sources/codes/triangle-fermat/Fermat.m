%%
% Plot construction of Fermat point in the triangle.

addpath('../toolbox/');
rep = MkResRep();
mysaveas = @(it)saveas(gcf, [rep 'anim-' znum2str(it,3) '.png']);
dotp = @(x,y)real(x.*conj(y));



% animate points in a square with bouncing
rand('state', 123); randn('state', 123);
k = 3; x = rand(k,1)+1i*rand(k,1);
eta = .02; v = randn(k,1) + 1i*randn(k,1); v = eta*v./abs(v);
q = 120;
for it=1:q
    %
    clf; hold on;
    plot(x([1:end 1]), 'k.-', 'LineWidth', 3, 'MarkerSize', 30);
    for i=1:3
        j = mod(i,3)+1;
        k = mod(j,3)+1;
        z = x(i) + exp(1i*pi/3)*(x(j)-x(i));
        n = 1i*(x(j)-x(i));
        if dotp(n,x(k)-x(i)) * dotp(n,z-x(i))>0
            z = x(i) + exp(-1i*pi/3)*(x(j)-x(i));
        end
        plot([x(i) x(j) z x(i)], 'k.-', 'LineWidth', 1, 'MarkerSize', 10);
        plot([x(k) z], 'b-', 'LineWidth', 2);
    end
    t = linspace(0,1,1000);
    xt = [(1-t)*x(k)+t*z, transpose(x)];
    [~,i] = min( sum(abs(xt-x),1) );
    % clf; 
    plot(xt(i), 'b.', 'MarkerSize', 30);
    axis equal; box on; set(gca, 'XTick', [], 'YTick', []);
    axis([-.3 1.3 -.3 1.3]);
    drawnow;
    % mysaveas(it);
    % animate
    x = x + v;
    I = find( real(x)<0 | real(x)>1 );
    v(I) = -real(v(I)) + 1i*imag(v(I));
    I = find(  imag(x)<0 | imag(x)>1 );
    v(I) = real(v(I)) - 1i*imag(v(I));
end

