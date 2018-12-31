classdef CenteredVolumes < vol.Volumes
	properties
		uvidx; % 4xNV
		% 4 1
		% 3 2
		pidx; % 5xNV
		%   2
		% 5 1 3
		%   4
	end

	methods
		function this = CenteredVolumes(mesh)
			this.pidx = [ 1:mesh.NV ;
			              mesh.rel ];

			this.uvidx = [ 1:mesh.NV      ;
			               1:mesh.NV      ;
			               mesh.rel(3, :) ;
			               mesh.rel(4, :)];
		end

		function p = getPseudoPressure(this, mesh, uv)
			% RHS
			fn = mesh.dx(this.uvidx(1, :)) .* uv(2, this.uvidx(1, :));
			fe = mesh.dy(this.uvidx(2, :)) .* uv(1, this.uvidx(2, :));
			fs = mesh.dx(this.uvidx(3, :)) .* uv(2, this.uvidx(3, :));
			fw = mesh.dy(this.uvidx(4, :)) .* uv(1, this.uvidx(4, :));
			b = (fn + fe - fs - fw).';

			% LHS
			dn = mesh.dx(this.uvidx(1, :)) ./ ( mesh.dy(this.pidx(1, :)) + mesh.dy(this.pidx(2, :)) );
			de = mesh.dy(this.uvidx(2, :)) ./ ( mesh.dx(this.pidx(1, :)) + mesh.dx(this.pidx(3, :)) );
			ds = mesh.dx(this.uvidx(3, :)) ./ ( mesh.dy(this.pidx(1, :)) + mesh.dy(this.pidx(4, :)) );
			dw = mesh.dy(this.uvidx(4, :)) ./ ( mesh.dx(this.pidx(1, :)) + mesh.dx(this.pidx(5, :)) );
			V = 2 * [ -(dn + de + ds + dw); dn; de; ds; dw ];
			I = repmat(this.pidx(1,:), [5 1]);
			J = this.pidx;
			A = sparse(double(I(:)), double(J(:)), V(:));

			% pL = ALL \ (bL - ALR * pR)
			pR = 0;
			pL = A(2:end, 2:end) \ (b(2:end) - A(2:end, 1) * pR);
			p = [pR; pL];
		end

		function [uvcorr, pp] = correction(this, mesh, uv)
			pp = this.getPseudoPressure(mesh, uv);

			ucorr = ( pp(this.pidx(3, :)) - pp(this.pidx(1, :)) ).' ./ mesh.dx;
			vcorr = ( pp(this.pidx(2, :)) - pp(this.pidx(1, :)) ).' ./ mesh.dy;
			uvcorr = uv - [ucorr; vcorr];
		end
	end
end
