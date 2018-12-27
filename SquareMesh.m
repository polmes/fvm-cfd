classdef SquareMesh < UniformMesh
	methods
		function this = SquareMesh(xy, N)
			this = this@UniformMesh(xy, xy, N, N);
		end
	end
end
