function [ts, uvt, pt] = explicit(mesh, uv0, rho, nu, T, dt, dti)
	% Check input
	if mod(dti, dt) ~= 0
		dti = dt * floor(dti / dt);
		warning(['dti is not divisible by dt. Switching to dti = ' num2str(dti) ' seconds.']);
	end
	
	% Save every # of iterations
	it = dti / dt; % == NT / NS
	
	% Init time vectors
	t = unique([T(1):dt:T(2) T(2)]);
	NT = length(t);
	ts = unique([T(1):dti:T(2) T(2)]);
	NS = length(ts);
	
	% Init solution vectors
	uvt = zeros(2, mesh.NV, NS);
	pt  = zeros(1, mesh.NV, NS);
	
	% Print start
	disp('Starting simulation');
	disp(['t = ' num2str(t(1)) ' seconds']);
	disp(' ');
	
	% n = 1
	[uvn, pp] = mesh.correction(uv0);
	uvt(:, :, 1) = uvn;
	pt(:, :, 1) = rho / dt * pp;
	
	% do-for
	C = mesh.convective(uvn);
	D = mesh.diffusive(uvn);
	Rprev = (nu * D - C) ./ mesh.vol;
	
	% n > 1
	for k = 2:NT
		% Convective and Diffusive terms
		C = mesh.convective(uvn);
		D = mesh.diffusive(uvn);
		Rn = (nu * D - C) ./ mesh.vol;
		
		% Adams-Bashforth
		uvpred = uvn + dt * (3/2 * Rn - 1/2 * Rprev);
		[uvnext, pp] = mesh.correction(uvpred);
		
		% CFL condition
		CFL = max( dt * (uvnext(1, :) ./ mesh.dx + uvnext(2, :) ./ mesh.dy) );
		
		if any(isnan(uvnext))
			error(['NaN exception at k = ' num2str(k)]);
		end
		
		if mod(t(k), dti) == 0
			% Save values
			uvt(:, :, 1 + (k - 1) / it) = uvnext;
			pt(:, :, 1 + (k - 1) / it) = rho / dt * pp;
			
			% Print
			disp(['Iteration #' num2str(k)]);
			disp(['t = ' num2str(t(k)) ' seconds']);
			disp(['Max CFL = ' num2str(CFL)]);
			disp(' ');
		end
		
		if CFL > 1
			warning(['CFL exceeded 1 at k = ' num2str(k)]);
		end
		
		Rprev = Rn;
		uvn = uvnext;
	end
	
	% Save last value if necessary
	if mod(t(NT), dti) ~= 0
		uvt(:, :, NS) = uvnext;
		pt(:, :, NS) = rho / dt * pp;
	end
	
	% Print end
	disp('Simulation ended');
	disp(['t = ' num2str(t(NT)) ' seconds']);
end
