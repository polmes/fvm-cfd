classdef StaggeredVolumes < handle
	properties
		msh
		vsv
		hsv
	end
	methods
        function this = StaggeredVolumes(MSH)
			this.msh=MSH;
			this.vsv=VerticalStaggeredVolumes(MSH);
			this.hsv=HorizontalStaggeredVolumes(MSH);
			%this.cv=CenteredVolumes(MSH)
		end

        function C = calcC(this,v)
			Ch=this.hsv.calcC(v,this.msh);
			Cv=this.vsv.calcC(v,this.msh);
			C=Ch+Cv;
		end

        function D = calcD(this,v)
			Dh=this.hsv.calcD(v,this.msh);
			Dv=this.vsv.calcD(v,this.msh);
			D=Dh+Dv;
		end
	end
end
