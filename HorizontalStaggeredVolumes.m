classdef HorizontalStaggeredVolumes < StaggeredVolumes
	properties
		vidx; % 4xNV
		% 2 1
		% 4 3
		uidx; % 5xNV
		%   4
		% 3 1 2
		%   5
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
			de = (uv(1, this.uidx(2, :)) - uv(1, this.uidx(1, :))) ./ mesh.dx(this.uidx(2, :));
			dw = (uv(1, this.uidx(1, :)) - uv(1, this.uidx(3, :))) ./ mesh.dx(this.uidx(1, :));
			dn = (uv(1, this.uidx(4, :)) - uv(1, this.uidx(1, :))) ./ (mesh.dy(this.uidx(4, :)) / 2 + mesh.dy(this.uidx(1, :)) / 2);
			ds = (uv(1, this.uidx(1, :)) - uv(1, this.uidx(5, :))) ./ (mesh.dy(this.uidx(1, :)) / 2 + mesh.dy(this.uidx(5, :)) / 2);
			
			d = mesh.dy(this.uidx(1, :)) .* (de - dw) + (mesh.dx(this.uidx(1, :)) / 2 + mesh.dx(this.uidx(2, :)) / 2)  .* (dn - ds);
		end
	end
end
