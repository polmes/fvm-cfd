classdef VerticalStaggeredVolumes < StaggeredVolumes
	properties
		uidx%4*NV
		% 4 1
		% 3 2
		vidx%5*NV
		%  2
		%5 1 3
		%  4
		nodes%6*NV
		% 5 6
		% 3 4
		% 1 2
	end

	methods
		function this = VerticalStaggeredVolumes(MSH)
			for el=1:size(MSH.REL,2)
				this.uidx(:,el)=MSH.IDX(1,[MSH.REL(1,el),%1
										   el,%2
										   MSH.REL(4,el),%3
										   MSH.REL(1,MSH.REL(4,el))]);%4
				this.vidx(:,el)=MSH.IDX(2,[el,
										   MSH.REL(1,el),
										   MSH.REL(2,el),
										   MSH.REL(3,el),
										   MSH.REL(4,el)]);
			end
this.uidx
		end
		
		function Kf = calcKf(this,v,MSH)
			Kf=sparse(size(MSH.REL,2)*3,size(MSH.REL,2)*3)
			for el=1:size(MSH.REL,2)
				
				nv=this.vidx(:,el)
				nu=this.uidx(:,el)
				dx=MSH.dx([el,MSH.REL(1,el)]) %2*NV
				dy=MSH.dy([MSH.REL(1,el),el,...
				   MSH.REL(4,el),MSH.REL(4,MSH.REL(1,el))]) %4*NV

				Fn=(v(nv(2))+v(nv(1)))*dx(1)/2
				Fs=(v(nv(4))+v(nv(1)))*dx(2)/2
				Fe=(v(nu(1))*dy(1)+v(nu(2))*dy(2))/2
				Fw=(v(nu(4))*dy(4)+v(nu(3))*dy(3))/2
				Kf(el,nv(1))=Fe-Fw+Fn-Fs
				Kf(el,nv(2:end))=[Fe -Fw Fn -Fs]
			end
		end
	end
end
