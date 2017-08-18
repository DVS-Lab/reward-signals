if block == 1
    frequency = 55;
    duration = 1750;
    stimaff = 1;
    stiminf = 0;
elseif block == 2
    frequency = 55;
    duration = 1750;
    stimaff = 0;
    stiminf = 1;
    % sham trials blocks 3-4 (will randomize of course)
elseif block == 3
    frequency = 55;
    duration = 250;
    stimaff = 1;
    stiminf = 0;
elseif block == 4
    frequency = 55;
    duration = 250;
    stimaff = 0;
    stiminf = 1;
end
