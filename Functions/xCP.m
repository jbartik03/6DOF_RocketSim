function CenterPressure = xCP(noseLength, finPos, M, cr, ct, s, D, Nf) 
    % Nose CP
    cpNose = (2/3) * noseLength;
    % Mean Aerodynamic Chord (2nd Order Fomula)
    cbar = (2/3) * (cr + ct - (cr*ct)/(cr + ct)); 
    cpFins = finPos ...
    + (cr + 2*ct)/(3*(cr + ct)) * cbar ...
    + (1/6)*(cr + ct - (cr*ct)/(cr + ct));
    % Nose normal force
    CNaNose = 2.25 ...                                 % Subsonic
          + 0.4 * (0.5 * (1 + tanh((M - 1)/0.15))) ... % transonic
          + 0.6  * (0.5 * (1 + tanh((M - 4)/2)));      % supersonic
    % Fin normal force
    CNaFins = CNalphaFins(M, cr, ct, s, D, Nf); 
    % Total normal force
    CNa = CNaNose + CNaFins;
    % Calculate center of pressure
    CenterPressure = (cpNose .* CNaNose + cpFins .* CNaFins) ./ CNa;
end