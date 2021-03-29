function isentropic
    gamma = 1.4;
    
    % ask for Mach Number
    mach = input("Mach Number (M1): ");

    % create table skeleton
    isenRowLabels = {'M1'; 'p0/p'; 'ρ0/ρ'; 'T0/T'; 'p*/p0'; 'ρ*/ρ0'; 'T*/T0'; 'A/A*'};
    Values = zeros(length(isenRowLabels), 1);
    
    fprintf('\n\n');
    % populate table
    Values(1) = mach;
    Values(2) = pressureRatio(mach, gamma);
    Values(3) = densityRatio(mach, gamma);
    Values(4) = tempRatio(mach, gamma);
    Values(5) = isen_sonic_pres(gamma);
    Values(6) = isen_sonic_dens(gamma);
    Values(7) = isen_sonic_temp(gamma);
    Values(8) = isen_areaMach(mach, gamma);

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


%% Isentropic Flow Equations at Sonic Conditions

% Pressure Ratio Function
function [ratio] = isen_sonic_temp(g)
    ratio = 2/(g+1);
end

% Temperature Ratio Function
function ratio = isen_sonic_pres(g)
    ratio = (2/(g+1))^(g/(g-1));
end

% Density Ratio Function
function ratio = isen_sonic_dens(g)
    ratio = (2/(g+1))^(1/(g-1));
end

% Isentropic Area-Mach Relation
function ratio = isen_areaMach(mach, g)
    ratio = (1/mach)*((2+(g-1)*(mach^2))/(g+1))^((g+1)/(2*(g-1)));
end