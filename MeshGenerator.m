classdef (Abstract) MeshGenerator < handle
    
    properties
        
    end
    
    methods (Abstract)            
        coor = COOR(this);
        cn = CN(this);
    end
end

