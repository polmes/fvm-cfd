classdef CenteredVolumes < vol.Volumes
	% vol.CenteredVolumes
	% Represents the non-staggered pressure volumes.
	% This class has the main purpose of calculating the corrected velocity 
	% field through the pressure gradient from a given velocity field.
	% This is done through the function [uvcorr, pp] = correction(this, mesh, uv),
	% which returns the corrected velocity field uvcorr and the pressure field pp.
	%
	% vol.CenteredVolumes methods:
	%	CenteredVolumes(msh.Mesh) - Constructs the CenteredVolumes object from a given mesh
	%	getPseudoPressure(msh.Mesh, uv) - Returns the solution to the laplace equation laplacian(p)=div(uv)
	%	correction(msh.Mesh, uv) - Returns the gradient of the solution to the laplace equation.
	%
	% vol.CenteredVolumes properties:
	%	uvidx - Indices of the surrounding velocities
	%	pidx  - Indices of the surrounding pressures

	properties
		% Indices of the surrounding velocities
		% +-1-+
		% 4   2
		% +-3-+
		uvidx;

		% Indices of the surrounding pressures
		%+---+---+---+
		%|   | 2 |   |
		%+---+---+---+
		%| 5 | 1 | 3 |
		%+---+---+---+
		%|   | 4 |   |
		%+---+---+---+
		pidx;
	end

	methods
		function this = CenteredVolumes(mesh)
			% Constructs the CenteredVolumes object, whose main purpose is
			% calculate the pseudo-pressure gradient for a given velocity field.
			this.pidx = [ 1:mesh.NV ;
			              mesh.rel ];

			this.uvidx = [ 1:mesh.NV      ;
			               1:mesh.NV      ;
			               mesh.rel(3, :) ;
			               mesh.rel(4, :)];
		end

		function [p, b] = getPseudoPressure(this, mesh, uv)
			% Returns the solution to the laplace equation laplacian(pp)=div(uv)
			% for a given uv. The field pp will be relative to the first element,
			% which is always set to 0.
			% Also returns b, which represents the divergence at each volume.
			
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
			% Returns the gradient of the solution to the laplace equation
			% and the pseudo-pressure field. Subtracting this from the
			% velocity field gives a divergence-free field.
			pp = this.getPseudoPressure(mesh, uv);

			ucorr = ( pp(this.pidx(3, :)) - pp(this.pidx(1, :)) ).' ./ mesh.dx;
			vcorr = ( pp(this.pidx(2, :)) - pp(this.pidx(1, :)) ).' ./ mesh.dy;
			uvcorr = uv - [ucorr; vcorr];
		end
	end
end
