classdef UniformMesh < msh.StructuredMesh
	% msh.UniformMesh
	% Represents a structured mesh with equidistant volume divisions.
	methods
		function this = UniformMesh(x, y, Nx, Ny)
			this@msh.StructuredMesh(x, y, Nx, Ny);
		end
		
		function generateNodes(this, x, y)
			% Generates the msh.coor matrix with equidistant vertices.
			xx = linspace(x(1), x(2), this.Nx + 1);
			yy = linspace(y(1), y(2), this.Ny + 1);

			[X, Y] = ndgrid(xx, yy);
			this.coor = [X(:).'; Y(:).'];
		end
	end
end
