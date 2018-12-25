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

plotQuiver(mesh,v);
plotQuiver(mesh,vcorr);