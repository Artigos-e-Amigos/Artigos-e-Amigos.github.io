%%
% Test for mirror-descent deconvolution under positivity constraints.

addpath('../toolbox/');
rep = MkResRep();

n = 256*2; 

% load filter
t = [0:n/2,-n/2+1:-1]'/n;



% ED kernel
s = .05; 
k = -abs(t); 
tau = 5; %% NEEDS TO BE TUNED

% Gaussian kernel
s = .015; 
k = exp(-t.^2/(2*s^2));

% Block kernel
s = .08;
k = abs(t)<s;


% Gaussian kernel
s = .018; 
k = exp(-abs(t)/s);

k = k/sum(k);

tau = 50; %% NEEDS TO BE TUNED

% be sure it is positive
kf = max(fft(k),0);
% convolution operator
K = @(x)real(ifft(kf.*fft(x)));


% data
B = @(m,s)double(abs(t-m)<s);
x0 = double(abs(t-1/2)<.08);
x0 = B(0,.2) +.0001;
x0 = B(0,.2) + .5*B(.1,.35) +.0001;


x0 = zeros(n,1);
x0( round([.2 .3 .6 .8]*n) ) = [.3 .7 -.5 -.5];
x0 = cumsum(x0) +.0001;
x0 = fftshift(x0);

% laplacian for regularization
Delta = @(x)-n^2*( 2*x - circshift(x,1) - circshift(x,-1) );
rho = 3*1e-3/100;
tau = 10;

x0 = x0/sum(x0);

% energy <h*(x-x0),x-x0>
dotp = @(x,y)sum(x(:).*y(:));
E = @(x)dotp(K(x-x0),x-x0)/2;

loss = 'l2';
loss = 'kl';

niter = 500;
q = 60; % #display
ndisp = round( 1+(niter-1)*linspace(0,1,q).^3 );
ndisp = unique(ndisp);

kdisp = 1;

y = K(x0); % observations

clf;
plot(fftshift(x0), 'b-', 'LineWidth', 2);
axis([1 n 0 max(x0)*1.08]); box on;
set(gca, 'PlotBoxAspectRatio', [1 1/2 1], 'FontSize', 20, 'XTick', [], 'YTick', []);
saveas(gcf, [rep 'fig-x0.eps'], 'epsc');

clf;
plot(fftshift(k), 'k-', 'LineWidth', 2);
axis([1 n 0 max(k)*1.08]); box on;
set(gca, 'PlotBoxAspectRatio', [1 1/2 1], 'FontSize', 20, 'XTick', [], 'YTick', []);
saveas(gcf, [rep 'fig-k.eps'], 'epsc');

clf;
plot(fftshift(y), 'r-', 'LineWidth', 2);
axis([1 n 0 max(x0)*1.08]); box on;
set(gca, 'PlotBoxAspectRatio', [1 1/2 1], 'FontSize', 20, 'XTick', [], 'YTick', []);
saveas(gcf, [rep 'fig-y.eps'], 'epsc');

   
x = ones(n,1)/n; 
for it=1:niter
    switch loss
        case 'l2'
            G = K(K(x)-y) - rho*Delta(x);
            x = x .* exp( -tau*G );
        case 'kl'
            % min KL(K*x|K*x0)
            % G = K( log( K(x) ./ K(x0)  ) );
            x = x .* K( y ./ K(x)  );
            % vs
            %  x = x .* exp( tau * K( log(K(x0) ./ K(x))  ) );
    end
    x = x/sum(x);
    clf; plot(x);
    Elist(it)=E(x);
    if it==ndisp(kdisp)
        s = (kdisp-1)/(length(ndisp)-1);
        clf; hold on;
        area(fftshift(x), 'FaceColor', .5+.5*[s 0 1-s], 'EdgeColor', [s 0 1-s], 'LineWidth', 2); 
%        plot(fftshift(x), 'k', 'LineWidth', 2); 
%        plot(fftshift(y), 'k-', 'LineWidth', 2);
        % plot(fftshift(x0), 'r', 'LineWidth', 2);
        axis([1 n 0 max(x0)*1.08]); box on;
        set(gca, 'PlotBoxAspectRatio', [1 1/2 1], 'FontSize', 20, 'XTick', [], 'YTick', []);
        drawnow;
        saveas(gcf, [rep 'anim-' znum2str(kdisp,2) '.png'], 'png');
        kdisp = kdisp+1;        
    end
end
return;
clf;
plot(log(Elist), 'LineWidth', 2); 
axis tight;

% AutoCrop(rep, 'anim');