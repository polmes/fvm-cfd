function [uvf, pf] = analytical(rho, nu)
	% [uvf, pf, uva, pa] = util.analytical(rho, nu)
	% Gets an analytical solution for the Navier-Stokes equations
	% from the method of manufactured solutions
	%
	% Parameters:
	%	rho - Fluid density [kg/m^3]
	%	nu	- Fluid kinematic viscosity [m^2/s]
	%
	% Return values:
	%	uvf - Function for the velocity field: uv(t, x, y)
	%	pf  - Function for the pressure field: p(t, x, y)
	
	syms x y t;
	
	F = exp(-8 * pi^2 * nu * t);
	uva = F * [ cos(2 * pi * x) * sin(2 * pi * y) ; 
			   -cos(2 * pi * y) * sin(2 * pi * x) ];
	pa = -F^2 * rho * (cos(4 * pi * x) + cos(4 * pi * y)) / 4;
	
	uvf = matlabFunction(uva);
	pf = matlabFunction(pa);
end
