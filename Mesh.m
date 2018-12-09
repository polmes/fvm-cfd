classdef Mesh
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        CN;
        COOR;
        REL;
		dx;
		dy;
    end
    
    methods
        function obj = Mesh(CN,COOR,REL)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.CN = CN;
            obj.COOR = COOR;
            obj.REL = REL;
			obj.dx=sqrt(sum((obj.COOR(:,obj.CN(3,:))-obj.COOR(:,obj.CN(2,:))).^2));
			obj.dy=sqrt(sum((obj.COOR(:,obj.CN(4,:))-obj.COOR(:,obj.CN(1,:))).^2));        
		end
    end
end

