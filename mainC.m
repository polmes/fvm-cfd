%% PRE

% Fluid properties
rho = 1.225; % density [kg/m^3]
nu = 0.1; % 1.48e-5; % kinematic viscosity [m^2/s]

% Mesh setup
L = 1; % [m]
N = 10;

% Time setup
tf = 0.05; % 0.52; % 0.05; % [s]
dt = 1e-5; % 1e-2; % 1e-3; % time-step [s]
dti = 2e-3; % 1e-2; % save every # of iterations

% Initial conditions
v0 = 1; % [m/s]

%% LOOP

% Init mesh
XY = [0 L];
mesh = msh.SquareMesh(XY, N);

% Find middle points
[~, indmc] = min( sum( abs(mesh.coor - L/2), 1 ) );
indmv = find(mesh.cn(4, :) == indmc);
if mod(mesh.Nx, 2) == 0
	% is even
	indm = (0:1) + indmv;
else
	% is odd
	indm = (0:2) + indmv;
end

% Init velocity
uv0 = zeros(2, mesh.NV);
uv0(2, indm) = v0;

% Time integration
T = [0 tf];
[t, uvt, pt] = integration.explicit(mesh, uv0, rho, nu, T, dt, dti);

%% POST

util.render(mesh, t, uvt);
	