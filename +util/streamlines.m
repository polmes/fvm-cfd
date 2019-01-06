function h = streamlines(mesh, uv, isNew, param)
	% h = util.streamlines(mesh, uv, isNew, param)
	% Plots the sreamlines (at random points) of a vector field uv with the given mesh.
	%
	% Parameters:
	%	mesh  - Mesh which will be used to determine the location of the nodes.
	%	uv    - Vector field to plot.
	%	isNew - Creates a new figure if true. Otherwise, plots on top of the currently open window.
	%	param - Cell array with {number of points, length of streamline}.
	%			Default values: {1000, 1}.
	%
	% Return values:
	%	h	  - Figure handle in which the plot has been drawn.
	
	% Init
	if nargin < 4
		npoints = 1000;
		length = 1;
	else
		npoints = param{1};
		length = param{2};
	end
	
	% Limits
	X = mesh.coor(1, [1 end]);
	Y = mesh.coor(2, [1 end]);
	NN = [mesh.Nx mesh.Ny];
	
	% Grid
	x = mesh.coor(1, mesh.cn(4, :));
	y = mesh.coor(2, mesh.cn(4, :));
	XX = reshape(x, NN);
	YY = reshape(y, NN);
	XXX = repmat([XX - mesh.coor(1,end); XX; XX + mesh.coor(1, end)], [1 3]);
	YYY = repmat([YY - mesh.coor(2,end), YY, YY + mesh.coor(2, end)], [3 1]);
	
	% Volume divisions
	xtck = mesh.coor(1, 1:(mesh.Nx + 1));
	ytck = mesh.coor(2, 1:(mesh.Nx + 1):(mesh.NV + mesh.Ny + 1));
	
	% Field
	U = ( uv(1, :) + uv(1, mesh.rel(4, :)) ) / 2;
	V = ( uv(2, :) + uv(2, mesh.rel(3, :)) ) / 2;
	UU = reshape(U, NN);
	VV = reshape(V, NN);
	UUU = repmat(UU, [3 3]);
	VVV = repmat(VV, [3 3]);
	
	% Generate random origins for streamlines
	pts = rand(2, npoints) .* [X(2) - X(1); Y(2) - Y(1)] + [X(1); Y(1)];
	
	% Create figure handle
	if nargin > 2 && isNew
		h = figure;
	end
	
	% Streamline plot
	streamline(XXX.', YYY.', UUU.', VVV.', pts(1, :), pts(2, :), [0.1 length/0.1]);
	
	% Grid
	xlim(X);
	ylim(Y);
	grid('on');
	xticks(xtck);
	yticks(ytck);
	xtickangle(90);
	
	% Labels
	xlabel('$X$ [m]', 'Interpreter', 'latex', 'FontSize', 15);
	ylabel('$Y$ [m]', 'Interpreter', 'latex', 'FontSize', 15);
	
	% Size
	set(gca, 'FontSize', 12);
	set(gcf, 'Units', 'centimeters', 'OuterPosition', [0 0 (mesh.Nx / mesh.Ny) * 20 (mesh.Ny / mesh.Nx) * 20]);
end
