classdef VerticalStaggeredVolumes < vol.StaggeredVolumes
	% vol.VerticalStaggeredVolumes
	% Specialization of vol.StaggeredVolumes for volumes staggered in the y direction.

	properties
		% Velocities in the x direction surrounding the staggered volume
		% +---+
		% 3>  1>
		% +---+
		% 4>  2>
		% +---+
		uidx;

		% Velocities in the y direction surrounding the staggered volume
		%       ꞈ
		% +---+-2-+---+
		% | ꞈ | ꞈ | ꞈ |
		% +-5-+-1-+-4-+
		% |   | ꞈ |   |
		% +---+-3-+---+
		vidx;
	end

	methods
		function this = VerticalStaggeredVolumes(mesh)
			this.vidx = [ 1:mesh.NV      ;
						  mesh.rel(1, :) ;
						  mesh.rel(3, :) ;
						  mesh.rel(2, :) ;
						  mesh.rel(4, :) ];
			
			this.uidx = [ mesh.rel(1, :)              ;
			              1:mesh.NV                   ;
			              mesh.rel(1, mesh.rel(4, :)) ;
						  mesh.rel(4, :)              ];
		end

		function c = convective(this, mesh, uv)
			% [n; s; e; w]
			V = this.getVelocities(uv(2, :), this.vidx);
			F = this.getFlows(uv(2, :), uv(1, :), this.vidx, this.uidx, mesh.dy, mesh.dx);
			
			% c = 1/4 * (ue .* Fe - uw .* Fw + un .* Fn - us .* Fs);
			c = sum(V .* F, 1);
		end
		
		function d = diffusive(this, mesh, uv)
			d = this.getGradients(uv(2, :), this.vidx, mesh.dy, mesh.dx);
		end
	end
end
