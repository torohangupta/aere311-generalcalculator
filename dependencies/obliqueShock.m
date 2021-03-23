function obliqueShock
    gamma = 1.4;
    
    % ask for Mach Number
    mach = input("Mach Number (M1): ");
    choice_OS = input("\nWhat is the known angle?\n" + ...
                      " 1 | β, Wave Angle\n" + ...
                      " 2 | θ, Turn Angle/Weak Shock" + ...
                      "\n\nYour choice: ");
    
    % create table skeleton
    normRowLabels = {'M1'; 'M2'; 'β'; 'μ'; 'θ'; 'θ_max'; 'p2/p1'; 'ρ2/ρ1'; 'T2/T1'};
    Values = zeros(length(normRowLabels), 1);
    
    switch choice_OS
        case 1
            beta = input("Please enter your Wave Angle, β: ");
            theta = theta_TBM(mach, beta, gamma);
        case 2
            theta = input("Please enter your Turn Angle/Weak Shock, θ: ");
            beta = beta_TBM(mach, theta, gamma);
        otherwise
            disp("That is an invalid selection.");
    end
    
    
    
    if choice_OS == 1 || choice_OS == 2
        fprintf('\n\n');
        % populate table
        Values(1) = mach;
        Values(2) = oblique_M2(beta, theta, mach, gamma);
        Values(3) = beta;
        Values(4) = asind(1/mach);
        Values(5) = theta;
        Values(6) = oblique_thetaMax(mach, double(beta_TBM(mach, 0, gamma)), gamma);
        Values(7) = oblique_presRatio(mach, beta, gamma);
        Values(8) = oblique_densityRatio(mach, beta, gamma);
        Values(9) = oblique_presRatio(mach, beta, gamma)*oblique_densityRatio(mach, beta, gamma);

        % Create and output table
        output_table(Values, normRowLabels);
    end
end

%% Oblique Shock Equations

function [M2] = oblique_M2(beta, theta, M1, g)
    % fraction
    numer = 1 + ((g-1)/2)*(M1^2)*sind(beta)^2;
    denom = g*(M1^2)*(sind(beta)^2)-((g-1)/2);
    
    
    M2 = 1/sind(beta-theta)*sqrt(numer/denom);
end

% pressure ratio
function [pres_ratio] = oblique_presRatio(M1, beta, g)
    pres_ratio = 1 + (2*g/(g+1))*((M1*sind(beta))^2 -1);
end

% density ratio
function [density_ratio] = oblique_densityRatio(M1, beta, g)
    % fraction parts
    numer = (g+1)*(M1^2)*(sind(beta)^2);
    denom = (g-1)*(M1^2)*(sind(beta)^2) + 2;
    
    density_ratio = numer/denom;
end

% theta-beta-M equation (Theta), theta unknown
function [theta] = theta_TBM(M1, beta, g)
    % fraction parts
    numer = (M1^2)*(sind(beta)^2)-1;
    denom = (M1^2)*(g+cosd(2*beta))+2;
    
    theta = atand(2*cotd(beta)*(numer/denom));
end

% theta-beta-M equation (Beta), beta unknown
function [sol_beta] = beta_TBM(M1, theta, g)
    syms unknown_beta
    eqn = (atand(2*cotd(unknown_beta)*(((M1^2)*(sind(unknown_beta)^2)-1)/((M1^2)*(g+cosd(2*unknown_beta))+2))))-theta;
    
    sol_beta = vpasolve(eqn, [0, 90]);
end

% this is used to numerically determine theta_max
function [theta_max] = oblique_thetaMax(M1, minBeta, g)
    betaArray = floor(minBeta):.05:90;
    thetaArray = zeros([1, length(betaArray)]);    

    for i = 1:length(betaArray)
        thetaArray(i) = atand(2*cotd(betaArray(i))*(((M1^2)*(sind(betaArray(i))^2)-1)/((M1^2)*(g+cosd(2*betaArray(i)))+2)));
    end

    theta_max = max(thetaArray);
end
