% shows evolution of the reconstruction using back-projection

addpath('../toolbox/');
rep = MkResRep();
mysaveas = @(name, it)saveas(gcf, [rep name '-' znum2str(it,3) '.png']);


n = 256*2;

f = phantom(n);

x = linspace(-.4,1.4,n);
sel = find(0<=x & x<=1);
[Y,X] = meshgrid(x,x);
disk = @(x,y,r)(X-x).^2+(Y-y).^2<=r^2;
f = -disk(.5,.5,.45) + disk(.67,.67,.14);

f = rescale(f, .1, .9);
vmin = .1; vmax = .9;
f = rescale(-f, vmin, vmax);

clf;
imagesc(1-f(sel,sel)); axis image; 
colormap gray(256);

imwrite(1-f(sel,sel), [rep 'original.png']);
p = 200;
u = linspace(0,180,p+1) + 20; u(end)=[];
R = radon(f-vmin,u);
sel1=200:530;
imwrite(rescale(-R(sel1,:)), [rep 'radon.png']);
I = 1+floor(0:10/p:10-10/p)*p/10;
Ri = R(:,I);
imwrite(rescale(-Ri(sel1,:)), [rep 'radon-sub.png']);


p = 300;

q = 70;
% plist = round(1+70*linspace(0,1,q).^3);
plist = 1:q;
plist = unique(plist);
q = length(plist);

for it=1:q
    p = plist(it);
    u = linspace(0,180,p+1) + 20; u(end)=[];
    if length(u)==1
        u = [u u];
    end
    R = radon(f-vmin,u);
    f1 = iradon(R, u, 'linear', 'Hamming')+vmin;
    clf; 
    imagesc(1-f1(sel,sel)); axis image; 
    colormap gray(256);
    caxis([0 1]);
    drawnow;    
    imwrite(clamp(1-f1(sel,sel)), [rep 'anim-' znum2str(it,3) '.png']);
end