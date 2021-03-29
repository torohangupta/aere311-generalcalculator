function isentropic
    gamma = 1.4;
    
    % ask for Mach Number
    mach = input("Mach Number (M1): ");

    % create table skeleton
    isenRowLabels = {'M1'; 'p0/p'; 'ρ0/ρ'; 'T0/T'; 'A/A*'};
    Values = zeros(length(isenRowLabels), 1);
    
    fprintf('\n\n');
    % populate table
    Values(1) = mach;
    Values(2) = pressureRatio(mach, gamma);
    Values(3) = densityRatio(mach, gamma);
    Values(4) = tempRatio(mach, gamma);
    Values(5) = isen_areaMach(mach, gamma);

    % Create and output table
    output_table(Values, isenRowLabels);
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

% Isentropic Area-Mach Relation
function ratio = isen_areaMach(mach, g)
    ratio = (1/mach)*((2+(g-1)*(mach^2))/(g+1))^((g+1)/(2*(g-1)));
end