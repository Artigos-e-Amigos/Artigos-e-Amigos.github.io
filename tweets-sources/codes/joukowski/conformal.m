%%
% Compute conformal maps, in particular Joukowski Conformal Mapping

% https://en.wikipedia.org/wiki/Joukowsky_transform

rep = 'results/';
[~,~] = mkdir(rep);

% # grids
n = 20;
% sampling on grid
p = 600;

a = 1.5; b = 1.5;

% pas ok
x = [linspace(1e-4,a,n/2)];
y = linspace(1e-4,b,p);
[Y,X] = meshgrid(y,x); X = X'; Y = Y';
G = X+1i*Y;
x = [linspace(1e-4,a,n/2)];
y = linspace(-b,-1e-4,p);
[Y,X] = meshgrid(y,x); X = X'; Y = Y';
G = [G X+1i*Y];

% ok
x = [linspace(-b,-1e-4,n/2) linspace(1e-4,b,n/2)];
y = linspace(1e-4,a,p);
[Y,X] = meshgrid(y,x); X = X'; Y = Y';
H = Y+1i*X;

lw=2; fs = 20;

clf; hold on;
plot(G, 'r', 'LineWidth', lw);
plot(H, 'b', 'LineWidth', lw);
axis tight; axis equal; box on;
set(gca, 'FontSize', fs);
saveas(gcf, [rep 'grid.eps'], 'epsc');

%%
% Past a disk

mc = @(z)-real(z)+1i*imag(z)
mapc = @(H)deal(H+sqrt(H.^2-1),mc(H)-sqrt(mc(H).^2-1));
[H1,H2] = mapc(H);
[G1,G2] = mapc(G);

% boundary of a disk
U = 2*pi*(0:256)/256; U = cos(U) + 1i*sin(U);

plotflow(H1,H2,G1,G2,U);
saveas(gcf, [rep 'disk.eps'], 'epsc');


%%
% Past an airfoil


% scaling
alpha = @(beta,theta)abs(1-beta)*exp(1i*theta);
phi = @(x,beta,theta)alpha(beta,theta)*x+beta;
remap = @(x,beta,theta)exp(-1i*theta)*( 1/2*(1./phi(x,beta,theta)+phi(x,beta,theta)) );


% new center
beta = -.1+.2i; % .2+.1i; % .1+.1i;
% rotation
theta = .3;

g1 = phi(G1,beta,theta);
g2 = phi(G2,beta,theta);
h1 = phi(H1,beta,theta);
h2 = phi(H2,beta,theta);
u = phi(U,beta,theta);
%
plotflow(h1,h2,g1,g2,u);


K = 36;
theta_list = (0:K-1)/K*2*pi;

F = [];
for k=1:K
    
    theta = theta_list(k);
    
    g1 = remap(G1,beta,theta);
    g2 = remap(G2,beta,theta);
    h1 = remap(H1,beta,theta);
    h2 = remap(H2,beta,theta);
    u = remap(U,beta,theta);
    %
    plotflow(h1,h2,g1,g2,u);    
    saveas(gcf, [rep 'airfoil-' num2str(k) '.eps'], 'epsc');
    
    % save as animated gif
    f = getframe(gcf);
    F(:,:,:,k) = f.cdata;
end


% find colormap
A = permute(F, [1 2 4 3]);
A = reshape(A, [size(A,1) size(A,2)*size(A,3) 3]);
[~,map] = rgb2ind(uint8(A),254,'nodither');
map(end+1,:) = 0; map(end+1,:) = 1;
% convert
im = [];
for s=1:size(F,4);
    im(:,:,1,s) = rgb2ind(uint8(F(:,:,:,s)),map,'nodither');
end
% save
imwrite(im+1,map,[rep 'airfoil.gif'], ...
    'DelayTime',0,'LoopCount',inf);



%%
% stretch

% new center
beta0 = -1 + 3*i; % .2+.1i; % .1+.1i;
% rotation
theta = .3;

F = [];
for k=1:K    
    beta = (k-1)/(K-1)*beta0;
    %
    g1 = remap(G1,beta,theta);
    g2 = remap(G2,beta,theta);
    h1 = remap(H1,beta,theta);
    h2 = remap(H2,beta,theta);
    u = remap(U,beta,theta);
    %
    plotflow(h1,h2,g1,g2,u);    
    saveas(gcf, [rep 'airfoil-' num2str(k) '.eps'], 'epsc');    
    % save as animated gif
    f = getframe(gcf);
    F(:,:,:,k) = f.cdata;
end

% find colormap
A = permute(F, [1 2 4 3]);
A = reshape(A, [size(A,1) size(A,2)*size(A,3) 3]);
[~,map] = rgb2ind(uint8(A),254,'nodither');
map(end+1,:) = 0; map(end+1,:) = 1;
% convert
im = [];
for s=1:size(F,4);
    im(:,:,1,s) = rgb2ind(uint8(F(:,:,:,s)),map,'nodither');
end
% save
imwrite(im+1,map,[rep 'airfoil-stretch.gif'], ...
    'DelayTime',0,'LoopCount',inf);