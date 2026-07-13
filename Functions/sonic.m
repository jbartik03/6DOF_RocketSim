function a = sonic(x, T0)
gamma = 1.4; % Specific heat ratio of air
R = 287;     % Universal gas constant
T = tempModel(x, T0); % Temperature

a = sqrt(gamma*R.*T);
end