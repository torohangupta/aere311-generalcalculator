% AER E 311 Geenral Calculator
% Rohan Gupta

clear, clc, close all

%% Main Input/UI
   
% add dependency filepath
addpath("./dependencies");

    clear, clc
    selection = input("What do you want to calculate?\n\n" + ...
             " 1 | Isentropic Values\n" + ...
             " 2 | Normal Shock\n" + ...
             " 3 | Oblique Shock\n\n" + ...
             " 0 | Exit Program\n\n" + ...
             "Your choice: ");
    
    % function selector
    clc
    switch selection
        case 1
            fprintf("Isentropic Values Calculator\n\n");
            isentropic;
        case 2
            fprintf("Normal Shock Calculator\n\n");
            normalShock;
        case 3
            fprintf("Oblique Calculator\n\n");
            obliqueShock;
        case 0
            disp("Exiting Program...");
            selection = 0;
        otherwise
            fprintf("That is an invalid selection.");
    end