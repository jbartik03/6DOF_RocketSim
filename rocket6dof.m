function dx = rocket6dof(t,six, thrustTime, thrustForce, specs)

%{
Jonathan A. Bartik
4/22/2026
Full 6DOF Rocket Simulator
%}

%% STATES
% Trajectory   % Stability                % Fuel
x   = six(1);  p              = six(8);   r   = six(12);
v_x = six(2);  pitch_attitude = six(9);   m_f = six(13);
v_y = six(4);  q              = six(10);
v_z = six(6);  yaw_attitude   = six(11);

%% Parameters
% Body Measurements
D = specs.D;         % Diameter in meters
R = D/2;          % Radius in meters
S = pi*((D/2)^2); % Reference area in meters squared
Lnose = specs.Lnose;     % Nose length in meters squared
Lt = specs.Lt;        % Total length of rocket in meters

% Fin Measurements
finPos = specs.finPos;  % Start of fin chord, measured aft of nose in meters
cr = specs.cr;       % root chord in meters
ct = specs.ct;        % tip chord in meters
s  = specs.s;        % fin span in meters
Nf = specs.Nf;           % number of fins, unitless
x_fins = specs.x_fins;   % Fin position, center of chord

% Mass Parameters
m_body = specs.m_body;     % Body mass (tube + nose + avionics) in kg
m_fin = specs.m_fin;       % Mass of one fin in kg
m_dry = m_body + (Nf * m_fin); % Dry rocket mass in kg
m_f0 = specs.m_f0;   % Starting fuel mass in kg
Isp = specs.Isp;        % Specific impulse of BBVC motor in seconds
dryCG = specs.dryCG;    % Dry center of gravity, measured aft of nose in meters
xAft = specs.xAft;     % Rear position of fuel cell in meters (from nose)
xFwd = specs.xFwd;     % Front position of fuel cell in meters (from nose)
L_fuel = xFwd - xAft; % Fuel cell length

%% FORMULAS
% Independent
g = gravity(x);                                % Gravity
T = interp1(thrustTime, thrustForce, t, 'linear', 0); % Thrust interpolant
m = m_dry + m_f;                                % Mass
a = sonic(x, 75);                              % Speed of sound
v = sqrt(v_y^2 + v_x^2 + v_z^2);         % Velocity
v_safe = max(v,1e-3);                                 % Prevent divide by 0
mach = abs(v)/a;                                      % Mach number
rho = airDensity(x);                  % Air Density
qbar = 0.5 * rho * v_safe^2;            % Dynamic Pressure

% Angles
rotation = specs.flight_angle;
chi = atan2(v_z,v_y);
gamma = atan2(v_x, sqrt(v_y^2 + v_z^2)); % Flight path angle (3D)
alpha = wrapToPi(pitch_attitude-gamma);       % Angle of attack
beta   = wrapToPi(yaw_attitude-chi);              % Sideslip angle
alpha_tot = sqrt(alpha^2 + beta^2); % Total AoA (for drag)

delta = deg2rad(specs.fin_cant_angle); % Fin cant angle


y_centroid = (s/3) * ((cr+2*ct)/(cr+ct)); % Fin center of area
R_fins = R + y_centroid; % Fin radius
CenterP = xCP(Lnose, finPos, mach, cr, ct, s, D, Nf);     % CP in meters
CenterG = xCG(m_dry, m_f, m_f0, dryCG, xFwd, xAft); % CG in meters
ell = CenterP - CenterG;                   % Reference length
SM = (CenterP - CenterG) / D;    % Static Margin
cnalpha = CNalpha(mach, cr, ct, s, D, Nf); % Normal Force Derivative

cmalpha = -SM * cnalpha;         % Stability Derivative
cmq = -2 * SM * cnalpha;         % Damping Derivative

CNaf = CNalphaFins(mach, cr, ct, s, D, Nf) / Nf; % per fin
cldelta = (Nf * CNaf * R_fins) / (S * D);
clp = -3 * (Nf * CNaf / S) * (R_fins / D)^2;

v_damp = v_safe;                  % Prevent divide by 0
Cm_roll = cldelta * delta ...
        + clp * (p * D / (2*v_damp));
Cm_pitch = (cmalpha * alpha) - (cmq * ( ...
    q * ell / (2*v_damp)));     % Pitching moment coefficient
Cm_yaw = cmalpha * beta + cmq * ( ...
    r * ell / (2*v_damp));     % Pitching moment coefficient
dragCoefficient = DragCoefficient(mach, rho, v, D, ...
    Lnose, Lt, S, alpha_tot, v_x);  % Drag coefficient
DragForce = qbar * dragCoefficient * S;

ux = v_x / v_safe;
uy = v_y / v_safe;
uz = v_z / v_safe;
Fx_drag = -DragForce * ux;
Fy_drag = -DragForce * uy;
Fz_drag = -DragForce * uz;

% Inertia
chord = (2/3) * (cr + ct - (cr*ct)/(cr + ct)); % Mean aerodynamic chord
if m_f > 1e-6
    x_fuel = ((m_body + m_f)*CenterG - m_body*dryCG)/m_f;
else
    x_fuel = xAft;
end
[Ix, Iy, Iz] = asymmetricInertia(Lt,L_fuel,m_body,m_f,m_fin,Nf,dryCG, ...
    x_fuel,x_fins,R,R_fins,CenterG,s,chord);

L = (qbar * S * D) * Cm_roll;
M = (qbar * S * ell) * Cm_pitch;
N = (qbar * S * ell) * Cm_yaw;

% Torque consideration due to gravity
pitch_turn = 0;
if rotation <= 12
    val = (0.000706667*(rotation^3)) - ...
    (0.0186*(rotation^2)) + (0.117333*(rotation)) + 1;
else
    val = -0.025*rotation + 1.31333;
end
if x < 15000 && m_f > 0 % Powered torquing condition
    pitch_turn = deg2rad(max(rotation-1, 0.002)) * (val - x/15000);
end
yaw_turn = 0;

%% STATE EQUATIONS
% Rail condition: freeze attitudes for first 6m (20ft) of flight
rail_factor = 1 / (1 + exp(-15*(x - 6)));

% States
dx = zeros(13,1);
dx(1) = v_x;                     % Vertical Velocity
dx(2) = (T*sin(pitch_attitude)*cos(yaw_attitude))/m - g...
    + Fx_drag/m;                        % Vertical Acceleration
dx(3) = v_y;                    % Horizontal Velocity
dx(4) = (T*cos(pitch_attitude)*cos(yaw_attitude))/m + ...    
    Fy_drag/m;                         % Horizontal Acceleration
dx(5) = v_z;                    % Horizontal Velocity
dx(6) = (T*cos(pitch_attitude)*sin(yaw_attitude))/m + ...    
    Fz_drag/m;                         % Horizontal Acceleration
dx(7) = p;
dx(8) = rail_factor * ((L - (Iz - Iy)*q*r) / Ix);
dx(9) = q;
dx(10) = rail_factor * (((M - (Ix - Iz)*p*r) / Iy) - pitch_turn);
dx(11) = r;
dx(12) = rail_factor * (((N - (Iy - Ix)*p*q) / Iz) - yaw_turn);
if m_f <= 0
    dx(13) = 0;                             % Coasting (no fuel to burn)
else
    dx(13) = -T/(9.80665*Isp);              % Fuel burn rate
end
end