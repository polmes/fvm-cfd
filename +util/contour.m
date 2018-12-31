function h = contour(mesh, p, isNew)
	% Limits
	X = mesh.coor(1, [1 end]);
	Y = mesh.coor(2, [1 end]);
	NN = [mesh.Nx mesh.Ny];
	
	% Create figure handle
	if nargin == 3 && isNew
		h = figure;
	end
	
	% Volume divisions
	xtck = mesh.coor(1, 1:(mesh.Nx + 1));
	ytck = mesh.coor(2, 1:(mesh.Nx + 1):(mesh.NV + mesh.Ny + 1));
	
	% Contour plot
	P = reshape(p, NN); % reorder vector into matrix
	XX = [X(1) + mesh.dx(1)/2 X(end) - mesh.dx(end)/2];
	YY = [Y(1) + mesh.dy(1)/2 Y(end) - mesh.dy(end)/2];
	imagesc(XX, YY, P);
	set(gca, 'YDir', 'normal');
	
	% Grid
	xlim(X);
	ylim(Y);
	grid('on');
	xticks(xtck);
	yticks(ytck);
	
	% Labels
	xlabel('$X$ [m]', 'Interpreter', 'latex', 'FontSize', 15);
	ylabel('$Y$ [m]', 'Interpreter', 'latex', 'FontSize', 15);
	
	% Size
	set(gca, 'FontSize', 12);
	set(gcf, 'Units', 'centimeters', 'OuterPosition', [0 0 (mesh.Nx / mesh.Ny) * 20 (mesh.Ny / mesh.Nx) * 20]);
end
