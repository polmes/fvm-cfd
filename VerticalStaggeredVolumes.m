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
		function Kf = calcKf(this,v,MSH)
			Kf=sparse(size(this.nodes,2),size(this.nodes,2))
			for el=1:size(this.nodes,2)
				n=MSH.COOR(:,this.nodes(:,el))
				nv=this.vidx(:,el)
				nu=this.uidx(:,el)
				dx=[MSH.dx(el),MSH.dx(MSH.REL(1,el))] %2*NV
				dy=[MSH.dy(MSH.REL(1,el)),MSH.dy(el),...
					MSH.dy(MSH.REL(4,el)),MSH.dy(MSH.REL(4,MSH.REL(1,el)))] %4*NV

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
