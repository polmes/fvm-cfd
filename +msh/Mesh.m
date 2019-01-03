classdef Mesh < handle
	% msh.Mesh
	% Represents the base class from which all mesh objects must derive from.
	%
	% msh.Mesh properties:
	%	coor - Coordinates of all the vertices of the centered volumes in the mesh.
	%	cn   - Matrix which assigns each volume its vertex coordinates.
	%	rel  - Matrix which relates each volume with its neighbors.
	%	NV   - Total number of volumes in the mesh.
	%	vol  - Size of each volume

	properties
		coor; % Coordinates of all the vertices of the centered volumes in the mesh.
		cn;   % Matrix which assigns each volume its vertex coordinates.
		rel;  % Matrix which relates each volume with its neighbors.
		NV;   % Total number of volumes in the mesh.
		vol;  % Size of each volume
	end
end
