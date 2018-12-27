classdef SquareMesh < msh.UniformMesh
	methods
		function this = SquareMesh(xy, N)
			this = this@msh.UniformMesh(xy, xy, N, N);
		end
	end
end
