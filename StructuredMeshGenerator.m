classdef StructuredMeshGenerator < MeshGenerator
    
    % COOR: 2xNPOINTS matrix with the 2 coordinates of each point in the
    % mesh
    
    % CN: 4xNVOLUMES matrix with the 4 INDICES of each volume, starting by
    % the bottom left corner and following a counter-clockwise direction
    
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
            coor = [X(:)';Y(:)'];
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
            
            cn = [BL(:)';BR(:)';TR(:)';TL(:)'];
        end
        
        function rel = REL(this)
            SIZE = [this.xpoints-1,this.ypoints-1];
            
            [IL1,IL2] = meshgrid(1:SIZE(1),1:SIZE(2));
            
            % Periodic boundary conditions, therefore relation matrix
            % points accordingly and there is no need for a HALO
            
            NORTH1 = IL1;
			NORTH2 = mod(IL2,SIZE(2))+1;

            WEST1 = mod(IL1-2,SIZE(1))+1;
            WEST2 = IL2;
            
            SOUTH1 = IL1;
            SOUTH2 = mod(IL2-2,SIZE(2))+1;
            
            EAST1 = mod(IL1,SIZE(1))+1;
            EAST2 = IL2;
            
            NORTH = sub2ind(SIZE,NORTH1,NORTH2);
            WEST = sub2ind(SIZE,WEST1,WEST2);
            SOUTH = sub2ind(SIZE,SOUTH1,SOUTH2);
            EAST = sub2ind(SIZE,EAST1,EAST2);
            
            rel = [NORTH(:)';EAST(:)';SOUTH(:)';WEST(:)'];
        end

		function mesh=genMesh(this)
			mesh=Mesh(this.CN(),this.COOR(),this.REL())
		end
    end
end




