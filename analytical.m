%% PRE

% Manufactured solution
t = 100; % time [s]
rho = 1.225; % density [kg/m^3]
nu = 1.48e-5; % viscosity [m^2/s]
F = 1; % exp(-8 * pi^2 * nu * t);
syms x y;
uvf = F * [ cos(2 * pi * x) * sin(2 * pi * y)  ; 
          -cos(2 * pi * y) * sin(2 * pi * x) ];
pf = -F^2 * rho * (cos(4 * pi * x) + cos(4 * pi * y)) / 4;

% Analytical convective term
conv1 = divergence(uvf(1) * uvf, [x y]);
conv2 = divergence(uvf(2) * uvf, [x y]);

% Analytical diffusive term
diff1 = laplacian(uvf(1),[x y]);
diff2 = laplacian(uvf(2),[x y]);

% Numerical parameters
L = 1;
XY = [0 L];

% Loop parameters
NN = round(logspace(log10(3), 2, 10));

%% LOOP

% Preallocate
errc = zeros(1, length(NN));
errd = zeros(1, length(NN));

progress = waitbar(0, 'Increasing Entropy...');
for k = 1:length(NN)
	% Init
	mesh = SquareMesh(XY, NN(k));

	% Horizontal staggered
	xh = mean([mesh.coor(1, mesh.cn(1, :)); mesh.coor(1, mesh.cn(2, :))]);
	yh = mean([mesh.coor(2, mesh.cn(1, :)); mesh.coor(2, mesh.cn(2, :))]);

	% Vertical staggered
	xv = mean([mesh.coor(1, mesh.cn(1, :)); mesh.coor(1, mesh.cn(4, :))]);
	yv = mean([mesh.coor(2, mesh.cn(1, :)); mesh.coor(2, mesh.cn(4, :))]);

	% Centered
	xp = xv;
	yp = yh;

	% Analytical convective term
	Ch = double(subs(conv1, {x, y}, {xh, yh}));
	Cv = double(subs(conv2, {x, y}, {xv, yv}));
	Ca = [Ch; Cv];

	% Analytical diffusive term
	Dh = double(subs(diff1, {x, y}, {xh, yh}));
	Dv = double(subs(diff2, {x, y}, {xv, yv}));
	Da = [Dh; Dv];

	% Velocity field
	uvh = double(subs(uvf, {x, y}, {xh, yh})); uh = uvh(1, :); % u
	uvv = double(subs(uvf, {x, y}, {xv, yv})); vv = uvv(2, :); % v
	uv = [uh; vv];
	
	% Pressure field
	p = double(subs(pf, {x, y}, {xp, yp}));	

	% Numerical convective term
	Cn = mesh.convective(uv) ./ mesh.vol;
	
	% Numerical diffusive term
% 	Dn = mesh.diffusive(uv) ./ mesh.vol;

	% Errors
	errc(k) = sqrt(sum(sum((Cn - Ca).^2 .* mesh.vol)));
% 	errd(k) = sqrt(sum(sum((Dn - Da).^2 .* mesh.vol)));

	% Print
	disp(['Iteration #' num2str(k)]);
	disp(['Error Convective: ' num2str(errc(k))]);
% 	disp(['Error Diffusive: ' num2str(errd(k))]);
	disp(' ');

	waitbar(sum(NN(1:k).^2) / sum(NN.^2));
end
close(progress);

%% POST

% Grid size
h = L ./ NN;

% Plot
figure;
hold('on');
loglog(h, errc);
% loglog(h, errd);
loglog(h, h.^2);
set(gca, 'XScale', 'log', 'YScale', 'log');
grid('on');
xlabel('Grid Size', 'Interpreter', 'latex', 'FontSize', 15);
ylabel('Error', 'Interpreter', 'latex', 'FontSize', 15);
legend('Convetive', 'h^2'); % 'Diffusive'
set(findall(gca, 'Type', 'Line'), 'LineWidth', 1);
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'centimeters', 'Position', [0 0 21 14]);

% Slopes
indc = find(errc ~= 0);
% indd = find(errd ~= 0);
pc = polyfit(log10(h(indc)), log10(errc(indc)), 1);
% pd = polyfit(log10(h(indd)), log10(errd(indd)), 1);
disp(['Slope Convective: ' num2str(pc(1))]);
% disp(['Slope Diffusive:  ' num2str(pd(1))]);
