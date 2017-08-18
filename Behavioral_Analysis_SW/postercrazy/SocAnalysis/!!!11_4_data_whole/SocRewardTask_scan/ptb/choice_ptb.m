if find(responsecode) == L_arrow %LEFT
    Screen('FrameRect',mywindow,red,LeftRect2,5);
    RT1 = GetSecs - RT1_start;
    press = 1;
    Screen('Flip', mywindow);
    press1_onset = GetSecs - startsecs;
    deckchoice = deckorder(1);
    choice = left_card_val;
    if left_card_val > right_card_val
        highval_count = highval_count + 1;
    end
elseif find(responsecode) == R_arrow %RIGHT
    Screen('FrameRect',mywindow,red,RightRect2,5);
    RT1 = GetSecs - RT1_start;
    press = 1;
    press1_onset = GetSecs - startsecs;
    Screen('Flip', mywindow);
    deckchoice = deckorder(2);
    choice = right_card_val;
    if right_card_val > left_card_val
        highval_count = highval_count + 1;
    end
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