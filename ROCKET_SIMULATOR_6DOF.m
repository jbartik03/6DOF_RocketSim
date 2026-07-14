% =========================================================================
% 6DOF Rocket Flight Dynamics Simulator
%
% Author: Jonathan A. Bartik
% Created: April 2026
%
% Copyright (c) 2026 Jonathan A. Bartik
% All Rights Reserved
% =========================================================================

clear
close all

% Read Thrust Data from CSV file
thrustData = readtable("BBVC.csv");
thrustTime = thrustData.time;
thrustForce = thrustData.thrust;

% Read Initial Conditions and Parameters from CSV file
specs = readtable("BlackBrantVCParameters.csv");
flightAngles = [0, 2, 4, 6, 8, 10, 12, 14]; % Adjust Launch Angles Here
fin_cant_angle = specs.fin_cant_angle;
initial_yaw = 0;
timespan = [0 440];
options = odeset('Events', @groundEvent);
timerTotal = 0;

% Loop Integration
for k = 1:length(flightAngles)
    angle = flightAngles(k);
    initial_pitch = pi/2 - deg2rad(angle);
    v0 = 1;
    x0 = [0, v0*sin(initial_pitch)*cos(initial_yaw),... % Altitude
        0, v0*cos(initial_pitch)*cos(initial_yaw),...   % Distance
        0, v0*cos(initial_pitch)*sin(initial_yaw),...   % Sidewalk
        0, 0,...              % Roll
        initial_pitch, 0,...  % Pitch
        initial_yaw, 0,...    % Yaw
        specs.m_f0];          % Fuel mass
    
    tic;

    [t,x] = ode15s(@(t,x) rocket6dof(t,x,thrustTime, thrustForce,...
    specs),timespan,x0,options);

    endTimer = toc;
    timerTotal = timerTotal + endTimer;

    disp("Sim " + k + " took " + endTimer + " seconds.");

    % Trajectory
    results(k).angle = angle;
    results(k).time  = t;
    results(k).altitude   = x(:,1);
    results(k).v_x = x(:,2);
    results(k).distance  = x(:,3);
    results(k).v_y = x(:,4);
    results(k).sidewalk  = x(:,5);
    results(k).v_z = x(:,6);
    
    % Stability
    results(k).roll = x(:,7);
    results(k).rollRate = x(:,8);
    results(k).pitch = x(:,9);
    results(k).pitchRate = x(:,10);
    results(k).yaw = x(:,11);
    results(k).yawRate = x(:,12);
    
    % Fuel
    results(k).fuel_mass = x(:,13);
    
    % Other
    results(k).velocity = sqrt(results(k).v_x.^2 + results(k).v_y.^2 + results(k).v_z.^2);
    results(k).gamma = atan2(results(k).v_x, results(k).v_y);
    results(k).chi = atan2(results(k).v_z, results(k).v_y);
    results(k).alpha = results(k).pitch - results(k).gamma;
    results(k).mach = abs(results(k).velocity) ./ sonic(results(k).altitude, 75);
end

disp("Total runtimme: " + timerTotal + " seconds.");
plot6DOFresults(results,k,timespan);