L = 1;
X = [0 L];
Y = [0 L];

Nx = 3;
Ny = 3;
NV = Nx * Ny;

mesh = StructuredMesh(X, Y, Nx, Ny);

% mesh = StructuredMeshGenerator(X, Y, Nx + 1, Ny + 1).genMesh();
vsv = VerticalStaggeredVolumes(mesh);
hsv = HorizontalStaggeredVolumes(mesh);
% 
% % Old
uvp = rand(3 * NV, 1); % ones(3 * Nx * Ny, 1);
% % u
% % v
% % p
% vol = repelem(mesh.dx .* mesh.dy, 3).';
% Kch = hsv.calcKc(uvp, mesh);
% Kcv = vsv.calcKc(uvp, mesh);
% Cn = (Kch + Kcv) * uvp; %  ./ vol;

% % New
u = uvp(1:3:end).'; % zeros(1, NV);
v = uvp(2:3:end).'; % zeros(1, NV);
p = uvp(3:3:end).'; % zeros(1, NV);
uv = [u; v];
c = hsv.convective(mesh, uv);
