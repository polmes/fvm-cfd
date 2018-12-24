% Init
L = 1;
X = [0 L];
Y = [0 L];
Nx = 32;
Ny = 32;
mesh = StructuredMesh(X, Y, Nx, Ny);

% Given velocity field
v=zeros(2,Nx*Ny);
v(2,0.5*Nx*Ny+0.5*Nx)=1;
% Centered velocities to plot as quiver
ucent=(v(1,:)+v(1,mesh.rel(4,:)))/2;
vcent=(v(2,:)+v(2,mesh.rel(3,:)))/2;

% Corrected velocity field
vcorr=v-mesh.cv.uvCorrection(mesh,v);
% Centered velocities to plot as quiver
ucorrcent=(vcorr(1,:)+vcorr(1,mesh.rel(4,:)))/2;
vcorrcent=(vcorr(2,:)+vcorr(2,mesh.rel(3,:)))/2;

[XX,YY]=ndgrid(linspace(X(1),X(2),Nx),linspace(Y(1),Y(2),Ny));

% Plot quivers
figure;
quiver(XX,YY,reshape(ucent,[Nx,Ny]),reshape(vcent,[Nx,Ny]));
xlim(X);ylim(Y);

figure;
quiver(XX,YY,reshape(ucorrcent,[Nx,Ny]),reshape(vcorrcent,[Nx,Ny]));
xlim(X);ylim(Y);
