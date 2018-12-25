classdef VerticalStaggeredVolumes < StaggeredVolumes
	properties
		uidx; % 4xNV
		% 3 1
		% 4 2
		vidx; % 5xNV
		%   2
		% 5 1 4
		%   3
	end

	methods
		function this = VerticalStaggeredVolumes(mesh)
			this.vidx = [ 1:mesh.NV      ;
						  mesh.rel(1, :) ;
						  mesh.rel(3, :) ;
						  mesh.rel(2, :) ;
						  mesh.rel(4, :) ];
			
			this.uidx = [ mesh.rel(1, :)               ;
			              1:mesh.NV                    ;
			              mesh.rel(1, mesh.rel(4, :))  ;
						  mesh.rel(4, :)               ];
		end

		function c = convective(this, mesh, uv)
			% [n; s; e; w]
			V = this.getVelocities(uv(2, :), this.vidx);
			F = this.getFlows(uv(2, :), uv(1, :), this.vidx, this.uidx, mesh.dy, mesh.dx);
			
			% c = 1/4 * (ue .* Fe - uw .* Fw + un .* Fn - us .* Fs);
			c = sum(V .* F, 1);
		end
		
		function d = diffusive(this, mesh, uv)
			dn = (uv(2, this.vidx(2, :)) - uv(2, this.vidx(1, :))) ./ mesh.dy(this.vidx(2, :));
			ds = (uv(2, this.vidx(1, :)) - uv(2, this.vidx(3, :))) ./ mesh.dy(this.vidx(1, :));
			de = (uv(2, this.vidx(4, :)) - uv(2, this.vidx(1, :))) ./ (mesh.dx(this.vidx(4, :)) / 2 + mesh.dx(this.vidx(1, :)) / 2);
			dw = (uv(2, this.vidx(1, :)) - uv(2, this.vidx(5, :))) ./ (mesh.dx(this.vidx(1, :)) / 2 + mesh.dx(this.vidx(5, :)) / 2);
			
			d = mesh.dx(this.vidx(1, :)) .* (dn - ds) + (mesh.dy(this.vidx(1, :)) / 2 + mesh.dy(this.vidx(2, :)) / 2)  .* (de - dw);
		end
	end
end
