function [CV] = generateMesh(Nx, Ny, dimX, dimY)
	global NODES NV;
	
	NV = Nx * Ny;
	
	x = linspace(0, dimX, Nx + 1);
	y = linspace(0, dimY, Ny + 1);
	
	[Y, X] = meshgrid(y, x);
	NODES = [X(:).'; Y(:).'];
	
	
	% sub2ind
	i1 = 1:NV; i1((Nx + 1):(Nx + 1):NV) = [];
	i2 = i1 + 1;
	i3 = i1 + Nx + 2;
	i4 = i1 + Nx + 1;
	ind = uint32([i1; i2; i3; i4]);
	
	CV = CenteredVolumes(ind);
% 	HSV = HorizontalStaggeredVolumes(...);
% 	VSV = VerticalStaggeredVolumes(...);
end
