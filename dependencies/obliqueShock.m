function obliqueShock
    gamma = 1.4;
    
    % ask for Mach Number
    mach = input("Mach Number (M1): ");
    choice_OS = input("\nWhat is the known angle?\n" + ...
                      " 1 | β, Wave Angle\n" + ...
                      " 2 | θ, Turn Angle/Weak Shock" + ...
                      "\n\nYour choice: ");
    
    % create table skeleton
    normRowLabels = {'M1'; 'M2'; 'β'; 'μ'; 'θ'; 'p2/p1'; 'ρ2/ρ1'; 'T2/T1'};
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
        Values(6) = oblique_presRatio(mach, beta, gamma);
        Values(7) = oblique_densityRatio(mach, beta, gamma);
        Values(8) = Values(5)*Values(6);

        % Create and output table
        normTable = table(Values, 'RowNames', normRowLabels);
        disp(normTable)
    end
end

%% Oblique Shock Equations

function [M2] = oblique_M2(beta, theta, M1, g)
    % fraction
    numer = 1 + ((g-1)/2)*(M1^2)*sind(beta)^2;
    denom = g*(M1^2)*(sind(beta)^2)-((g-1)/2);
    
    
    M2 = 1/sind(beta-theta)*sqrt(numer/denom);
end

function [pres_ratio] = oblique_presRatio(M1, beta, g)
    pres_ratio = 1 + (2*g/(g+1))*((M1*sind(beta))^2 -1);
end

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

function [theta_max] = thetaMax_TBM(M1, g)
    % this is used to determine theta_max
    % WORK IN PROGRESS
    
    beta = 0
    
    eqn = (atand(2*cotd(beta)*(((M1^2)*(sind(beta)^2)-1)/((M1^2)*(g+cosd(2*beta))+2))))-theta;

    while imag(theta_max) == 0
        theta_max = vpasolve(eqn, [0, 90]);
        
        theta = theta + 0.0001;
    end
    
    theta = theta-0.0001;
    theta_max = vpasolve(eqn, [0, 90]);
end