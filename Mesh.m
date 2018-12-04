classdef Mesh
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        CN;
        COOR;
        REL;
    end
    
    methods
        function obj = Mesh(CN,COOR,REL)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.CN = CN;
            obj.COOR = COOR;
            obj.REL = REL;
        end
    end
end

