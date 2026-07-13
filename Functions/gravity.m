function g = gravity(altitude)
g0 = 9.80665; % Gravity (at sea level)
Re = 6371000; % Radius of Earth (in m)
g = g0*(Re/(Re+altitude))^2; % Gravity
end