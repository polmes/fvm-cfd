classdef UniformMesh < StructuredMesh
	methods
		function this = UniformMesh(x, y, Nx, Ny)
			this@StructuredMesh(x, y, Nx, Ny);
		end
		
		function generateNodes(this, x, y)
			xx = linspace(x(1), x(2), this.Nx + 1);
			yy = linspace(y(1), y(2), this.Ny + 1);

			[X, Y] = ndgrid(xx, yy);
			this.coor = [X(:).'; Y(:).'];
		end
	end
end
