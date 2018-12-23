classdef SquareMesh < StructuredMesh
	methods
		function this = SquareMesh(xy, N)
			this = this@StructuredMesh(xy, xy, N, N);
		end
	end
end
