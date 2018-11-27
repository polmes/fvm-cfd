
xrange = [0 10];
yrange = [0 10];

xpoints = 10;
ypoints = 10;

GEN = StructuredMeshGenerator(xrange,yrange,xpoints,ypoints);

COOR = GEN.COOR();
CN = GEN.CN();