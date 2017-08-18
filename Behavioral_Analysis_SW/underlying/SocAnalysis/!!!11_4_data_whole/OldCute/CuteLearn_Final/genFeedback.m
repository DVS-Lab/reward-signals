if abs(find(responsecode) - L_arrow)<1.0e-12
    response = 1;
elseif abs(find(responsecode) - R_arrow)<1.0e-12
    response = 2;
end
currentLoc = exemplars(j,9);
    %determines if responce is correct
    if abs(currentLoc - response) < 1.0e-12
        correct = forceOut(j);
    else
        correct = 1 - forceOut(j);
    end