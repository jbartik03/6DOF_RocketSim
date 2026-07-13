function T = tempModel(x, T0)

    T = zeros(size(x));
    T0 = ((5*(T0 - 32))/9) + 273.15;
    % Piecewise model from 0km to 700km, plenty of altitude for sounding
    % rockets!
    for i = 1:length(x)
        % Troposphere: 0 to 11km
        if x(i) <= 11000
            T(i) = (((216.65 - T0)/11000)*x(i)) + T0;
        % Tropopause: 11 to 20km
        elseif x(i) <= 20000
            T(i) = 216.65;
        % Stratosphere: 20 to 50km
        elseif x(i) <= 50000
            T(i) = ((53.35/30000)*x(i)) + 181.08;
        % Stratopause: 50 to 53km
        elseif x(i) <= 53000
            T(i) = 270.65;
        % Mesosphere: 53 to 86km
        elseif x(i) <= 86000
            T(i) = (-(97/33000)*x(i)) + (270 - ((-97/33000)*53000));
        % Thermosphere: 86 to 600km (scope of this model)
        else
            T(i) = 173 + (827*(1-exp(-(x(i) - 86000)/198500)));
        end
    end
end
