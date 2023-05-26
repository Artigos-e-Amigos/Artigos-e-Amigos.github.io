clear;
clf;

N = 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calcule de la transform�e de fourier d'un signal 
% qui n'est pas p�riodique
beta = N*0.23;
f = exp(2i*pi*(0:N-1)*beta/N);
f_prec = f;
f_prec(10*N) = 0;
ff = fft(f);
ff_prec = fft(f_prec);
xx_prec = 0:N/(10*N-1):N;
xx = 0:N-1;
plot( xx, abs(ff), 'k*', xx_prec, abs(ff_prec), 'k' );
legend('Spectre �chantillon�', 'Spectre continu')
xlabel('Fr�quence');
ylabel('Amplitude');
h = line( [beta beta], [0 20] );	% un trait au niveau du pic
set( h, 'LineStyle', ':' );
set(h,'Color',[0,0,0]);

saveas(gcf, '../spectre-signal-non-periodique', 'eps')
saveas(gcf, '../spectre-signal-non-periodique', 'png')

pause;
clf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% une fonction non p�riodique :
N = 128;
bruit = 0.2;
beta = 2.23;
f = cos(2*pi*(0:N-1)*beta/N) + bruit*(rand(1,N)-0.5);

% la fonction
subplot(2,2,1);
plot(0:N-1, f, 'k');
title('(a) Fonction analys�e');
axis([0,N-1,-1.05,1.05]);
xlabel('Temps');
ylabel('Amplitude');

% sa transform�e
ff = fft(f);
subplot(2,2,2);
plot(0:N/4-1, abs(ff(1:N/4)), 'k');	% le d�but du spectre
axis([0,N/4-1,0,60]);
title('(b) Transform�e de Fourier');
xlabel('Fr�quence');
ylabel('Amplitude');
h = line( [2 2], [0 100] );	% un trait au niveau du pic
set( h, 'LineStyle', ':' );
set(h,'Color',[0,0,0]);	

% zoom pr�s du pic
delta = 1/N;
b = 2;
y = f .* exp( -2i*pi*b*(0:N-1)/N );
x = b:delta:(b+1-delta);
f_zoom = frft(y, delta);
subplot(2,2,3);
plot(x, abs(f_zoom), 'k');
axis([2,3,0,70]);
xlabel('Fr�quence');
ylabel('Amplitude');
title('(c) Zoom sur le spectre');
h = line( [2.23 2.23], [0 100] );	% un trait au niveau du pic
set( h, 'LineStyle', ':' );
set(h,'Color',[0,0,0]);

% transform�e r�ajust�e
alpha = b/beta;
r = round(N*alpha);
ff_ajust = frft( f(1:r), r/(N*alpha) );
subplot(2,2,4);
plot(0:N/4-1, abs(ff_ajust(1:N/4)), 'k');	% le d�but du spectre
axis([0,N/4-1,0,60]);
title('(d) Transform�e de Fourier ajust�e');
xlabel('Fr�quence');
ylabel('Amplitude');

saveas(gcf, '../transformee-fourier-fractionnaire', 'eps')
saveas(gcf, '../transformee-fourier-fractionnaire', 'png')