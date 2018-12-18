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
X = [0 1];
Y = [0 1];
NN = round(logspace(0.477, 2, 5));
errc = zeros(1, length(NN));
errd = zeros(1, length(NN));

progress = waitbar(0, '...');
for k = 1:length(NN)
	Nx = NN(k);
	Ny = NN(k);
	
	mesh = StructuredMeshGenerator(X, Y, Nx + 1, Ny + 1).genMesh();
	vsv = VerticalStaggeredVolumes(mesh);
	hsv = HorizontalStaggeredVolumes(mesh);

	% Coordinates

	% Horizontal Staggered
	xh = mean([mesh.COOR(1, mesh.CN(2, :)); mesh.COOR(1, mesh.CN(3, :))]);
	yh = mean([mesh.COOR(2, mesh.CN(2, :)); mesh.COOR(2, mesh.CN(3, :))]);

	% Vertical Staggered
	xv = mean([mesh.COOR(1, mesh.CN(3, :)); mesh.COOR(1, mesh.CN(4, :))]);
	yv = mean([mesh.COOR(2, mesh.CN(3, :)); mesh.COOR(2, mesh.CN(4, :))]);

	% Centered
	xp = xv;
	yp = yh;

	% Analytical convective term
	Ch = double(subs(conv1, {x, y}, {xh, yh}));
	Cv = double(subs(conv2, {x, y}, {xv, yv}));
	Ca = zeros(3 * Nx * Ny, 1);
	Ca(1:3:end) = Ch;
	Ca(2:3:end) = Cv;

	% Analytical diffusive term
	Dh = double(subs(diff1, {x, y}, {xh, yh}));
	Dv = double(subs(diff2, {x, y}, {xv, yv}));
	Da = zeros(3 * Nx * Ny, 1);
	Da(1:3:end) = Dh;
	Da(2:3:end) = Dv;

	% Analytic velocity and pressure fields
	uvh = double(subs(uv, {x, y}, {xh, yh})); uh = uvh(1, :); % u
	uvv = double(subs(uv, {x, y}, {xv, yv})); vv = uvv(2, :); % v
	pp = double(subs(p, {x, y}, {xp, yp}));
	v = zeros(3 * Nx * Ny, 1);
	v(1:3:end) = uh;
	v(2:3:end) = vv;
	v(3:3:end) = pp;

	vol = repelem(mesh.dx .* mesh.dy, 3).';

	% Numerical Convective Term
	Kch = hsv.calcKc(v, mesh);
	Kcv = vsv.calcKc(v, mesh);
	Cn = (Kch + Kcv) * v ./ vol;
	
	% Numerical Diffusive Term
	Kdh = hsv.calcKd(v, mesh);
	Kdv = vsv.calcKd(v, mesh);
	Dn = (Kdh + Kdv) * v ./ vol;

	% Errors
	errc(k) = norm((Cn - Ca).*vol);
	errd(k) = norm((Dn - Da).*vol);
	disp(['ERROR_CONV: ' num2str(errc(k))]);
	disp(['ERROR_DIFF: ' num2str(errd(k))]);

	waitbar(sum(NN(1:k).^2) / sum(NN.^2));
end
close(progress);

%% Output data
figure;
loglog(1./NN, errc);
hold on;
loglog(1./NN, errd);

pc = polyfit(log10(1./NN(2:end)), log10(errc(2:end)), 1);
pd = polyfit(log10(1./NN(2:end)), log10(errd(2:end)), 1);
disp(['Slope Convective: ' num2str(pc(1))]);
disp(['Slope Diffusive: ' num2str(pd(1))]);
