# FVM CFD

*Computational Fluid Dynamics (CFD) with the Finite Volume Method (FVM)*

This is our Navier-Stokes spectro-consistent FVM CFD solver for the Master's Aerodynamics course

## Run test scripts

- `mainA.m` to verify convective and diffusive terms
- `mainB.m` to verify pressure correction
- `mainC.m` to verify time integration

## Current limitations

- 2D problems
- Structured mesh
- Periodic boundary conditions

*The code has been tested using the latest MATLAB R2018b on Linux*

## Examples

![Velocity field](gif/velocity_quiver.gif)
![Velocity streamlines](gif/velocity_streamlines_colored.gif)
![Pressure field](gif/pressure_contour.gif)
