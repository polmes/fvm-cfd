% mainB
% Script to verify the pseudo-pressure algorithm.

%% PRE

% Init
L = 1; % mesh size [m]
XY = [0 L];
N = 10; % # of elements
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

% Mass conservation verification: b = div(U)
[~, b] = mesh.cv.getPseudoPressure(mesh, uv);
[~, bcorr] = mesh.cv.getPseudoPressure(mesh, uvcorr);

% Print results
disp('Norm of div(U)');
disp(['- Before correction: ' num2str(norm(b))]);
disp(['- After correction: ' num2str(norm(bcorr))]);

% Plot velocity field: before & after
util.quiver(mesh, uv, true);
title('Velocity field before correction');
util.quiver(mesh, uvcorr, true);
title('Velocity field after correction');
