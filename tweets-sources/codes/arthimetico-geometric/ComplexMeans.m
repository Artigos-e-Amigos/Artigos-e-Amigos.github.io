
% create save repertory
addpath('../toolbox/');
rep = MkResRep();
mysaveas = @(it)saveas(gcf, [rep 'anim-' znum2str(it,3) '.png']);



% animate points in a square with bouncing
rand('state', 123); randn('state', 123);
k = 2; x = 2*( rand(k,1)+1i*rand(k,1) ) - 1 - 1i;
eta = .05; v = randn(k,1) + 1i*randn(k,1); v = eta*v./abs(v);
q = 200;
for it=1:q
    % compute arith-geom
    z = x;
    for j=1:50
        z = [ mean(z) GeomMean(z(1),z(2))];
    end
    % display
    clf; hold on;
    plot(x, 'k.', 'MarkerSize', 30);
    plot(mean(x), 'r.', 'MarkerSize', 30);
    plot(GeomMean(x(1),x(2)), 'b.', 'MarkerSize', 30);
    plot(z(1), 'g.', 'MarkerSize', 30);
    plot([-1 -1 1 1 -1], [-1 1 1 -1 -1], 'k');
    plot([-1 +1], [0 0], 'k:');
    plot([0 0], [-1 +1], 'k:');
    axis equal; axis off; axis([-1.05 1.05 -1.05 1.05]); 
    set(gca, 'XTick', [], 'YTick', []);
    drawnow;
    % update
    x = x + v;
    I = find( real(x)<-1 | real(x)>1 );
    v(I) = -real(v(I)) + 1i*imag(v(I));
    I = find(  imag(x)<-1 | imag(x)>1 );
    v(I) = real(v(I)) - 1i*imag(v(I));
    mysaveas(it);
end
