function h=plotQuiver(mesh,uv,scale_factor)
X=mesh.coor(1,[1 end]);
Y=mesh.coor(2,[1 end]);
NN=[mesh.Nx mesh.Ny];

% Horizontal staggered

xh = mean([mesh.coor(1, mesh.cn(2, :)); mesh.coor(1, mesh.cn(4, :))]);
yh = mean([mesh.coor(2, mesh.cn(2, :)); mesh.coor(2, mesh.cn(4, :))]);

% Vertical staggered
xv = mean([mesh.coor(1, mesh.cn(3, :)); mesh.coor(1, mesh.cn(4, :))]);
yv = mean([mesh.coor(2, mesh.cn(3, :)); mesh.coor(2, mesh.cn(4, :))]);

% Volume divisions
xtck = linspace(X(1) - (X(2)-X(1)), X(2) + (X(2)-X(1)), 3*NN(1)+1);
ytck = linspace(Y(1) - (Y(2)-Y(1)), Y(2) + (Y(2)-Y(1)), 3*NN(2)+1);

% Combine hor and vert into the same quiver plot
xcom = [ reshape(xh, NN) , reshape(xv, NN) ];
ycom = [ reshape(yh, NN) , reshape(yv, NN) ];

xrep = [repmat(xcom - ( X(2) - X(1) ), [3 1]) , ...
        repmat(xcom, [3 1])                   , ...
        repmat(xcom + ( X(2) - X(1) ), [3 1])];

yrep = [repmat(ycom - ( Y(2) - Y(1) ), [1 3]) ;
        repmat(ycom, [1 3])                   ;
        repmat(ycom + ( Y(2) - Y(1) ), [1 3])];

ucom = [ reshape(uv(1, :), NN) , zeros(NN) ];
vcom = [ zeros(NN) , reshape(uv(2, :), NN) ];

h=figure;
if(~exist('scale_factor') || scale_factor==0)
	quiver(xrep, yrep, repmat(ucom, [3 3]), repmat(vcom, [3 3]));
else
	quiver(xrep, yrep, scale_factor*repmat(ucom, [3 3]), scale_factor*repmat(vcom, [3 3]),'AutoScale','off');
end
xlim(X); ylim(Y); grid('on'); xticks(xtck); yticks(ytck);
end

