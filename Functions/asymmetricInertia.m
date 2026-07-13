function [Ix, Iy, Iz] = asymmetricInertia(Lt,L_fuel,m_body,m_f,m_fin,Nf,x_body,x_fuel,x_fins,R,R_fins,x_CG,span,chord)

%{
Lt -> total length
L_fuel -> length of fuel cell
m_body -> dry rocket body mass
m_f -> current fuel mass
m_fin -> mass of 1 fin
Nf -> number of fins
x_body = distance from tip of the nose to CG of body
x_fuel = distance from tip of the nose to CG of fuel cell
x_fins = distance from tip of the nose to CG of fins
R -> body tube radius
R_fins -> fin radius (y centroid + R)
x_CG -> rocket total center of gravity
span -> fin span
chord -> mean aerodynamic chord
%}

% Initial inertias
Ix = 0;
Iy = 0;
Iz = 0;

% Mass offset
m_offset = 100; 
x_offset = -4;
y_offset = 0.43;     
z_offset = -0.01;

% Body (structurally axisymmetric)
dx = x_body - x_CG;
IxxBodyLocal = 0.5 * m_body * R^2;
IyyBodyLocal = (1/12) * m_body * (3*R^2 + Lt^2);
IzzBodyLocal = IyyBodyLocal;

Ix = Ix + IxxBodyLocal;
Iy = Iy + IyyBodyLocal + m_body * dx^2;
Iz = Iz + IzzBodyLocal + m_body * dx^2;

% Fuel (centered on axis x^B)
dx = x_fuel - x_CG;
IxxFuelLocal = 0.5 * m_f * R^2;
IyyFuelLocal = (1/12) * m_f * (3*R^2 + L_fuel^2);
IzzFuelLocal = IyyFuelLocal;

Ix = Ix + IxxFuelLocal;
Iy = Iy + IyyFuelLocal + m_f * dx^2;
Iz = Iz + IzzFuelLocal + m_f * dx^2;

% Fins
for i = 1:Nf
    angle = 2*pi*(i-1)/Nf;
    y = R_fins * cos(angle);
    z = R_fins * sin(angle);

    dx = x_fins - x_CG;

    IxxFinLocal = (1/12) * m_fin * (span^2 + chord^2);
    IyyFinLocal = (1/12) * m_fin * (span^2 + chord^2);
    IzzFinLocal = IyyFinLocal;

    Ix = Ix + IxxFinLocal + m_fin*(y^2 + z^2);
    Iy = Iy + IyyFinLocal + m_fin*(dx^2 + z^2);
    Iz = Iz + IzzFinLocal + m_fin*(dx^2 + y^2);
end

% Consider asymmetric mass distribution
Ix = Ix + m_offset*(y_offset^2 + z_offset^2);
Iy = Iy + m_offset*(x_offset^2 + z_offset^2);
Iz = Iz + m_offset*(x_offset^2 + y_offset^2);

end