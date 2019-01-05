classdef StructuredMesh < msh.Mesh
	% msh.StructuredMesh
	% Represents a mesh with a rectangular structured discretization of the volumes in it.
	%
	% msh.StructuredMesh methods:
	%	StructuredMesh(x, y, Nx, Ny) - Constructs mesh with x and y dimensions and Nx and Ny divisions
	%	generateVolumes() - Generates the necessary staggered and centered volume objects.
	%	setCounts(Nx, Ny) - Sets the number of divisions in each axis and the total number of volumes.
	%	setCorners()   - Generates the mesh.cn matrix
	%	setNeighbors() - Generates the mesh.rel matrix
	%	setDeltas()    - Generates the mesh.dx, dy and vol matrices
	%	convective(uv) - Returns the convective term for the given velocity field
	%	diffusive(uv)  - Returns the diffusive term for the given velocity field
	%	correction(uv) - Wrapper function for the pseudo-pressure gradient

	properties
		Nx;% Number of volume divisions in the x axis
		Ny;% Number of volume divisions in the y axis

		dx;% Volume dimension in the x axis
		dy;% Volume dimension in the y axis

		hsv;% Horizontal staggered volumes object
		vsv;% Vertical staggered volumes object
		cv;% Centered volumes object
	end
	
	methods
		function this = StructuredMesh(x, y, Nx, Ny)
			% Constructs the StructuredMesh object with dimensions x and y
			% and number of volumes Nx and Ny in each dimension

			% Grid
			this.setCounts(Nx, Ny);
			this.generateNodes(x, y); % to be implemented in subclass
			this.setCorners();
			this.setNeighbors();
			this.setDeltas();
			
			% Volumes
			this.generateVolumes();
		end
				
		function generateVolumes(this)
			this.hsv = vol.HorizontalStaggeredVolumes(this);
			this.vsv = vol.VerticalStaggeredVolumes(this);
			this.cv  = vol.CenteredVolumes(this);
		end
		
		function setCounts(this, Nx, Ny)
			this.Nx = Nx;
			this.Ny = Ny;
			this.NV = Nx * Ny;
		end

		function setCorners(this)
			% Generates the mesh.cn matrix. This matrix is responsible for
			% giving each element its corresponding vertices,
			% according to the following pattern:
			% 3--4
			% |  |
			% 1--2

			SIZE = [this.Nx + 1, this.Ny + 1];

			[IL1,IL2] = ndgrid(1:SIZE(1),1:SIZE(2));

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

			this.cn = uint32([BL(:).'; BR(:).'; TL(:).'; TR(:).']);
		end

		function setNeighbors(this)
			% Generates the mesh.rel matrix. This matrix is responsible for
			% giving each volume its corresponding neighbors, according to
			% the following pattern:
			%+---+---+---+
			%|   | 1 |   |
			%+---+---+---+
			%| 4 | N | 2 |
			%+---+---+---+
			%|   | 3 |   |
			%+---+---+---+

			SIZE = [this.Nx, this.Ny];

			[IL1,IL2] = ndgrid(1:SIZE(1),1:SIZE(2));

			% Assuming periodic boundary conditions
			% Relation matrix avoids HALO

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

			this.rel = uint32([NORTH(:).'; EAST(:).'; SOUTH(:).'; WEST(:).']);
		end

		function setDeltas(this)
			% Generates the dx and dy vectors, which represent the dimensions
			% of the associated volume boundary.
			this.dx = sqrt(sum((this.coor(:, this.cn(3, :)) - this.coor(:, this.cn(4, :))).^2));
			this.dy = sqrt(sum((this.coor(:, this.cn(2, :)) - this.coor(:, this.cn(4, :))).^2));
			this.vol = this.dx .* this.dy;
		end		
		
		function C = convective(this, uv)
			C = [ this.hsv.convective(this, uv) ;
				  this.vsv.convective(this, uv) ];
		end
		
		function D = diffusive(this, uv)
			D = [ this.hsv.diffusive(this, uv) ;
				  this.vsv.diffusive(this, uv) ];
		end
		
		function [uvcorr, pp] = correction(this, uv)
			[uvcorr, pp] = this.cv.correction(this, uv);
		end
	end
end
