classdef HorizontalStaggeredVolumes < GenericStaggeredVolumes
    methods
        function this = HorizontalStaggeredVolumes(MESH)
            this.dt=MESH.dy([1:size(MESH.REL,2);MESH.REL([2,1,4,3],:)]);
            this.dp=MESH.dx([MESH.REL(2,:);1:size(MESH.REL,2);MESH.REL(3,:);MESH.REL(3,MESH.REL(2,:))]);
            this.tidx=reshape(MESH.IDX(1,[1:size(MESH.REL,2);MESH.REL([2,1,4,3],:)]),size(MESH.REL)+[1,0]);
            this.pidx=reshape(MESH.IDX(2,[MESH.REL(2,:);1:size(MESH.REL,2);MESH.REL(3,:);MESH.REL(3,MESH.REL(2,:))]),size(MESH.REL));
       end
   end
end