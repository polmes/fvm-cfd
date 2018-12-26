% Init
L = 1;
XY = [0 L];
N = 10;
mesh = SquareMesh(XY, N);

% Arbitrary velocity field that fulfills global mass conservation
uv = zeros(2, mesh.NV);
uv(2, round(0.5 * (mesh.NV - N) + 1)) = +1;
uv(2, round(0.5 * (mesh.NV - N) - 1)) = -1;

% Corrected velocity field
uvcorr = uv - mesh.correction(uv);

% Post
plotQuiver(mesh, uv);
plotQuiver(mesh, uvcorr);
