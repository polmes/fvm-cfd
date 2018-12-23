L = 1;
XY = [0 L];
N = 3;

% Init
mesh = SquareMesh(X, N);

% Variables
uv = ones(2, mesh.NV);

% Test
C = mesh.convective(uv);
