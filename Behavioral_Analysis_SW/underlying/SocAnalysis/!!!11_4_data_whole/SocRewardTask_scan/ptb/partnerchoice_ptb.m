if find(responsecode) == L_arrow | find(responsecode) == R_arrow | find(responsecode) == D_arrow
    Screen('FrameRect',mywindow,red,MiddleRect,5);
    RT2 = GetSecs - RT2_start;
    press = 1;
    press2_onset = GetSecs - startsecs;
    Screen('Flip', mywindow);
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