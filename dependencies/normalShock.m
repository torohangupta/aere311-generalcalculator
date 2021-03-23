function normalShock
    gamma = 1.4; 
    
    % ask for Mach Number
    mach = input("Mach Number (M1): ");

    % create table skeleton
    normRowLabels = {'M1'; 'M2'; 'p2/p1'; 'ρ2/ρ1'; 'T2/T1'; 'p02/p01'};
    Values = zeros(length(normRowLabels), 1);
    
    fprintf('\n\n');
    % populate table
    Values(1) = mach;
    Values(2) = mach_2(mach, gamma);
    Values(3) = norm_pres(mach, gamma);
    Values(4) = norm_density(mach, gamma);
    Values(5) = norm_temp(mach, gamma);
    Values(6) = norm_stagPres(mach, gamma);

    % Create and output table
    output_table(Values, normRowLabels);
end

%% Normal Shock Equations

% Normal Shock Pressure Ratio
function [r_Np] = norm_pres(M1, g)
    r_Np = 1 + (2*g/(g+1))*(M1^2-1);
end

% Normal Shock Density Ratio
function [r_Nrho] = norm_density(M1, g)
    r_Nrho = ((g+1)*M1^2)/(2+(g-1)*M1^2);
end

% Normal Temprature Pressure Ratio
function [r_Nt] = norm_temp(M1, g)
    r_Nt = norm_pres(M1, g)*((2+(g-1)*M1^2)/((g+1)*M1^2));
end

% Normal Stagnation Pressure Ratio
function [r_Nsp] = norm_stagPres(M1, g)
    % exponents
    e1 = g/(g-1);
    e2 = 1/(g-1);
    
    % first term
    n1 = ((g+1)/2)*M1^2;
    d1 = 1 + ((g-1)/2)*M1^2;
    
    % second term
    d2 = (2*g/(g+1))*M1^2 - (g-1)/(g+1);
    
    % equations
    r_Nsp = ((n1/d1)^e1)*((1/d2)^e2);
end