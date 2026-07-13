function rho = airDensity(h)
    rho0 = 1.225;
    H = 8500; % meters
    rho = rho0 * exp(-h/H);
end