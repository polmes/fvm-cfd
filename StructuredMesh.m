classdef StructuredMesh < Mesh
	properties
		Nx;
		Ny;
		dx;
		dy;
		hsv;
		vsv;
		cv;
	end
	
	methods
		function this = StructuredMesh(x, y, Nx, Ny)
			this.generateMesh(x, y, Nx, Ny);
			this.generateVolumes();
		end
				
		function generateVolumes(this)
			this.hsv = HorizontalStaggeredVolumes(this);
			this.vsv = VerticalStaggeredVolumes(this);
			this.cv = CenteredVolumes(this);
		end
		
		function C = convective(this, uv)
			C = [ this.hsv.convective(this, uv) ;
				  this.vsv.convective(this, uv) ];
		end
		
		function D = diffusive(this, uv)
			D = [ this.hsv.diffusive(this, uv) ;
				  this.vsv.diffusive(this, uv) ];
		end
		
		function [uvcorr, pp] = correction(this, uv)
			[uvcorr, pp] = this.cv.correction(this, uv);
		end
	end
end