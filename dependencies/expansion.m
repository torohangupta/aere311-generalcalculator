function expansion
gamma = 1.4;

choice_ex = input("What do you want to calculate?\n" + ...
         " 1 | θ\n" + ...
         " 2 | M1\n" + ...
         " 3 | M2\n\n" + ...
         " 0 | Exit Program\n\n" + ...
         "Your choice: ");
     
% create table skeleton
    exRowLabels = {'M1'; 'M2'; 'θ'; 'v(M2)'; 'v(M1)';'μ1';'μ2';'RML'};
    Values = zeros(length(exRowLabels), 1);

% function selector
clc
switch choice_ex
    case 1 % finding θ
        M1 = input("Enter M_1: ");
        M2 = input("Enter M_2: ");
        v_M1 = v_M(M1,gamma);
        v_M2 = v_M(M2,gamma);
        theta = v_M2 - v_M1;
    case 2 % finding M1
        theta = input("Enter θ: ");
        M2 = input("Enter M2: ");
        v_M2 = v_M(M2,gamma);
        v_M1 = v_M2 - theta;
    case 3 % finding M2
        theta = input("Enter θ: ");
        M1 = input("Enter M1: ");
        v_M1 = v_M(M1,gamma);
        v_M2 = v_M1 + theta;
    case 0
        disp("Exiting Program...");
    otherwise
        fprintf("That is an invalid selection.");
end

if choice_ex == 1 || choice_ex == 2 || choice_ex == 3
        fprintf('\n\n');
        % since every case in the switch relies on computing mu (v) for M1
        % and M2, this function grabs the rest of the values, regardless of
        % whether M1 or M2 still needs to be found
        [M2,nu2,mu2,M1,nu1,mu1] = pmfunc(gamma,v_M1,v_M2);
        RML = mu2 - theta;
        % populate table
        Values(1) = M1;
        Values(2) = M2;
        Values(3) = theta;
        Values(4) = v_M2;
        Values(5) = v_M1;
        Values(6) = mu1;
        Values(7) = mu2;
        Values(8) = RML;
        
        % Create and output table
        output_table(Values, exRowLabels);
        fprintf("NOTE:" + ...
            "\tForward Mach line   = μ1\n" + ...
            "\t\tRear Mach Line (RML)= μ2 - θ\n\n");
        % Finding isentropic ratios for M1
        [P,r,T] = ratios(M1,gamma);
        fprintf("M1 = %4.3f   P01/P1 = %7.4f   rho01/rho1 = %7.4f   T01/T1 = %7.4f\n",M1,P,r,T);
        % Finding isentropic ratios for M2
        [P,r,T] = ratios(M2,gamma);
        fprintf("M2 = %4.3f   P02/P2 = %7.4f   rho02/rho2 = %7.4f   T02/T2 = %7.4f\n",M2,P,r,T);
        % format is %7.4f in case any ratios are greater than 10, ie the
        % left hand side of the decimal is double digits
end % end if
end % end expansion

% function that finds v_M by hand
%  can be done with flowprandtlmeyer(), but I wanted to include the exact
%  equation. Just using flowprandtlmeyer() for everything feels like
%  cheating
function [v_M] = v_M(M,gamma)
    v_M = sqrt((gamma+1)/(gamma-1))*atand(sqrt((gamma-1)/(gamma+1)*(M^2-1)))-...
        atand(sqrt(M^2-1));
end

% function to find everything based off of mu (v) for M2 and M1,
%  since every case involves finding these numbers first
function [M2,nu2,mu2,M1,nu1,mu1] = pmfunc(gamma,v_M1,v_M2)
    [M2,nu2,mu2] = flowprandtlmeyer(gamma,v_M2,'nu');
    [M1,nu1,mu1] = flowprandtlmeyer(gamma,v_M1,'nu');
end

% calculates the pressure, density, and temp ratios
function [P,r,T] = ratios(M,g)
    P = (1 + (g - 1)/2*M^2)^(g/(g-1));
    r = P^((g-1)/g);
    T = 1/((1/P)^(1/g));
end

% KNOWN EXAMPLES TO TEST WITH
% ----DELETE ONCE FULLY COMMITTED TO GITHUB---
% Comes from Fund. of Aero. 6th edition, Andersen

% NOTE: Example problems 9.9 thru 9.12 in the book all deal with expansion
% and the Prand-Meyer func. I've only included 9.9 and 9.12 since they give
% the most information to test with, whereas 10 and 11 ask for values you
% would otherwise calculate on your own

% Ex 9.12
% GIVEN
% theta = 5
% M1 = 3
% COMPUTES
% M2 = 3.27
% v2 = 54.76
% v1 = 49.76
% po1/p1 = 36.73


% Ex. 9.9
% GIVEN
% M1 = 1.5
% theta = 15
% COMPUTES
% M2 = 2.0 (rounded...)
% v1 = 11.91
% po1/p1 = 3.671   To1/T1 = 1.45

% NOTE: The book rounds M2, so despite being different from the MATLAB
% code, the book is actually less accurate. However, if you plug in theta =
% 15 and M2 = 2 as the book does, the p and T ratios for M2 become correct,
% and the p/T ratios for M1 become 'incorrect'

% po2/p2 = 7.824   To2/T2 = 1.8

% FML (same) = mu1 = 41.81
% RML = 15 (rounded)