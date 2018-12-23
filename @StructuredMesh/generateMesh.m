function generateMesh(this, x, y, Nx, Ny)
	getCounts(this, Nx, Ny);
	getNodes(this, x, y);
	getCorners(this);
	getNeighbors(this);
	getDeltas(this);
	
	function getCounts(this, Nx, Ny)
		this.Nx = Nx;
		this.Ny = Ny;
		this.NV = Nx * Ny;
	end

	function getNodes(this, x, y)
		xx = linspace(x(1), x(2), this.Nx + 1);
		yy = linspace(y(1), y(2), this.Ny + 1);

		[X, Y] = ndgrid(xx, yy);
		this.coor = [X(:).'; Y(:).'];
	end

	function getCorners(this)
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

		this.cn = uint32([TR(:).'; BR(:).'; BL(:).'; TL(:).']);
	end

	function getNeighbors(this)
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

	function getDeltas(this)
		this.dx = sqrt(sum((this.coor(:, this.cn(1, :)) - this.coor(:, this.cn(4, :))).^2));
		this.dy = sqrt(sum((this.coor(:, this.cn(1, :)) - this.coor(:, this.cn(2, :))).^2));
	end
end
