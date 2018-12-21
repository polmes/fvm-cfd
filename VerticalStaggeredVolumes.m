classdef VerticalStaggeredVolumes < GenericStaggeredVolumes
    methods
        function this = VerticalStaggeredVolumes(MESH)
            this.dt=MESH.dx([1:size(MESH.REL,2);MESH.REL(:,:)]);
            this.dp=MESH.dy([MESH.REL(1,:);1:size(MESH.REL,2);MESH.REL(4,:);MESH.REL(4,MESH.REL(1,:))]);
            this.tidx=reshape(MESH.IDX(2,[1:size(MESH.REL,2);MESH.REL(:,:)]),size(MESH.REL)+[1,0]);
            this.pidx=reshape(MESH.IDX(1,[MESH.REL(1,:);1:size(MESH.REL,2);MESH.REL(4,:);MESH.REL(4,MESH.REL(1,:))]),size(MESH.REL));
       end
   end
end