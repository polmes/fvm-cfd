%% PRE

% Fluid properties
rho = 1.225; % density [kg/m^3]
nu = 1.48e-5; % viscosity [m^2/s]

% Manufactured solution
t = 100; % time [s]
F = exp(-8 * pi^2 * nu * t);
syms x y;
uva = F * [ cos(2 * pi * x) * sin(2 * pi * y) ; 
           -cos(2 * pi * y) * sin(2 * pi * x) ];
uvf = matlabFunction(uva);

% Analytical convective term
conv1a = divergence(uva(1) * uva, [x y]);
conv2a = divergence(uva(2) * uva, [x y]);
conv1f = matlabFunction(conv1a);
conv2f = matlabFunction(conv2a);

% Analytical diffusive term
diff1a = laplacian(uva(1), [x y]);
diff2a = laplacian(uva(2), [x y]);
diff1f = matlabFunction(diff1a);
diff2f = matlabFunction(diff2a);

% Numerical parameters
L = 1; % mesh size [m]
XY = [0 L];

% Loop parameters
NN = round(logspace(log10(3), 2, 10)); % # of elements

%% LOOP

% Preallocate
errc = zeros(1, length(NN));
errd = zeros(1, length(NN));

progress = waitbar(0, 'Increasing Entropy...');
for k = 1:length(NN)
	% Init
	mesh = msh.SquareMesh(XY, NN(k));

	% Horizontal staggered
	xh = mean([mesh.coor(1, mesh.cn(2, :)); mesh.coor(1, mesh.cn(4, :))]);
	yh = mean([mesh.coor(2, mesh.cn(2, :)); mesh.coor(2, mesh.cn(4, :))]);

	% Vertical staggered
	xv = mean([mesh.coor(1, mesh.cn(3, :)); mesh.coor(1, mesh.cn(4, :))]);
	yv = mean([mesh.coor(2, mesh.cn(3, :)); mesh.coor(2, mesh.cn(4, :))]);

	% Analytical convective term
	Ch = conv1f(xh, yh);
	Cv = conv2f(xv, yv);
	Ca = [Ch; Cv];

	% Analytical diffusive term
	Dh = diff1f(xh, yh);
	Dv = diff2f(xv, yv);
	Da = [Dh; Dv];

	% Velocity field
	uvh = uvf(xh, yh); uh = uvh(1, :); % u
	uvv = uvf(xv, yv); vv = uvv(2, :); % v
	uv = [uh; vv];

	% Numerical convective term
	Cn = mesh.convective(uv) ./ mesh.vol;
	
	% Numerical diffusive term
	Dn = mesh.diffusive(uv) ./ mesh.vol;

	% Errors
	errc(k) = sqrt(sum(sum((Cn - Ca).^2 .* mesh.vol)));
	errd(k) = sqrt(sum(sum((Dn - Da).^2 .* mesh.vol)));

	% Print
	disp(['Iteration #' num2str(k)]);
	disp(['Error Convective: ' num2str(errc(k))]);
	disp(['Error Diffusive: ' num2str(errd(k))]);
	disp(' ');

	waitbar(sum(NN(1:k).^2) / sum(NN.^2));
end
close(progress);

%% POST

% Grid size
h = L ./ NN;

% Remove outliers
indc = find(errc > 1e-6);
indd = find(errd > 1e-6);

% Plot
figure;
hold('on');
loglog(h(indc), errc(indc), '^-', 'MarkerFaceColor', 'auto');
loglog(h(indd), errd(indd), 'v-', 'MarkerFaceColor', 'auto');
loglog(h, h.^2);
set(gca, 'XScale', 'log', 'YScale', 'log');
grid('on');
xlabel('Grid Size', 'Interpreter', 'latex', 'FontSize', 15);
ylabel('Error', 'Interpreter', 'latex', 'FontSize', 15);
legend({'Convective', 'Diffusive', 'h^2'}, 'Location', 'northwest');
set(findall(gca, 'Type', 'Line'), 'LineWidth', 1);
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'centimeters', 'Position', [0 0 21 14]);

% Slopes
pc = polyfit(log10(h(indc)), log10(errc(indc)), 1);
pd = polyfit(log10(h(indd)), log10(errd(indd)), 1);
disp(['Slope Convective: ' num2str(pc(1))]);
disp(['Slope Diffusive:  ' num2str(pd(1))]);
