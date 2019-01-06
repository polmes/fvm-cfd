function streamcolor(x, y, u, v, sx, sy, M, options, scale)
	cmap = colormap;
	
	if nargin < 8
		options = [];
	end
	
	verts = stream2(x, y, u, v, sx, sy, options);
	if nargin < 9 || isempty(scale)
		scale = [min(M(:)) max(M(:))];
	end
	
	for k = 1:length(verts)
		vv = verts{k};
		
		X = vv(:, 1);
		Y = vv(:, 2);
		
		Mcol = uint8(floor( (interp2(x, y, M, X, Y) - scale(1)) / (scale(2) - scale(1)) * size(cmap, 1) ));
		Mcol(Mcol == 0) = 1;
		
		for j = 2:size(vv, 1)
			h = line('XData', [X(j-1) X(j)], 'YData', [Y(j-1) Y(j)], ...
				'Color', [cmap(Mcol(j), 1) cmap(Mcol(j), 2) cmap(Mcol(j), 3)]);
			
			set(hggetbehavior(h, 'DataCursor'), 'Enable', false);
			setinteractionhint(h, 'DataCursor', false);
			set(hggetbehavior(h, 'Brush'), 'Enable', false);
			setinteractionhint(h, 'Brush', false);
		end
	end	
end
