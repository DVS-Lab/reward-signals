Screen('DrawTexture', mywindow, partner_texture, [], MiddleRect);
Screen('Flip', mywindow);
partner_onset = GetSecs - startsecs;
RT2_start = GetSecs; %start RT clock. add a second.