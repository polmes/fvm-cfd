%% PRE

% Init
L = 1;
XY = [0 L];
N = 10;
mesh = msh.SquareMesh(XY, N);

% Find middle points
[~, indmc] = min( sum( abs(mesh.coor - L/2), 1 ) );
indmv = find(mesh.cn(4, :) == indmc);
if mod(mesh.Nx, 2) == 0
	% is even
	indm = [0 1] + indmv;
else
	% is odd
	indm = [0 2] + indmv;
end

%% TEST

% Arbitrary velocity field that fulfills global mass conservation
uv = zeros(2, mesh.NV);
uv(2, indm) = [-1 +1];

% Corrected velocity field
uvcorr = mesh.correction(uv);

%% POST

% Plot velocity field: before & after
util.quiver(mesh, uv);
util.quiver(mesh, uvcorr);
