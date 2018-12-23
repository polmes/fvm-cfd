classdef VerticalStaggeredVolumes
	properties
		uidx;%4*NV
		% 4 1
		% 3 2
		vidx;%5*NV
		%  2
		%5 1 3
		%  4
	end

	methods
		function this = VerticalStaggeredVolumes(MSH)
			for el=1:size(MSH.REL,2)
				this.uidx(:,el)=MSH.IDX(1,[MSH.REL(1,el);%1
										   el;%2
										   MSH.REL(4,el);%3
										   MSH.REL(1,MSH.REL(4,el))]);%4
				this.vidx(:,el)=MSH.IDX(2,[el;
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

		function Kd = calcKd(this,~,MSH)
			Kd=sparse(size(this.uidx,2)*3,size(this.uidx,2)*3);
			for el=1:size(this.uidx,2)
				
				nv=this.vidx(:,el);
% 				nu=this.uidx(:,el);
				dx=MSH.dx([el,MSH.REL(1,el),MSH.REL(2,el),MSH.REL(3,el),MSH.REL(4,el)]); %5*NV
				dy=MSH.dy([MSH.REL(1,el),el,...
				   MSH.REL(4,el),MSH.REL(4,MSH.REL(1,el))]); %4*NV

				kn=(dx(1)+dx(2))/(dy(4)+dy(1));
				ks=(dx(1)+dx(4))/(dy(2)+dy(3));
				ke=(dy(1)+dy(2))/(dx(3)+dx(1));
				kw=(dy(3)+dy(4))/(dx(5)+dx(1));

				Kd(nv(1),nv(1))=-kn-ke-ks-kw;
				Kd(nv(1),nv(2:end))=[kn ke ks kw];
			end
		end
	end
end
