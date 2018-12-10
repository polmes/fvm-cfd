classdef Mesh
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        CN;
        COOR;
        REL;
		IDX;
		dx;
		dy;
    end
    
    methods
        function this = Mesh(CN,COOR,REL,IDX)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            this.CN = CN;
            this.COOR = COOR;
            this.REL = REL;
			this.IDX = IDX;
			this.dx=sqrt(sum((this.COOR(:,this.CN(3,:))-this.COOR(:,this.CN(4,:))).^2));
			this.dy=sqrt(sum((this.COOR(:,this.CN(3,:))-this.COOR(:,this.CN(2,:))).^2));
		end
    end
end

