classdef StaggeredVolumes < handle % < Volumes
	properties
		% eidx;
	end
	
	methods
		function U = getVelocities(~, u, idx)
% 			uu = reshape(v(idx(2:5, :)), 4, []);
% 			ux = ones(4, 1) * v(1, idx(1, :));
% 			u = 1/2 * (uu + ux);

			u1 = u(idx(1, :)) + u(idx(2, :));
			u2 = u(idx(1, :)) + u(idx(3, :));
			u3 = u(idx(1, :)) + u(idx(4, :));
			u4 = u(idx(1, :)) + u(idx(5, :));
			
			U = 1/2 * [u1; u2; u3; u4];
		end
		
		function F = getFlows(~, u, v, uidx, vidx, dx, dy)			
			f1 = (u(uidx(1, :)) + u(uidx(2, :))) .* dy(uidx(1, :));
			f2 = (u(uidx(1, :)) + u(uidx(3, :))) .* dy(uidx(1, :));
			f3 = v(vidx(1, :)) .* dx(vidx(1, :)) + v(vidx(2, :)) .* dx(vidx(2, :));
			f4 = v(vidx(3, :)) .* dx(vidx(3, :)) + v(vidx(4, :)) .* dx(vidx(4, :));
			
			F = 1/2 * [f1; -f2; f3; -f4];
		end
		
		function G = getGradients(~, u, idx, dx, dy)
			d1 = (u(idx(2, :)) - u(idx(1, :))) ./ dx(idx(2, :));
			d2 = (u(idx(1, :)) - u(idx(3, :))) ./ dx(idx(1, :));
			d3 = (u(idx(4, :)) - u(idx(1, :))) ./ (dy(idx(1, :)) + dy(idx(4, :)));
			d4 = (u(idx(1, :)) - u(idx(5, :))) ./ (dy(idx(1, :)) + dy(idx(5, :)));
			
			% For d3 and d4 we would have 1/2 x 1/(1/2), so they are removed
			G = dy(idx(1, :)) .* (d1 - d2) + (dx(idx(1, :)) + dx(idx(2, :))) .* (d3 - d4);
		end
	end
end
