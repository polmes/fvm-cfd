% mainC
% Script to integrate the Navier-Stokes equations through time.

%% PRE

% Fluid properties
rho = 1.225; % density [kg/m^3]
nu = 0.1; % kinematic viscosity [m^2/s]

% Mesh setup
L = 1; % mesh size [m]
XY = [0 L];

% Time setup
tf = 0.5; % simulation time [s]
dt = 1e-3; % time-step [s]
dti = 2e-2; % save every # of iterations [s]
T = [0 tf]; 

% Manufactured solution
uvf = util.analytical(rho, nu);

% Loop parameters
NN = [5 10 20]; % # of elements

%% LOOP

% Preallocate
err = zeros(1, length(NN));

progress = waitbar(0, 'Increasing Entropy...');
for k = 1:length(NN)
	%% START
	
	% Init
	disp(['Starting convergence iteration #' num2str(k)]);
	disp(' ');
	mesh = msh.SquareMesh(XY, NN(k));

	% Horizontal staggered
	xh = mean([mesh.coor(1, mesh.cn(2, :)); mesh.coor(1, mesh.cn(4, :))]);
	yh = mean([mesh.coor(2, mesh.cn(2, :)); mesh.coor(2, mesh.cn(4, :))]);

	% Vertical staggered
	xv = mean([mesh.coor(1, mesh.cn(3, :)); mesh.coor(1, mesh.cn(4, :))]);
	yv = mean([mesh.coor(2, mesh.cn(3, :)); mesh.coor(2, mesh.cn(4, :))]);
	
	% Initial conditions
	uvh0 = uvf(0, xh, yh); uh0 = uvh0(1, :); % u
	uvv0 = uvf(0, xv, yv); vv0 = uvv0(2, :); % v
	uv0 = [uh0; vv0];
	
	%% NUMERICAL
	
	% Time integration
	[t, uvt, pt] = integration.explicit(mesh, uv0, rho, nu, T, dt, dti);
	
	%% ANALYTICAL

	% Repeat arrays
	NT = length(t);
	tt = repmat(reshape(t, [1 1 NT]), [1 mesh.NV]);
	xxh = repmat(xh, [1 1 NT]);
	yyh = repmat(yh, [1 1 NT]);
	xxv = repmat(xv, [1 1 NT]);
	yyv = repmat(yv, [1 1 NT]);

	% Velocity field
	uvh = uvf(tt, xxh, yyh); uh = uvh(1, :, :); % u(t)
	uvv = uvf(tt, xxv, yyv); vv = uvv(2, :, :); % v(t)
	uva = [uh; vv]; % uv(t)
	
	%% END
	
	% Error
	err(k) = max(max(max(uvt - uva)));

	% Print
	disp(' ');
	disp(['Convergence iteration #' num2str(k) ' ended']);
	disp(['Error: ' num2str(err(k))]);
	disp(' ');

	waitbar(sum(NN(1:k).^2) / sum(NN.^2));
end
close(progress);

%% POST

% Animation
util.render(mesh, t, uvt, '', 1);
util.render(mesh, t, pt, '', 1);

% Convergence of u(t), v(t) in element #1
el = 1;
figure;
hold('on');
plot(t, reshape(uvt(1, el, :), 1, []), '-x');
plot(t, reshape(uva(1, el, :), 1, []), '-+');
plot(t, reshape(uvt(2, el, :), 1, []), '-x');
plot(t, reshape(uva(2, el, :), 1, []), '-+');
grid('on');
xlabel('Time [s]', 'Interpreter', 'latex', 'FontSize', 15);
ylabel('Velocity [m/s]', 'Interpreter', 'latex', 'FontSize', 15);
legend({'$u_\mathrm{numerical}$', '$u_\mathrm{analytical}$', '$v_\mathrm{numerical}$', '$v_\mathrm{analytical}$'}, ...
	'Interpreter', 'latex', 'FontSize', 15, 'Location', 'northeast');
set(findall(gca, 'Type', 'Line'), 'LineWidth', 1);
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'centimeters', 'Position', [0 0 21 14]);

% Plot grid convergence
h = L ./ NN; % grid size
figure;
hold('on');
loglog(h, err, 'd-', 'MarkerFaceColor', 'auto');
loglog(h, h.^2);
set(gca, 'XScale', 'log', 'YScale', 'log');
grid('on');
xlabel('Grid Size', 'Interpreter', 'latex', 'FontSize', 15);
ylabel('Error', 'Interpreter', 'latex', 'FontSize', 15);
legend({'Velocity', 'h^2'}, 'Location', 'northwest');
set(findall(gca, 'Type', 'Line'), 'LineWidth', 1);
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'centimeters', 'Position', [0 0 21 14]);
