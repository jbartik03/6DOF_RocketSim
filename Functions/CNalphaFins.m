function CNalphaFinsTotal = CNalphaFins(M, cr, ct, s, D, Nf)
%% Rogers Modified Barrowman Method
% Mean Aerodynamic Chord
cbar = (2/3) * (cr + ct - (cr*ct)/(cr + ct));
% Subsonic normal force
CNalphaSub_fin = 1.4 * (4*Nf*(s/D)^2) ./ (1 + sqrt(1 + (2*s/cbar)^2));
% Supersonic normal force
beta = sqrt(max(M.^2 - 1, 0.05));
CNalphaSup_base = (4.6 * Nf * (s/D)^2) ./ (1 + 0.35*beta);
S = 1 - 0.10 * exp(-((M - 1)/0.35).^2);
CNalphaSup_fin = CNalphaSup_base .* S;
% Subsonic - supersonic transition at mach 1
W = 0.5 * (1 + tanh((M - 1)/.15));
% Fin Normal Force
CNalphaFinsTotal = (1 - W).*CNalphaSub_fin + W.*CNalphaSup_fin;
end