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
			
			this.uidx = [ mesh.rel(1, :)			  ;
					      1:mesh.NV					  ;
						  mesh.rel(4, :)			  ;
						  mesh.rel(1, mesh.rel(4, :)) ];
		end
		
		function c = convective(this, mesh, uv)
			v = this.getVelocities(uv(2, :), this.vidx);
			
			Fn = uv(2, this.vidx(1, :)) .* mesh.dx(this.vidx(1, :)) + uv(2, this.vidx(4, :)) .* mesh.dx(this.vidx(4, :));
			Fs = uv(2, this.vidx(2, :)) .* mesh.dx(this.vidx(2, :)) + uv(2, this.vidx(3, :)) .* mesh.dx(this.vidx(3, :));
			Fe = (uv(1, this.uidx(1, :)) + uv(1, this.uidx(3, :))) .* (mesh.dy(this.uidx(1, :)) + mesh.dy(this.uidx(3, :))) / 2;
			Fw = (uv(1, this.uidx(1, :)) + uv(1, this.uidx(5, :))) .* (mesh.dy(this.uidx(1, :)) + mesh.dy(this.uidx(5, :))) / 2;
		end
		
		function Kc = calcKc(this,v,MSH)
			Kc=sparse(size(this.uidx,2)*3,size(this.uidx,2)*3);
			for el=1:size(this.uidx,2)
				
				nv=this.vidx(:,el);
				nu=this.uidx(:,el);
				dx=MSH.dx([MSH.REL(3,el),el,MSH.REL(1,el)]); %3*NV
				dy=MSH.dy([MSH.REL(1,el),el,...
				   MSH.REL(4,el),MSH.REL(4,MSH.REL(1,el))]); %4*NV

				Fn=(v(nv(2))+v(nv(1)))*((dx(2)+dx(3))/2)/2;
				Fs=(v(nv(4))+v(nv(1)))*((dx(1)+dx(2))/2)/2;
				Fe=(v(nu(1))*dy(1)+v(nu(2))*dy(2))/2;
				Fw=(v(nu(4))*dy(4)+v(nu(3))*dy(3))/2;
				Kc(nv(1),nv(1))=1/2 * (Fn+Fe-Fs-Fw);
				Kc(nv(1),nv(2:end))=1/2 * [Fn Fe -Fs -Fw];
			end
		end

		
	end
end
