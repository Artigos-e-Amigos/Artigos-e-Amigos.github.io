%%
% Draw levelsets for n-ellipses.


rep = 'results/';
[~,~] = mkdir(rep);
if not(exist('test'))
    test=1;
end


% click and play
clf; hold on;
Q = [];
while true
    axis([-1 1 -1 1]);
    [a,b,button] = ginput(1);
    plot(a,b, '.', 'MarkerSize', 15);   
    if button==3
        break;
    end
    Q(:,end+1) = [a;b];
end

N = 256;
x = linspace(-1,1,N);
[Y,X] = meshgrid(x,x);

D = zeros(N);
for i=1:size(Q,2)
    D = D + sqrt( (X-Q(1,i)).^2 + (Y-Q(2,i)).^2 );
end

D1 = rescale(D);
r = 12;
clf; hold on;
imagesc(x,x,D1);
contour(x,x,D1, linspace(0,1,r), 'k', 'LineWidth', 2);
plot(Q(2,:), Q(1,:), 'r.', 'MarkerSize', 30);
axis image; axis off;
colormap( parula(r-1) );
caxis([0 1]);
saveas(gcf, [rep 'nellipse-' num2str(test) '.png']);
test = test+1;