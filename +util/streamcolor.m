function streamcolor(x, y, u, v, sx, sy, M, options, scale)
	% util.streamcolor(x, y, u, v, sx, sy, M, options, scale)
	% Plots a colored streamline for a 2D vector field.
	%
	% Parameters:
	%	x, y	- Meshgrid-like positions. 
	%	u, v	- Vector field matrix to plot.
	%	sx, sy	- Starting points of the steamlines.
	%	M		- Scalar matrix to color the streamline.
	%	options	- Array with [step size, max # of vertices].
	%	scale	- Array with [min max] values for the color scale.
	
	% Init defaults
	if nargin < 8
		options = [];
	end
	if nargin < 9 || isempty(scale)
		scale = [min(M(:)) max(M(:))];
	end
	
	% Create vertices
	verts = stream2(x, y, u, v, sx, sy, options);
	
	% Create colormap 
	cmap = colormap;
	
	% Loop foreach line
	for k = 1:length(verts)
		vv = verts{k};
		
		% Positions for this line
		X = vv(:, 1);
		Y = vv(:, 2);
		
		% Scale color values
		Mcol = uint8(floor( (interp2(x, y, M, X, Y) - scale(1)) / (scale(2) - scale(1)) * size(cmap, 1) ));
		Mcol(Mcol == 0) = 1;
		
		% Loop foreach colored segment
		for j = 2:size(vv, 1)
			% Plot line segment
			h = line('XData', [X(j-1) X(j)], 'YData', [Y(j-1) Y(j)], ...
				'Color', [cmap(Mcol(j), 1) cmap(Mcol(j), 2) cmap(Mcol(j), 3)]);
			
			% Disable MATLAB data tips
			set(hggetbehavior(h, 'DataCursor'), 'Enable', false);
			setinteractionhint(h, 'DataCursor', false);
			set(hggetbehavior(h, 'Brush'), 'Enable', false);
			setinteractionhint(h, 'Brush', false);
		end
	end	
end
