# FVM CFD
*Computational Fluid Dynamics (CFD) with the Finite Volume Method (FVM)*

This is our Navier-Stokes spectro-consistent FVM CFD solver for the Master's Aerodynamics course

## Current limitations

- 2D problems
- Structured mesh
- Periodic boundary conditions

## How to test scripts

- `mainA.m` verifies convective and diffusive terms
- `mainB.m` verifies pressure correction method
- `mainC.m` verifies time integration algorithm

*The code has been tested using the latest MATLAB R2018b on Linux*
