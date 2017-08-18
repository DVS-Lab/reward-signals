if find(responsecode) == L_arrow %LEFT
    Screen('FrameRect',screens.subjectW,red,package.positions.subject.frameL,5);
    RT1 = GetSecs - RT1_start;
    press = 1;
    if a(9) == 1 %force choice is on the left, cannot choose the right one
        Screen('DrawLine', screens.subjectW, red, package.positions.subject.frameR(1),package.positions.subject.frameR(2),package.positions.subject.frameR(3),package.positions.subject.frameR(4),4);
        Screen('DrawLine', screens.subjectW, red, package.positions.subject.frameR(3),package.positions.subject.frameR(2),package.positions.subject.frameR(1),package.positions.subject.frameR(4),4);
    shouldbe = L_arrow;
    else
        Screen('DrawLine', screens.subjectW, red, package.positions.subject.frameL(1),package.positions.subject.frameL(2),package.positions.subject.frameL(3),package.positions.subject.frameL(4),4);
        Screen('DrawLine', screens.subjectW, red, package.positions.subject.frameL(3),package.positions.subject.frameL(2),package.positions.subject.frameL(1),package.positions.subject.frameL(4),4);
    
    shouldbe = R_arrow;
    end
    Screen('Flip', screens.subjectW);
    press1_onset = GetSecs - startsecs;
    deckchoice = 1;
elseif find(responsecode) == R_arrow %RIGHT
    Screen('FrameRect',screens.subjectW,red,package.positions.subject.frameR,5);
    RT1 = GetSecs - RT1_start;
    press = 1;
    press1_onset = GetSecs - startsecs;
    if a(9) == 1 %force choice is on the left, cannot choose the right one
        Screen('DrawLine', screens.subjectW, red, package.positions.subject.frameR(1),package.positions.subject.frameR(2),package.positions.subject.frameR(3),package.positions.subject.frameR(4),4);
        Screen('DrawLine', screens.subjectW, red, package.positions.subject.frameR(3),package.positions.subject.frameR(2),package.positions.subject.frameR(1),package.positions.subject.frameR(4),4);
        shouldbe = L_arrow;
    else
        Screen('DrawLine', screens.subjectW, red, package.positions.subject.frameL(1),package.positions.subject.frameL(2),package.positions.subject.frameL(3),package.positions.subject.frameL(4),4);
        Screen('DrawLine', screens.subjectW, red, package.positions.subject.frameL(3),package.positions.subject.frameL(2),package.positions.subject.frameL(1),package.positions.subject.frameL(4),4);
        shouldbe = R_arrow;
    end
    
    Screen('Flip', screens.subjectW);
    deckchoice = 2;
elseif find(responsecode) == esc_key
    sca;
    run_time = GetSecs - startsecs;
    if exist('data','var')
        save(outputname, 'data','run_time');
    else
        save(outputname,'run_time');
    end
    return;
end