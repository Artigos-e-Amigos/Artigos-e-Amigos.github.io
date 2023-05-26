clear;

N	= 256;

% pr�-calcule de la Gaussienne et de sa transform�e
ramp	= [-N:N-1];
ramp	= pi * ramp/N;
f	= exp( -(ramp.^2)/(0.5) );
f	= f - mean(f);	% recentrage de la gaussienne pour assurer continuit�
% transform�e de Fourier recentr�e sur la moyenne
F	= fftshift( fft( f ) );


% calcule les diff�rentes d�riv�es fractionaires
i = 1;
for n = 0 : 2/15 :2
	Fn	= (j * ramp).^n .* F;
	fn	= ifft( fftshift(Fn) );
	if( mean( imag(fn) ) > eps )
		% normalement, le signal devrait �tre r�el.
	   return;
	end
	fn 	= fn / max(abs(fn));		% renormalise
	% dessine dans une boite diff�rente 
	subplot(4,4,i);
	t = sprintf( '%0.2f', n );	
	plot( real(fn) ); 
	text( 20,1.0, sprintf( '%0.2f', n ) );
	set( gca, 'Xtick', [], 'Ytick', [] );	
	axis( [0 2*N -1.2 1.2] ); axis square;
	h = line( [N N], [-1.2 1.2] );
	set( h, 'LineStyle', ':' );
	i = i + 1;
end
