classdef GenericStaggeredVolumes < handle
    properties
        tidx;
        %   5+
		%-4 1 2+
		%   3-
        pidx;
        % 4-+ 1++
		% 3-- 2+-
        dt;
        dp;
    end
    methods
        function C = calcC(this,uv)
            C=zeros(size(this.tidx,2)*3,1);
            for el=1:size(this.tidx,2)
                nt=this.tidx(:,el);
				np=this.pidx(:,el);
				eldt=this.dt(:,el); %5*NV
				eldp=this.dp(:,el); %4*NV

                Ff=(uv(nt(1))*eldt(1)+uv(nt(2))*eldt(2))/2;
                Fb=(uv(nt(1))*eldt(1)+uv(nt(4))*eldt(4))/2;
				Fr=(uv(np(1))*eldp(1)+uv(np(2))*eldp(2))/2;
				Fl=(uv(np(3))*eldp(3)+uv(np(4))*eldp(4))/2;
                
                uf=(uv(nt(2))+uv(nt(1)))/2;
                ur=(uv(nt(3))+uv(nt(1)))/2;
                ub=(uv(nt(4))+uv(nt(1)))/2;
                ul=(uv(nt(5))+uv(nt(1)))/2;
                C(nt(1))=uf*Ff+ur*Fr-ub*Fb-ul*Fl;
            end
        end
        
        function D = calcD(this,uv)
            D=zeros(size(this.tidx,2)*3,1);
			for el=1:size(this.tidx,2)
                nt=this.tidx(:,el);
				%np=this.pidx(:,el);
				eldt=this.dt(:,el); %5*NV
				eldp=this.dp(:,el); %4*NV

				kf=(eldt(1)+eldt(2))/(eldp(4)+eldp(1));
				kb=(eldt(1)+eldt(4))/(eldp(2)+eldp(3));
				kr=(eldp(2)+eldp(1))/(eldt(1)+eldt(3));
				kl=(eldp(3)+eldp(4))/(eldt(1)+eldt(5));
                
                uf=uv(nt(2))-uv(nt(1));
                ur=uv(nt(3))-uv(nt(1));
                ub=uv(nt(4))-uv(nt(1));
                ul=uv(nt(5))-uv(nt(1));
                
				D(nt(1))=uf*kf+ur*kr+ub*kb+ul*kl;
			end
		end
    end
end