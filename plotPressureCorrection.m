% Init
L = 1;
X = [0 L];
Y = [0 L];
Nx = 10;
Ny = 10;
NN = [Nx Ny];
mesh = StructuredMesh(X, Y, Nx, Ny);

% Arbitrary velocity field
v = zeros(2,Nx*Ny);
v(2,round(0.5*Nx*Ny-0.5*Nx+1)) = 1;
v(2,round(0.5*Nx*Ny-0.5*Nx-1)) = -1;

% Corrected velocity field
vcorr = v - mesh.cv.uvCorrection(mesh,v);

%% Plot quivers
% Horizontal staggered
xh = mean([mesh.coor(1, mesh.cn(2, :)); mesh.coor(1, mesh.cn(4, :))]);
yh = mean([mesh.coor(2, mesh.cn(2, :)); mesh.coor(2, mesh.cn(4, :))]);

% Vertical staggered
xv = mean([mesh.coor(1, mesh.cn(3, :)); mesh.coor(1, mesh.cn(4, :))]);
yv = mean([mesh.coor(2, mesh.cn(3, :)); mesh.coor(2, mesh.cn(4, :))]);

% Volume divisions
xtck = linspace(X(1) - (X(2)-X(1)), X(2) + (X(2)-X(1)), 3*Nx+1);
ytck = linspace(Y(1) - (Y(2)-Y(1)), Y(2) + (Y(2)-Y(1)), 3*Ny+1);

% Combine hor and vert into the same quiver plot
xcom = [ reshape(xh, NN) , reshape(xv, NN) ];
ycom = [ reshape(yh, NN) , reshape(yv, NN) ];

% Periodicity
xrep = [repmat(xcom - ( X(2) - X(1) ), [3 1]) , ...
        repmat(xcom, [3 1])                   , ...
        repmat(xcom + ( X(2) - X(1) ), [3 1])];

yrep = [repmat(ycom - ( Y(2) - Y(1) ), [1 3]) ;
        repmat(ycom, [1 3])                   ;
        repmat(ycom + ( Y(2) - Y(1) ), [1 3])];

% Pre-correction plot
ucom = [ reshape(v(1, :), NN) , zeros(NN) ];
vcom = [ zeros(NN) , reshape(v(2, :), NN) ];
figure;
quiver(xrep, yrep, repmat(ucom, [3 3]), repmat(vcom, [3 3]));
xlim(X); ylim(Y); grid('on'); xticks(xtck); yticks(ytck);

% Post-correction plot
ucorrcom = [ reshape(vcorr(1, :), NN) , zeros(NN) ];
vcorrcom = [ zeros(NN) , reshape(vcorr(2, :), NN) ];
figure;
quiver(xrep, yrep, repmat(ucorrcom, [3 3]), repmat(vcorrcom, [3 3]));
xlim(X); ylim(Y); grid('on'); xticks(xtck); yticks(ytck);
