classdef StructuredMeshGenerator < MeshGenerator
    
    properties
        xpoints;
        ypoints;
        
        xrange;
        yrange;
    end
    
    methods
        function obj = StructuredMeshGenerator(xrange,yrange,xpoints,ypoints)
            obj.xpoints = xpoints;
            obj.ypoints = ypoints;
            obj.xrange = xrange;
            obj.yrange = yrange;
        end
        
        function coor = COOR(this)
            xp = linspace(this.xrange(1),this.xrange(2),this.xpoints);
            yp = linspace(this.yrange(1),this.yrange(2),this.ypoints);
            
            [X,Y] = meshgrid(xp,yp);
            coor = [X(:),Y(:)];
        end
        
        function cn = CN(this)
            SIZE = [this.xpoints,this.ypoints];
            
            [IL1,IL2] = meshgrid(1:this.xpoints,1:this.ypoints);
            
            % Corners
            BLx = IL1(1:end-1,1:end-1);
            BLy = IL2(1:end-1,1:end-1);
            
            BRx = IL1(2:end,1:end-1);
            BRy = IL2(2:end,1:end-1);
            
            TRx = IL1(2:end,2:end);
            TRy = IL2(2:end,2:end);
            
            TLx = IL1(1:end-1,2:end);
            TLy = IL2(1:end-1,2:end);
            
            % Linear corners
            BL = sub2ind(SIZE,BLx,BLy);
            BR = sub2ind(SIZE,BRx,BRy);
            TR = sub2ind(SIZE,TRx,TRy);
            TL = sub2ind(SIZE,TLx,TLy);
            
            cn = [BL(:),BR(:),TR(:),TL(:)];
        end
    end
end




