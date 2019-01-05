classdef SquareMesh < msh.UniformMesh
	% msh.SquareMesh
	% Mesh with equal dimensions and number of volumes in the x and y directions.
	%
	% msh.SquareMesh methods:
	%	SquareMesh(xy, N) - Constructs the mesh with dimensions xy and N divisions for both x and y 

	methods
		function this = SquareMesh(xy, N)
			this = this@msh.UniformMesh(xy, xy, N, N);
		end
	end
end
