classdef VerticalStaggeredVolumes < StaggeredVolumes
	properties
		uidx; % 4xNV
		% 4 1
		% 3 2
		vidx; % 5xNV
		%   2
		% 5 1 3
		%   4
	end

	methods
		function this = VerticalStaggeredVolumes(mesh)
			this.vidx = this.getNeighbors(mesh);
			
			this.uidx = [ mesh.rel(1, :)               ;
			              1:mesh.NV                    ;
			              mesh.rel(4, :)               ;
			              mesh.rel(1, mesh.rel(4, :)) ];
		end

		function c = convective(this, mesh, uv)
			V = this.getVelocities(uv(2, :), this.vidx);
			
			Fn = (uv(2, this.vidx(1, :)) + uv(2, this.vidx(2, :))) .* (mesh.dx(this.vidx(1, :)) + mesh.dx(this.vidx(3, :))) / 2;
			Fs = (uv(2, this.vidx(1, :)) + uv(2, this.vidx(4, :))) .* (mesh.dx(this.vidx(1, :)) + mesh.dx(this.vidx(4, :))) / 2;
			Fe = uv(1, this.uidx(1, :)) .* mesh.dx(this.uidx(1, :)) + uv(1, this.uidx(2, :)) .* mesh.dx(this.uidx(2, :));
			Fw = uv(1, this.uidx(3, :)) .* mesh.dx(this.uidx(3, :)) + uv(1, this.uidx(4, :)) .* mesh.dx(this.uidx(4, :));
			F = 1/2 * [Fn; Fe; -Fs; -Fw];
			
% 			c = 1/4 * (ue .* Fe - uw .* Fw + un .* Fn - us .* Fs);
			c = sum(V .* F, 1);

		end
	end
end
