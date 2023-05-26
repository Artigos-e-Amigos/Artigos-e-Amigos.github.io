%%
% Display the evolution of the 2D median

addpath('../toolbox/');
rep = MkResRep();
mysaveas = @(it)saveas(gcf, [rep 'anim-' znum2str(it,3) '.png']);


k = 50; % #point
k1 = 24; % #outliers

randn('state', 123); rand('state', 123);
x0 = .1*(1+1i) + .05*( randn(k,1) + 1i * randn(k,1) );
x1 = .1*(1+1i) + .05*( randn(k,1) + 1i * randn(k,1) );


niter = 500;  % algo
epsilon = 1e-9; tau = 1;
p = 1;
q = 150;
eta = .02; 
v = randn(k,1) + 1i*randn(k,1); 
v = rand(k,1) + 1i*rand(k,1); 
v = eta*v./abs(v);
x = x0;
for it=1:q    
    s = (it-1)/(q-1);
    plist = 1:.1:3;
    clf; hold on;
    plot(x, 'k.', 'MarkerSize', 15);
    for j=1:length(plist)
        c = (j-1)/(length(plist)-1);
        p = plist(j);
        y = mean(x); % init
        for italgo=1:niter
            w = 1./(epsilon + abs(x-y).^(2-p));
            y1 = sum( w .* x) ./ sum(w);
            y = (1-tau)*y + tau*y1;
        end
        plot(y, '.', 'color',[1-c 0 c], 'MarkerSize', 30);
    end
%    plot(mean(x), '.', 'color', [1/2 0 1/2], 'MarkerSize', 25);
    axis equal; box on; set(gca, 'XTick', [], 'YTick', []);
    axis([0 1 0 1]);
    drawnow;
    % animate outliers
    x(1:k1) = x(1:k1) + v(1:k1);
    I = find( real(x)<0 | real(x)>1 );
    v(I) = -real(v(I)) + 1i*imag(v(I));
    I = find(  imag(x)<0 | imag(x)>1 );
    v(I) = real(v(I)) - 1i*imag(v(I));
    % animate inliers
    x(k1+1:end) = x0(k1+1:end) * (1-s) + x1(k1+1:end) * s;
    mysaveas(it);
end