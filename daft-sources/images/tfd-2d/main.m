clear;
clf;

N = 128;
colormap(gray);

% image � analyser
f = [ones(N/2,N/2); zeros(N/2,N/2)];
g = [zeros(N/2,N/2); ones(N/2,N/2)];
f = 255*[f,g];
subplot(1,2,1);
image(f);
title('Image � analyser');
axis image;
% axis off;

% transform�e de Fourier :
ff = abs(fft2(f));
m = max(max(ff));
ff = ff*20000/m;
gg = zeros(N,N);
gg(1:N/2,:) = ff((N/2+1):N,:);
gg((N/2+1):N,:) = ff(1:N/2,:);
ff = gg;
gg(:,1:N/2) = ff(:,(N/2+1):N);
gg(:,(N/2+1):N) = ff(:,1:N/2);
ff = gg;
subplot(1,2,2);
image(-(N/2+1):N/2, -(N/2+1):N/2, 255-ff);
title('Spectre');
axis image;
% axis off;


saveas(gcf, '../tfd-2d', 'eps');
saveas(gcf, '../tfd-2d', 'png');