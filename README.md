# 6DOF Rocket Flight Dynamics Simulator
## Overview
  This repository contains a high-fidelity six-degree-of-freedom (6DOF) rocket flight dynamics simulator developed as part of undergraduate aerospace modeling and simulation research at the University of North Florida. The simulator was developed to evaluate the trajectory, attitude dynamics, and stability characteristics of the Black Brant VC sounding rocket using a custom mathematical framework consisting of twelve coupled nonlinear differential equations. The model captures both translational and rotational motion throughout powered and unpowered flight and serves as the foundation for the research manuscript *A Mathematical Model for 6DOF Rocket Dynamics*, currently under review for publication.

## Features
* Full six-degree-of-freedom rigid-body flight dynamics simulation.
* Coupled translational and rotational motion modeling.
* Dynamic aerodynamic coefficient calculations throughout flight.
* Time-varying mass and center-of-gravity tracking during propellant consumption.
* Center-of-pressure calculations and stability monitoring.
* Atmospheric modeling including changes in air density, gravity, and temperature with altitude.
* User-configurable launch conditions including launch angle, wind conditions, and fin cant angle.
* Roll, pitch, and yaw attitude propagation.
* Modular plotting and post-processing utilities for custom result visualization.

## Technical Topics
* Aerospace Modeling & Simulation
* Flight Dynamics
* Rocket Stability Analysis
* Trajectory Analysis
* Mathematical Modeling
* Nonlinear Differential Equations
* Numerical Integration
* Rigid-Body Dynamics
* Aerodynamics
* Scientific Computing
* Verification & Validation
* MATLAB Simulation

## Model Assumptions
* The vehicle is modeled as a rigid body.
* Structural flexibility and aeroelastic effects are neglected.
* Propellant slosh effects are not modeled.
* Aerodynamic forces and moments are determined using established analytical methods and vehicle geometry.
* Atmospheric properties vary with altitude.

## Inputs
Vehicle and mission parameters are specified through the `BlackBrantVCParameters.csv` configuration file.
Configurable parameters include:
* Initial launch angle
* Fin cant angle
* Vehicle diameter
* Nose length
* Total vehicle length
* Fin root chord
* Fin tip chord
* Fin span
* Fin position
* Dry mass
* Fin mass
* Initial propellant mass
* Specific impulse
* Dry center of gravity location
* Forward and aft propellant locations

## Outputs
Trajectory Results
* Altitude (m)
* Downrange distance (m)
* Crossrange distance (m)
* Vertical velocity (m/s)
* Horizontal velocity (m/s)
* Lateral velocity (m/s)
* Total velocity (m/s)

Stability and Attitude Results
* Roll angle (rad)
* Pitch angle (rad)
* Yaw angle (rad)
* Roll rate (rad/s)
* Pitch rate (rad/s)
* Yaw rate (rad/s)

Additional Flight Parameters
* Flight path angle
* Horizontal azimuth
* Angle of attack
* Dynamic pressure
* Remaining propellant mass
* Mach number

## Validation
Simulation outputs were compared against RASAeroII trajectory and aerodynamic predictions to verify model behavior and ensure consistency with established aerospace analysis tools.

## Repository Structure

```
Functions/
    Supporting MATLAB functions and dynamics routines

Results/
    Example simulation output plots

BlackBrantVCParameters.csv
    Vehicle and mission configuration inputs

ROCKET_SIMULATOR_6DOF.m
    Primary simulation execution file

plot6DOFresults.m
    Supporting MATLAB function for simulation results

rocket6dof.m
    Primary function for integration of ODE system
```

## Example Results
Representative simulation outputs are provided in the `Results` directory. These include trajectory, velocity, attitude, stability, and aerodynamic performance plots generated during Black Brant VC flight simulations.

## Author
Jonathan A. Bartik

B.S. Applied Mathematics, Computing Minor
University of North Florida

Created: April 22, 2026
