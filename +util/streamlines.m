function h = streamlines(mesh, uv, isNew, npoints,len)
	
	NN=[mesh.Nx, mesh.Ny];
	
	X=mesh.coor(1,mesh.cn(4,:));
	Y=mesh.coor(2,mesh.cn(4,:));
	
	XX=reshape(X,NN);
	YY=reshape(Y,NN);
	
	XXX=repmat([XX-mesh.coor(1,end); XX; XX+mesh.coor(1,end)],[1,3]);
	YYY=repmat([YY-mesh.coor(2,end), YY, YY+mesh.coor(2,end)],[3,1]);
	
	U=(uv(1,:)+uv(1,mesh.rel(4,:)))/2;
	V=(uv(2,:)+uv(2,mesh.rel(3,:)))/2;
	UU = reshape(U, NN);
	VV = reshape(V, NN);
	UUU=repmat(UU,[3 3]);
	VVV=repmat(VV,[3 3]);
	
	pts=rand(2,npoints);
	
	if nargin > 2 && isNew
		h = figure;
	end
	
	streamline(XXX.',YYY.',UUU.',VVV.',pts(1,:),pts(2,:),[0.1 len/0.1]);
	
	
	xlim(mesh.coor(1,[1,end]));ylim(mesh.coor(2,[1,end]));
	set(gca, 'FontSize', 12);
end