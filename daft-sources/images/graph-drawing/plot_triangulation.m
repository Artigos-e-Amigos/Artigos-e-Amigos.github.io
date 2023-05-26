function plot_triangulation(A,xy,vertex,face)

% Dessine une triangulation en l'applattissant avec diverses
%   m�thodes.
%
%   Copyright (c) 2003 Gabriel Peyr�

global lang;
if ~strcmp(lang,'eng') % default is french
    lang = 'fr';
end

n = length(A);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mod�le d'origine
clf;
subplot(2,2,1);
plot_mesh(vertex,face);

if strcmp(lang,'eng')==1
    title('Original model');
else
    title('Mod�le original');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% orthogonal projection
if 0
subplot(2,2,1);
gplot(A,xy,'k.-');
axis tight;
axis square;
axis off;
if strcmp(lang,'eng')==1
    title('Orthogonal projection');
else
    title('Projection orthogonale');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spectral graph drawing : utilise les vecteurs propres
%   du laplacien.
lap = compute_laplacian(A);

disp('Performing SVD.');
tic;
[U,S,V] = svd(lap);
disp( sprintf('CPU time : %.2f.', toc) );
xy_spec = U(:,(n-2):(n-1));

% essaie de redresse le graphe
I = find( xy(:,2)==max(xy(:,2)) );
n1 = I(1); 
I = find( xy(:,2)==min(xy(:,2)) );
n2 = I(1);
v1 = xy(n1,:)-xy(n2,:);
v2 = xy_spec(n1,:)-xy_spec(n2,:);
theta = acos( dot(v1,v2)/sqrt(dot(v1,v1)*dot(v2,v2)) );
theta = theta * sign( det([v1;v2]) );
M = [cos(theta) sin(theta); -sin(theta) cos(theta)];
xy_spec = (M*xy_spec')';

subplot(2,2,2);
gplot(A,xy_spec,'k.-');
axis tight;
axis square;
axis off;

if strcmp(lang,'eng')==1
    title('Combinatorial laplacian');
else
    title('Laplacien combinatoire');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% conformal
lap = compute_geometric_laplacian(vertex,face,'conformal');

disp('Performing SVD.');
tic;
[U,S,V] = svd(lap);
disp( sprintf('CPU time : %.2f.', toc) );
xy_spec = U(:,(n-2):(n-1));
    
% redresse le graphe
I = find( xy(:,2)==max(xy(:,2)) );
n1 = I(1); 
I = find( xy(:,2)==min(xy(:,2)) );
n2 = I(1);
v1 = xy(n1,:)-xy(n2,:);
v2 = xy_spec(n1,:)-xy_spec(n2,:);
theta = acos( dot(v1,v2)/sqrt(dot(v1,v1)*dot(v2,v2)) );
theta = theta * sign( det([v1;v2]) );
M = [cos(theta) sin(theta); -sin(theta) cos(theta)];
xy_spec = (M*xy_spec')';

subplot(2,2,3);
gplot(A,xy_spec,'k.-');
axis tight;
axis square;
axis off;

if strcmp(lang,'eng')==1
    title('Conformal laplacian');
else
    title('Laplacien conforme');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IsoMap
% build distance graph

D = build_euclidean_weight_matrix(A,vertex,Inf);
xy_spec = isomap(D); 

% redresse le graphe
I = find( xy(:,2)==max(xy(:,2)) );
n1 = I(1); 
I = find( xy(:,2)==min(xy(:,2)) );
n2 = I(1);
v1 = xy(n1,:)-xy(n2,:);
v2 = xy_spec(n1,:)-xy_spec(n2,:);
theta = acos( dot(v1,v2)/sqrt(dot(v1,v1)*dot(v2,v2)) );
theta = theta * sign( det([v1;v2]) );
M = [cos(theta) sin(theta); -sin(theta) cos(theta)];
xy_spec = (M*xy_spec')';

subplot(2,2,4);
gplot(A,xy_spec,'k.-');
axis tight;
axis square;
axis off;
title('Isomap');


return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% authalic
lap = compute_geometric_laplacian(vertex,face,'authalic');

disp('Performing SVD.');
tic;
[U,S,V] = svd(lap);
disp( sprintf('CPU time : %.2f.', toc) );
xy_spec = U(:,(n-2):(n-1));
    
% redresse le graphe
I = find( xy(:,2)==max(xy(:,2)) );
n1 = I(1); 
I = find( xy(:,2)==min(xy(:,2)) );
n2 = I(1);
v1 = xy(n1,:)-xy(n2,:);
v2 = xy_spec(n1,:)-xy_spec(n2,:);
theta = acos( dot(v1,v2)/sqrt(dot(v1,v1)*dot(v2,v2)) );
theta = theta * sign( det([v1;v2]) );
M = [cos(theta) sin(theta); -sin(theta) cos(theta)];
xy_spec = (M*xy_spec')';

subplot(2,2,4);
gplot(A,xy_spec,'k.-');
axis tight;
axis square;
axis off;
title('Authalic Laplacian');