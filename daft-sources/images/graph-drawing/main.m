% test les diff�rentes fa�on de dessiner un graphe
%
%   Copyright (c) 2003 Gabriel Peyr�

global lang;
if ~strcmp(lang,'eng') % default is french
    lang = 'fr';
end

n = 31;
S = [-1,1];

% [A,xy] = gen_cyclic_graph(n,S); % aucun int�ret : l'embeding est celui de
% fourier
[A,xy] = gen_square_graph(11,8);
plot_graph(A,xy);
if exist('save_image')
    save_image('graph-drawing-square');
end
disp('Press a key to continue.');
pause;

filename = '../mesh/mannequin.off';
filename = '../mesh/nefertiti.off';
filename = '../mesh/hole_sphere5.off';
[vertex,face] = read_off(filename);
A = triangulation2adjacency(face);
xy = vertex(:,1:2);
plot_triangulation(A,xy,vertex,face);

if exist('save_image')
%    save_image('graph-drawing-triangulation');
end