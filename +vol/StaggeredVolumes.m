classdef StaggeredVolumes < vol.Volumes
	% vol.StaggeredVolumes
	% Base class for both the horizontal and vertical staggered volumes.
	% The main purpose of this class is to obtain the diffusive and convective
	% term for each of the volumes.
	%
	% vol.StaggeredVolumes methods:
	%	convective(mesh, uv) - Returns the convective term for each volume
	%	diffusive(mesh, uv)  - Returns the diffusive term for each volume
	%	getVelocities(u, idx) - Returns the velocities at the volume boundary
	%	getFlows(u, v, uidx, vidx, dx, dy) - Returns the mass flows at the volume boundary
	%	getGradients(u, idx, dx, dy) - Returns the velocity gradient at the volume boundary

	methods (Abstract)
		c = convective(this, mesh, uv)
		d = diffusive(this, mesh, uv)
	end

	methods
		function U = getVelocities(~, u, idx)
			% Returns the velocities given by the u component
			% at the staggered volume boundaries
			% For a horizontal volume, this would look like the following:
			% +---3>--+
			% | 2>| 1>|
			% +---4>--+

			u1 = u(idx(1, :)) + u(idx(2, :));
			u2 = u(idx(1, :)) + u(idx(3, :));
			u3 = u(idx(1, :)) + u(idx(4, :));
			u4 = u(idx(1, :)) + u(idx(5, :));
			
			U = 1/2 * [u1; u2; u3; u4];
		end
		
		function F = getFlows(~, u, v, uidx, vidx, dx, dy)
			% Returns the mass flows given by the u and v components
			% at the staggered volume boundaries
			% For a horizontal volume, this would look like the following:
			%     ꞈ
			% +---3---+
			% |<2 | 1>|
			% +---4---+
			%     ˇ

			f1 = (u(uidx(1, :)) + u(uidx(2, :))) .* dy(uidx(1, :));
			f2 = (u(uidx(1, :)) + u(uidx(3, :))) .* dy(uidx(1, :));
			f3 = v(vidx(1, :)) .* dx(vidx(1, :)) + v(vidx(2, :)) .* dx(vidx(2, :));
			f4 = v(vidx(3, :)) .* dx(vidx(3, :)) + v(vidx(4, :)) .* dx(vidx(4, :));
			
			F = 1/2 * [f1; -f2; f3; -f4];
		end
		
		function G = getGradients(~, u, idx, dx, dy)
			% Returns the gradient of the velocity field component u at the
			% volume boundary with respect to x and y dimensions

			d1 = (u(idx(2, :)) - u(idx(1, :))) ./ dx(idx(2, :));
			d2 = (u(idx(1, :)) - u(idx(3, :))) ./ dx(idx(1, :));
			d3 = (u(idx(4, :)) - u(idx(1, :))) ./ (dy(idx(1, :)) + dy(idx(4, :)));
			d4 = (u(idx(1, :)) - u(idx(5, :))) ./ (dy(idx(1, :)) + dy(idx(5, :)));

			% For d3 and d4 we would have 1/2 x 1/(1/2), so they are removed
			G = dy(idx(1, :)) .* (d1 - d2) + (dx(idx(1, :)) + dx(idx(2, :))) .* (d3 - d4);
		end
	end
end
