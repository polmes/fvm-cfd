% Init
L = 1;
X = [0 L];
Y = [0 L];
Nx = 3;
Ny = 3;
mesh = StructuredMesh(X, Y, Nx, Ny);

% Manufactured solution setup
syms x y;
t = 100; % time [s]
rho = 1.225; % density [kg/m^3]
nu = 1.48e-5; % viscosity [m^2/s]
F = 1; % exp(-8 * pi^2 * nu * t);

uv = F * [ cos(2 * pi * x) * sin(2 * pi * y)  ; 
	      -cos(2 * pi * y) * sin(2 * pi * x) ];
p = -F^2 * rho * (cos(4 * pi * x) + cos(4 * pi * y)) / 4;

% Horizontal Staggered
xh = mean([mesh.coor(1, mesh.cn(2, :)); mesh.coor(1, mesh.cn(3, :))]);
yh = mean([mesh.coor(2, mesh.cn(2, :)); mesh.coor(2, mesh.cn(3, :))]);

% Vertical Staggered
xv = mean([mesh.coor(1, mesh.cn(3, :)); mesh.coor(1, mesh.cn(4, :))]);
yv = mean([mesh.coor(2, mesh.cn(3, :)); mesh.coor(2, mesh.cn(4, :))]);

% Centered
xp = xv;
yp = yh;

% Velocity and pressure fields
uvh = double(subs(uv, {x, y}, {xh, yh})); uh = uvh(1, :); % u
uvv = double(subs(uv, {x, y}, {xv, yv})); vv = uvv(2, :); % v
pp = double(subs(p, {x, y}, {xp, yp}));
v = zeros(3 * Nx * Ny, 1);
v(1:3:end) = uh;
v(2:3:end) = vv;
v(3:3:end) = pp;

% Test variables
test = [v(1:3:end).'; v(2:3:end).'];

% Convective
C = mesh.convective(test);
