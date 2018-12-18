classdef HorizontalStaggeredVolumes < StaggeredVolumes
	properties
		vidx;%4*NV
		% 4 1
		% 3 2
		uidx;%5*NV
		%  2
		%5 1 3
		%  4
	end

	methods
		function this = HorizontalStaggeredVolumes(MSH)
			for el=1:size(MSH.REL,2)
				this.vidx(:,el)=MSH.IDX(2,[MSH.REL(2,el);%1
										   MSH.REL(2,MSH.REL(3,el));%2
										   MSH.REL(3,el);%3
										   el]);%4
				this.uidx(:,el)=MSH.IDX(1,[el;
										   MSH.REL(1,el);
										   MSH.REL(2,el);
										   MSH.REL(3,el);
										   MSH.REL(4,el)]);
			end
		end
		
		function Kc = calcKc(this,v,MSH)
			Kc=sparse(size(this.uidx,2)*3,size(this.uidx,2)*3);
			for el=1:size(this.uidx,2)
				
				nv=this.vidx(:,el);
				nu=this.uidx(:,el);
				dy=MSH.dy([MSH.REL(4,el),el,MSH.REL(2,el)]); %2*NV
				dx=MSH.dx([MSH.REL(2,el),MSH.REL(2,MSH.REL(3,el)),...
				   MSH.REL(3,el),el]); %4*NV

				Fe=(v(nu(3))+v(nu(1)))*((dy(2)+dy(3))/2)/2;
				Fw=(v(nu(5))+v(nu(1)))*((dy(1)+dy(2))/2)/2;
				Fn=(v(nv(1))*dx(1)+v(nv(4))*dx(4))/2;
				Fs=(v(nv(2))*dx(2)+v(nv(3))*dx(3))/2;
				Kc(nu(1),nu(1))=1/2 * (Fn+Fe-Fs-Fw);
				Kc(nu(1),nu(2:end))=1/2 * [Fn Fe -Fs -Fw];
			end
		end

		function Kd = calcKd(this,~,MSH)
			Kd=sparse(size(this.uidx,2)*3,size(this.uidx,2)*3);
			for el=1:size(this.uidx,2)
				
% 				nv=this.vidx(:,el);
				nu=this.uidx(:,el);
				dy=MSH.dy([el,MSH.REL(1,el),MSH.REL(2,el),MSH.REL(3,el),MSH.REL(4,el)]); %5*NV
				dx=MSH.dx([MSH.REL(2,el),MSH.REL(2,MSH.REL(3,el)),...
				   MSH.REL(3,el),el]); %4*NV

				kn=(dx(1)+dx(4))/(dy(2)+dy(1));
				ks=(dx(2)+dx(3))/(dy(4)+dy(1));
				ke=(dy(3)+dy(1))/(dx(2)+dx(1));
				kw=(dy(5)+dy(1))/(dx(4)+dx(3));

				Kd(nu(1),nu(1))=-kn-ke-ks-kw;
				Kd(nu(1),nu(2:end))=[kn ke ks kw];
			end
		end
	end
end