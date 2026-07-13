function CNalpha = CNalpha(M, cr, ct, s, D, Nf)
% Nose Normal Force
CNaNose = 2 * ones(size(M)); % Subsonic
CNaNose(M >= 1) = 2.3;       % Supersonic
% Total Normal Force
CNalpha = CNaNose + CNalphaFins(M, cr, ct, s, D, Nf);
end