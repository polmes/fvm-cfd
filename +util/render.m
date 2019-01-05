function render(mesh, t, uvt, write)	
	% render(mesh, t, uvt, write)
	% Creates a movie from the given scalar or vector field through time.
	% If a scalar field is given, the function util.contour() is called.
	% If a vector field is given, the function util.quiver() is called.
	%
	% Parameters:
	%	mesh  - Mesh with wich to call the corresponding plot function.
	%	t     - Time instants at which the field has been stored.
	%	uvt   - Field to plot through time.
	%	write - File type to render. Possible values: 'video', 'gif' or empty.

	% Parameters
	NT = length(t);
	
	% Determine plot type
	sz = size(uvt);
	if sz(1) == 1
		plot = @util.contour;
		scale = [min(min(uvt)) max(max(uvt))];
	elseif sz(1) == 2
		plot = @util.quiver;
		scale = min([mesh.dx mesh.dy]) / max(max(max(abs(uvt))));
	else
		error('Wrong input field variable size.');
	end
	
	% Init
	figure;
	M = struct('cdata', cell(1, NT), 'colormap', cell(1, NT));
		
	% Render
	progress = waitbar(0, 'Rendering...');
	for k = 1:NT
		cla;

		plot(mesh, uvt(:, :, k), false, scale);

		title(['$t=' num2str(t(k), '%.2f') '\,$s'], 'Interpreter', 'latex');
		drawnow;

		M(k) = getframe(gcf);

		waitbar(k / NT);
	end
	close(progress);
	
	% Write
	if nargin == 4
		disp('Saving to disk...');
		
		if strcmp(write, 'video')
			% Filename
			[file, path] = uiputfile({'*.avi', 'AVI Video Files (*.avi)'}, 'Specify filename for video');
			
			if file
				% Setup
				out = [path file]; % /path/to/filename.avi
				pro = 'Motion JPEG AVI'; % video profile
				fps = 60; % video framerate
				qlt = 75; % video quality

				% Init
				vid = VideoWriter(out, pro);
				vid.FrameRate = fps;
				vid.Quality = qlt;				
				
				% Export
				open(vid);
				writeVideo(vid, M);
				close(vid);
				
				disp('Done.');
			else
				disp('No filename for video specified. Bye-bye.');
			end
		elseif strcmp(write, 'gif')
			% Filename
			[file, path] = uiputfile({'*.gif', 'GIF Animation Files (*.gif)'}, 'Specify filename for GIF');
			
			if file
				% Setup
				out = [path file]; % % /path/to/filename.gif
				del = 0.01; % delay between frames
				
				% Loop
				progress = waitbar(0, 'Saving...');
				for k = 1:NT
					im = frame2im(M(k));
					[in, cm] = rgb2ind(im, 256);

					if k  == 1
						imwrite(in, cm, out, 'gif', 'Loopcount', inf, 'DelayTime', del);
					else
						imwrite(in, cm, out, 'gif', 'WriteMode', 'append', 'DelayTime', del);
					end

					waitbar(k / NT);
				end
				close(progress)

				disp('Done.');
			else
				disp('No filename for GIF specified. Bye-bye.');
			end
		else
			error('Unknown write destination specified. Bye-bye.');
		end
	end
	
	% Playback
	disp('Playing back animation...');
	movie(gcf, M, 3);
	disp('Done.');
end
