% Setup
L = 1;
X = [0 L];
Y = [0 L];
Nx = 3;
Ny = 3;
NV = Nx * Ny;

% Init
mesh = StructuredMeshGenerator(X, Y, Nx + 1, Ny + 1).genMesh();
hsv = HorizontalStaggeredVolumes(mesh);
vsv = VerticalStaggeredVolumes(mesh);

% Variables
uvp = rand(3 * NV, 1); % ones(3 * Nx * Ny, 1);
vol = repelem(mesh.dx .* mesh.dy, 3).';

% Convective
Kch = hsv.calcKc(uvp, mesh);
Kcv = vsv.calcKc(uvp, mesh);
Cn = (Kch + Kcv) * uvp; %  ./ vol;
