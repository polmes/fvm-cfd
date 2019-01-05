classdef HorizontalStaggeredVolumes < vol.StaggeredVolumes
	% vol.HorizontalStaggeredVolumes
	% Specialization of vol.StaggeredVolumes for volumes staggered in the x direction.

	properties
		% Velocities in the y direction surrounding the staggered volume
		%   ꞈ   ꞈ
		% +-2-+-1-+
		% | ꞈ | ꞈ |
		% +-4-+-3-+
		vidx;

		% Velocities in the x direction surrounding the staggered volume
		% +---+---+
		% |   4>  |
		% +---+---+
		% 3>  1>  2>
		% +---+---+
		% |   5>  |
		% +---+---+
		uidx;
	end

	methods
		function this = HorizontalStaggeredVolumes(mesh)
			this.uidx = [ 1:mesh.NV      ;
						  mesh.rel(2, :) ;
						  mesh.rel(4, :) ;
						  mesh.rel(1, :) ;
						  mesh.rel(3, :) ];
			
			this.vidx = [ mesh.rel(2, :)              ;
						  1:mesh.NV                	  ;
			              mesh.rel(2, mesh.rel(3, :)) ;
			              mesh.rel(3, :)              ];
		end
		
		function c = convective(this, mesh, uv)
			% [e; w; n; s]
			U = this.getVelocities(uv(1, :), this.uidx);
			F = this.getFlows(uv(1, :), uv(2, :), this.uidx, this.vidx, mesh.dx, mesh.dy);
			
			% c = 1/4 * (ue .* Fe - uw .* Fw + un .* Fn - us .* Fs);
			c = sum(U .* F, 1);
		end
		
		function d = diffusive(this, mesh, uv)
			d = this.getGradients(uv(1, :), this.uidx, mesh.dx, mesh.dy);
		end
	end
end
