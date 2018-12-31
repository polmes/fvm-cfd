function h = quiver(mesh, uv, isNew, scale)
	% Limits
	X = mesh.coor(1, [1 end]);
	Y = mesh.coor(2, [1 end]);
	NN = [mesh.Nx mesh.Ny];

	% Horizontal staggered
	xh = mean([mesh.coor(1, mesh.cn(2, :)); mesh.coor(1, mesh.cn(4, :))]);
	yh = mean([mesh.coor(2, mesh.cn(2, :)); mesh.coor(2, mesh.cn(4, :))]);

	% Vertical staggered
	xv = mean([mesh.coor(1, mesh.cn(3, :)); mesh.coor(1, mesh.cn(4, :))]);
	yv = mean([mesh.coor(2, mesh.cn(3, :)); mesh.coor(2, mesh.cn(4, :))]);

	% Volume divisions
	xtck = mesh.coor(1, 1:(mesh.Nx + 1));
	ytck = mesh.coor(2, 1:(mesh.Nx + 1):(mesh.NV + mesh.Ny + 1));

	% Combine u and v into the same quiver plot for automatic scaling
	XX = [ reshape(xh, NN) reshape(xv, NN) ];
	YY = [ reshape(yh, NN) reshape(yv, NN) ];
	UU = [ reshape(uv(1, :), NN) zeros(NN) ];
	VV = [ zeros(NN) reshape(uv(2, :), NN) ];
	
	% Create figure handle
	if nargin > 2 && isNew
		h = figure;
	end
	
	if (nargin == 4 && scale ~= 0)
		quiver(XX, YY, scale * UU, scale * VV, 'AutoScale', 'off');
	else
		quiver(XX, YY, UU, VV);
	end
	
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
