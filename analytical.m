% Analytical solution
t = 100; % time [s]
rho = 1.225; % density [kg/m^3]
nu = 1.48e-5; % viscosity [m^2/s]
F = 1; % exp(-8 * pi^2 * nu * t);
syms x y;
uv = F * [ cos(2 * pi * x) * sin(2 * pi * y)  ; 
	      -cos(2 * pi * y) * sin(2 * pi * x) ];
p = -F^2 * rho * (cos(4 * pi * x) + cos(4 * pi * y)) / 4;

% Check convective term
conv1 = divergence(uv(1) * uv, [x y]);
conv2 = divergence(uv(2) * uv, [x y]);

% Get numeric terms
X = [0 1];
Y = [0 1];
NN = round(logspace(0, 2, 10));
err = zeros(1, length(NN));
progress = waitbar(0, '...');
for k = 1:length(NN)
	Nx = NN(k);
	Ny = NN(k);
	
	mesh = StructuredMeshGenerator(X, Y, Nx + 1, Ny + 1).genMesh();
	vsv = VerticalStaggeredVolumes(mesh);
	hsv = HorizontalStaggeredVolumes(mesh);

	% Coordinates
	xh = mean([mesh.COOR(1, mesh.CN(2, :)); mesh.COOR(1, mesh.CN(3, :))]);
	yh = mean([mesh.COOR(2, mesh.CN(2, :)); mesh.COOR(2, mesh.CN(3, :))]);
	xv = mean([mesh.COOR(1, mesh.CN(3, :)); mesh.COOR(1, mesh.CN(4, :))]);
	yv = mean([mesh.COOR(2, mesh.CN(3, :)); mesh.COOR(2, mesh.CN(4, :))]);
	xp = xv;
	yp = yh;

	% Analytical convective term
	Ch = double(subs(conv1, {x, y}, {xh, yh}));
	Cv = double(subs(conv2, {x, y}, {xv, yv}));
	Ca = zeros(3 * Nx * Ny, 1);
	Ca(1:3:end) = Ch;
	Ca(2:3:end) = Cv;

	% Numeric fields
	uvh = double(subs(uv, {x, y}, {xh, yh})); uh = uvh(1, :); % u
	uvv = double(subs(uv, {x, y}, {xv, yv})); vv = uvv(2, :); % v
	pp = double(subs(p, {x, y}, {xp, yp}));
	v = zeros(3 * Nx * Ny, 1);
	v(1:3:end) = uh;
	v(2:3:end) = vv;
	v(3:3:end) = pp;

	Kch = hsv.calcKc(v, mesh);
	Kcv = vsv.calcKc(v, mesh);
	vol = repelem(mesh.dx .* mesh.dy, 3).';
	Cn = (Kch + Kcv) * v ./ vol;
	
	err(k) = norm(Cn - Ca);
	disp(['ERROR: ' num2str(err(k))]);
	waitbar(sum(NN(1:k).^2) / sum(NN.^2));
end
close(progress);

figure;
loglog(1./NN, err);

p = polyfit(log10(1./NN(2:end)), log10(err(2:end)), 1);
disp(['Slope: ' num2str(p(1))]);
