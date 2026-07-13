function drag = DragCoefficient(mach,rho,v,D,Lnose,Lt,S,alpha,vert_vel)
%% Constants
% Air viscosity
airVis = 1.8e-5;
% Reynolds number
numR = rho*abs(v)*Lt/airVis;
numR = max(numR,1e5);
%% Skin friction
wetArea = pi * D * Lt;
skinFric = 0.455/(log10(numR)^2.58);
Cd_skinFric = 0.015 * (wetArea/S) * skinFric; % multiply by 1 or 1.1 if Nose doesn't fix
%% Nose pressure drag 
noseFric = Lnose/D;
Cd_noseFric = 0.231/(noseFric^2);                    % closest 0.231
%% Base drag
if mach < 1       
    Cd_b = 0.04; % Subsonic (fighting air), after nose drag, too low (0.04 -> 842862)
else
    Cd_b = 0.03; % Supersonic (in front of air) 0.03
end
%% Wave drag 
if mach < 0.8
    Cd_wave = 0; % Subsonic (no wave)
elseif mach < 1.2
    Cd_wave0 = 0.08 * exp(-((mach - 1)/0.18)^2);
    Cd_wave_alpha = 1.5 * min(abs(alpha),deg2rad(5)) * exp(-((mach - 1)/0.25)^2);
    Cd_wave = Cd_wave0 + Cd_wave_alpha; % Transonic (SONIC BOOM!)
else
    Cd_wave = 0.04 / sqrt(mach); % Supersonic (decreases with mach)
end
%% Angle of attack drag
Mach_factor = 1 + 1.5*exp(-((mach - 1.2)/0.5)^2);
alpha_safe = min(abs(alpha), deg2rad(6)); % Prevent infinite drag here
if vert_vel > 0 % ASCENT (slightly more)
    Cd_alpha = Mach_factor * (0.3*alpha_safe + 0.5*alpha_safe^2);
else  % DESCENT (slightly less)
    Cd_alpha = Mach_factor * (0.1*alpha_safe + 0.2*alpha_safe^2);
end
%% Total drag coefficient
drag = Cd_skinFric + Cd_noseFric + Cd_b + Cd_wave + Cd_alpha;
end