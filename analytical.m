% Manufactured solution setup
t = 100; % time [s]
rho = 1.225; % density [kg/m^3]
nu = 1.48e-5; % viscosity [m^2/s]
F = 1; % exp(-8 * pi^2 * nu * t);
syms x y;
uv = F * [ cos(2 * pi * x) * sin(2 * pi * y)  ; 
	      -cos(2 * pi * y) * sin(2 * pi * x) ];
p = -F^2 * rho * (cos(4 * pi * x) + cos(4 * pi * y)) / 4;

% Analytic convective term
conv1 = divergence(uv(1) * uv, [x y]);
conv2 = divergence(uv(2) * uv, [x y]);

% Analytic diffusive term
diff1= laplacian(uv(1),[x y]);
diff2= laplacian(uv(2),[x y]);

% Init numeric terms
L = 1;
X = [0 L];
Y = [0 L];
NN = round(logspace(log10(3), 2, 10));
errc = zeros(1, length(NN));
errd = zeros(1, length(NN));

progress = waitbar(0, '...');
for k = 1:length(NN)
	Nx = NN(k);
	Ny = NN(k);
	
	mesh = StructuredMesh(X, Y, Nx, Ny);

	% Coordinates

	% Horizontal Staggered
	xh = mean([mesh.coor(1, mesh.cn(1, :)); mesh.coor(1, mesh.cn(2, :))]);
	yh = mean([mesh.coor(2, mesh.cn(1, :)); mesh.coor(2, mesh.cn(2, :))]);

	% Vertical Staggered
	xv = mean([mesh.coor(1, mesh.cn(1, :)); mesh.coor(1, mesh.cn(4, :))]);
	yv = mean([mesh.coor(2, mesh.cn(1, :)); mesh.coor(2, mesh.cn(4, :))]);

	% Centered
	xp = xv;
	yp = yh;

	% Analytical convective term
	Ch = double(subs(conv1, {x, y}, {xh, yh}));
	Cv = double(subs(conv2, {x, y}, {xv, yv}));
	Ca = zeros(2, Nx * Ny);
	Ca(1,:) = Ch;
	Ca(2,:) = Cv;

	% Analytical diffusive term
	Dh = double(subs(diff1, {x, y}, {xh, yh}));
	Dv = double(subs(diff2, {x, y}, {xv, yv}));
	Da = zeros(2,Nx * Ny);
	Da(1,:) = Dh;
	Da(2,:) = Dv;

	% Analytic velocity and pressure fields
	uvh = double(subs(uv, {x, y}, {xh, yh})); uh = uvh(1, :); % u
	uvv = double(subs(uv, {x, y}, {xv, yv})); vv = uvv(2, :); % v
	pp = double(subs(p, {x, y}, {xp, yp}));
	v = zeros(2,Nx * Ny);
	v(1,:) = uh;
	v(2,:) = vv;

	vol = reshape(repelem(mesh.dx .* mesh.dy, 2).',[2 Nx*Ny]);

	% Numerical Convective Term

	Cn = mesh.convective(v) ./ vol;
	
	% Numerical Diffusive Term

	%Dn = mesh.diffusive(v) ./ vol;

	% Errors
	errc(k) = sqrt(sum(sum((Cn - Ca).^2.*vol)));
	%errd(k) = sqrt(sum(sum((Dn - Da).^2.*vol)));
	disp(['ERROR_CONV: ' num2str(errc(k))]);
	disp(['ERROR_DIFF: ' num2str(errd(k))]);

	waitbar(sum(NN(1:k).^2) / sum(NN.^2));
end
close(progress);

%% Output data
figure;
set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
hold('on');
loglog(L./NN, errc);
%loglog(L./NN, errd);

ind = find(errc ~= 0);
pc = polyfit(log10(L./NN(ind)), log10(errc(ind)), 1);
pd = polyfit(log10(L./NN(ind)), log10(errd(ind)), 1);
disp(['Slope Convective: ' num2str(pc(1))]);
disp(['Slope Diffusive:  ' num2str(pd(1))]);
