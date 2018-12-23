classdef HorizontalStaggeredVolumes < StaggeredVolumes
	properties
		vidx; % 4xNV
		% 4 1
		% 3 2
		uidx; % 5xNV
		%   2
		% 5 1 3
		%   4
	end

	methods
		function this = HorizontalStaggeredVolumes(mesh)
			this.uidx = this.getNeighbors(mesh);
			
			this.vidx = [ mesh.rel(2, :)              ;
			              mesh.rel(2, mesh.rel(3, :)) ;
			              mesh.rel(3, :)              ;
			              1:mesh.NV                	 ];
		end
		
		function c = convective(this, mesh, uv)
			U = this.getVelocities(uv(1, :), this.uidx);
			
			Fn = uv(2, this.vidx(1, :)) .* mesh.dx(this.vidx(1, :)) + uv(2, this.vidx(4, :)) .* mesh.dx(this.vidx(4, :));
			Fs = uv(2, this.vidx(2, :)) .* mesh.dx(this.vidx(2, :)) + uv(2, this.vidx(3, :)) .* mesh.dx(this.vidx(3, :));
			Fe = (uv(1, this.uidx(1, :)) + uv(1, this.uidx(3, :))) .* (mesh.dy(this.uidx(1, :)) + mesh.dy(this.uidx(3, :))) / 2;
			Fw = (uv(1, this.uidx(1, :)) + uv(1, this.uidx(5, :))) .* (mesh.dy(this.uidx(1, :)) + mesh.dy(this.uidx(5, :))) / 2;
			F = 1/2 * [Fn; Fe; -Fs; -Fw];

% 			c = 1/4 * (ue .* Fe - uw .* Fw + un .* Fn - us .* Fs);
			c = sum(U .* F, 1);

		end
	end
end
