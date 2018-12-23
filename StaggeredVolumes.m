classdef StaggeredVolumes < handle % < Volumes
	properties
		% eidx;
	end
	
	methods
		function idx = getNeighbors(~, mesh)
			idx = [ 1:mesh.NV ;
					mesh.rel  ];
		end
		
		function U = getVelocities(~, v, idx)
% 			uu = reshape(v(idx(2:5, :)), 4, []);
% 			ux = ones(4, 1) * v(1, idx(1, :));
% 			u = 1/2 * (uu + ux);

			un = v(idx(1, :)) + v(idx(2, :));
			ue = v(idx(1, :)) + v(idx(3, :));
			us = v(idx(1, :)) + v(idx(4, :));
			uw = v(idx(1, :)) + v(idx(5, :));
			
			U = 1/2 * [un; ue; us; uw];
		end
	end
end
