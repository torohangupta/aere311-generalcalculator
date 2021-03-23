function isentropic
    gamma = 1.4;
    
    % ask for Mach Number
    mach = input("Mach Number (M1): ");

    % create table skeleton
    isenRowLabels = {'M1'; 'p0/p'; 'ρ0/ρ'; 'T0/T'};
    Values = zeros(length(isenRowLabels), 1);
    
    fprintf('\n\n');
    % populate table
    Values(1) = mach;
    Values(2) = pressureRatio(mach, gamma);
    Values(3) = densityRatio(mach, gamma);
    Values(4) = tempRatio(mach, gamma);

    % Create and output table
    isenTable = table(Values, 'RowNames', isenRowLabels);
    disp(isenTable)
end

%% Isentropic Flow Equations

% base number
function b = base(mach,g)
    b = (((g-1)*mach^2)/2) + 1;
end

% Pressure Ratio Function
function [ratio] = pressureRatio(mach,g)
    exponent = g/(g-1);
    b = base(mach,g);
    ratio = b^exponent;
end

% Temperature Ratio Function
function ratio = tempRatio(mach,g)
    exponent = 1;
    b = base(mach,g);
    ratio = b^exponent;
end

% Density Ratio Function
function ratio = densityRatio(mach,g)
    exponent = 1/(g-1);
    b = base(mach,g);
    ratio = b^exponent;
end

% M_2 Equation
function [M2] = mach_2(M1, g)
    numer = (M1^2)*(g-1)+2;
    denom = 2*g*(M1^2)-(g-1);
    
    M2 = sqrt(numer/denom);
end