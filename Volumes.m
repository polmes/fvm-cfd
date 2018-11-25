classdef Volumes < handle
	properties
		% Indeces in matrix
		nodes; % 4 x NV
	end
	
	methods
		% Constructor
		function obj = Volumes(ind)
			obj.nodes = ind;
		end
% 		function [Sx, Sy] = getSurfaces()
% 			global U V P NODES;
% 		end
	end
end
