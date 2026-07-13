function CenterGravity = xCG(mDry, mf, mf0, dryCG, xFwd, xAft)
    % Fuel tank length
    Lf = xAft - xFwd;
    % Fuel cell's center of gravity position from top/front of cell
    fuelCG = xFwd + 0.5*Lf + 0.5*Lf*(1 - mf./mf0); 
    % Total CG of rocket
    CenterGravity = (mDry * dryCG + mf .* fuelCG) ./ (mDry + mf);
end